import 'package:chat_application/UI/components/user_tile.dart';
import 'package:chat_application/constants/color_constants.dart';
import 'package:chat_application/di/app_initializer.dart';
import 'package:chat_application/model/ChatUser.dart';
import 'package:chat_application/repository/app_repository.dart';
import 'package:chat_application/routing/routes.dart';
import 'package:chat_application/utils/utilities.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _repository = AppInitializer.getIt<AppRepository>();
  @override
  void initState() {
    _repository.getUserData().onError((error, stackTrace) {
      showToast(message: error.toString());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: _buildAppBar(),
        body: _buildBody(),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      leading: const Icon(Icons.person),
      backgroundColor: ColorConstants.blue10,
      title: Text(getUserName()),
    );
  }

  Widget _buildBody() {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.connectionState == ConnectionState.active) {
          if (!snapshot.hasData) {
            return centerText(text: 'SnapshotData Error : No data found');
          } else if (snapshot.hasData) {
            Future.delayed(const Duration(seconds: 1));
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var user = ChatUser.fromJson(snapshot.data!.docs[index].data());
                user.ref = snapshot.data!.docs[index].id;
                if (user.email == FirebaseAuth.instance.currentUser?.email) {
                  return const Center();
                } else {
                  return UserTile(
                      user: user,
                      onTap: () {
                        // print('Self :: ${UserData.user.ref}');
                        // print('Other :: ${user.ref}');
                        Navigator.pushNamed(context, Routes.chatsRoute,
                            arguments: user.ref);
                      });
                }
              },
            );
          } else if (snapshot.hasError) {
            return centerText(
                text: 'SnapshotData Error : ${snapshot.error.toString()}');
          } else {
            return centerText(text: 'SnapshotData Error : Unknown');
          }
        }
        return centerText(
            text: 'ConnectionState Error : ${snapshot.connectionState}');
      },
    );
  }
}
