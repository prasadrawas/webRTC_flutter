import 'package:chat_application/data/user_data.dart';
import 'package:chat_application/model/Message.dart';
import 'package:chat_application/utils/utilities.dart';
import 'package:chat_application/viewmodel/chats/chats_view_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/color_constants.dart';

class ChatsView extends StatefulWidget {
  final String ref;

  const ChatsView({Key? key, required this.ref}) : super(key: key);

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  ChatsViewModel? _viewModel;
  // final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel = Provider.of<ChatsViewModel>(context, listen: false);
      _viewModel?.getUserDataByRef(ref: widget.ref);
      // _scrollToBottom();
    });
  }

  // void _scrollToBottom() {
  //   _controller.animateTo(
  //     _controller.position.maxScrollExtent,
  //     duration: Duration(seconds: 2),
  //     curve: Curves.fastOutSlowIn,
  //   );
  // }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: ColorConstants.blue10,
      title: Text(_viewModel?.user?.name ?? 'No Name'),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(UserData.user.ref);
    print(_viewModel?.user?.ref);
    return Scaffold(
      body: Consumer<ChatsViewModel>(
        builder: (context, controller, __) {
          return controller.isLoading
              ? _buildLoadingScreen()
              : _buildChatScreen(context);
        },
      ),
    );
  }

  Scaffold _buildChatScreen(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: _buildChatsList(context),
      ),
      bottomNavigationBar: _chatTextField(),
    );
  }

  Scaffold _buildLoadingScreen() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Container _chatTextField() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 4,
            child: SizedBox(
              height: 55,
              child: TextFormField(
                controller: _viewModel?.messageController,
                autocorrect: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50)),
                  hintText: 'Type your message here ',
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: IconButton(
              onPressed: () {
                _viewModel?.sendMessage();
              },
              icon: const Icon(
                Icons.send,
                color: ColorConstants.darkYellow,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatsList(BuildContext context) {
    final ref = FirebaseDatabase.instance
        .ref('users')
        .child(UserData.user.ref ?? '')
        .child(_viewModel?.user?.ref ?? '');

    return FirebaseAnimatedList(
        // sort: (DataSnapshot a, DataSnapshot b) =>
        //     b.key!.compareTo(a.key ?? ''), //fixed
        // reverse: true, //fixed
        // controller: _controller,
        query: ref,
        itemBuilder: ((context, snapshot, animation, index) {
          Message message = Message(
            message: snapshot.child('message').value.toString(),
            token: snapshot.child('token').value.toString(),
            sentFrom: int.parse(snapshot.child('sentFrom').value.toString()),
          );

          if (message.sentFrom! == 0) {
            return _sendersMsg(context, message);
          } else {
            return _receivesMsg(context, message);
          }
        }));

    return StreamBuilder(
        stream: FirebaseDatabase.instance
            .ref(UserData.user.ref ?? '')
            .child(_viewModel?.user?.ref ?? '')
            .onValue,
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.data != null &&
              (snapshot.data!).snapshot.value != null) {
            final myMessages = Map<dynamic, dynamic>.from(
                (snapshot.data!).snapshot.value as Map<dynamic, dynamic>);
            return ListView.builder(
              itemCount: myMessages.length,
              itemBuilder: (context, index) {
                var message = Message.fromJson(myMessages[0]);
                if (message.sentFrom! == 0) {
                  return _receivesMsg(context, message);
                } else {
                  return _sendersMsg(context, message);
                }
              },
            );
          } else {
            return centerText(text: 'SnapshotData Error : Unknown');
          }
        });
  }

  Row _receivesMsg(BuildContext context, Message msg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Material(
            elevation: 5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: const BoxDecoration(
                color: ColorConstants.blue10,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Text(
                msg.message!,
                maxLines: 10,
                style: const TextStyle(color: ColorConstants.white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Row _sendersMsg(BuildContext context, Message msg) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
          child: Material(
            elevation: 5,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            child: Container(
              padding: const EdgeInsets.all(15),
              width: MediaQuery.of(context).size.width * 0.65,
              decoration: const BoxDecoration(
                color: ColorConstants.green10,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Text(
                msg.message!,
                maxLines: 10,
                style: TextStyle(color: ColorConstants.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/*if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.connectionState == ConnectionState.active) {
            if (!snapshot.hasData) {
              return centerText(text: 'SnapshotData Error : No data found');
            } else if (snapshot.hasData) {
              var map = snapshot.data?.snapshot.value;
              var keys = map.keys;
              return ListView.builder(
                itemCount: snapshot.data?.snapshot.value,
                itemBuilder: (context, index) {
                  var user =
                      ChatUser.fromJson(snapshot.data!.docs[index].data());
                  user.ref = snapshot.data!.docs[index].id;
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, i) {
                      if (i % 2 == 0) {
                        return _receivesMsg(context, _messages[i]);
                      } else {
                        return _sendersMsg(context, _messages[i]);
                      }
                    },
                    separatorBuilder: (_, i) {
                      return verticalSpacing(20);
                    },
                    itemCount: _messages.length,
                  );
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
              text: 'ConnectionState Error : ${snapshot.connectionState}');*/
