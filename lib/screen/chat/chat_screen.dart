import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';

import '../../components/constants/color_constants.dart';
import '../../components/constants/firestore_constants.dart';
import '../../resource/controller/base_controller.dart';
import '../../resource/model/chat_message.dart';
import '../../resource/provider/chat_provider.dart';
import '../../utils/debouncer.dart';
import '../../utils/keyboard_util.dart';
import '../../utils/time_utils.dart';
import '../notification/list_notification_screen.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List chatList = [];
  List<QueryDocumentSnapshot> listChat = [];
  final ScrollController listScrollController = ScrollController();

  int _limit = 20;
  final int _limitIncrement = 20;
  String _textSearch = "";
  bool isLoading = false;
  bool isLoadingList = true;

  late final ChatProvider chatProvider = context.read<ChatProvider>();
  int? centerId;
  final firebaseStore = FirebaseFirestore.instance;
  final Debouncer searchDebouncer = Debouncer(milliseconds: 300);
  final StreamController<bool> btnClearController = StreamController<bool>();
  final TextEditingController searchController = TextEditingController();
  BaseController baseController = BaseController();

  @override
  void initState() {
    super.initState();
    _loadData();
    listScrollController.addListener(scrollListener);
  }

  @override
  void dispose() {
    super.dispose();
    btnClearController.close();
  }

  Future<void> _loadData() async {
    var id = await baseController.getInttoSharedPreference("CENTER_ID");
    print('center id load data: $id');

    var fromMsg = await firebaseStore
        .collection(FirestoreConstants.pathMessageCollection)
        .withConverter(
            fromFirestore: ((snapshot, _) =>
                MessageData.fromDocument(snapshot)),
            toFirestore: (MessageData msg, options) => msg.toJson())
        .where('idFrom', isEqualTo: centerId.toString())
        .get();

    print('fromMsg load data: ${fromMsg.docs}');

    var toMsg = await firebaseStore
        .collection(FirestoreConstants.pathMessageCollection)
        .withConverter(
            fromFirestore: ((snapshot, _) =>
                MessageData.fromDocument(snapshot)),
            toFirestore: (MessageData msg, options) => msg.toJson())
        .where('idTo', isEqualTo: centerId.toString())
        .get();

    print('toMsg load data: ${toMsg.docs}');
    setState(() {
      centerId = id;
      if (fromMsg.docs.isNotEmpty) {
        chatList.addAll(fromMsg.docs);
      }
      if (toMsg.docs.isNotEmpty) {
        chatList.addAll(toMsg.docs);
      }
    });
  }

  // Future<List> _loadData() async {
  //   centerId = await baseController.getInttoSharedPreference("CENTER_ID");
  //   print('center id load data: $centerId');

  //   var fromMsg = await firebaseStore
  //       .collection(FirestoreConstants.pathMessageCollection)
  //       .withConverter(
  //           fromFirestore: ((snapshot, _) =>
  //               MessageData.fromDocument(snapshot)),
  //           toFirestore: (MessageData msg, options) => msg.toJson())
  //       .where('idFrom', isEqualTo: centerId.toString())
  //       .get();

  //   print('fromMsg load data: ${fromMsg.docs}');

  //   var toMsg = await firebaseStore
  //       .collection(FirestoreConstants.pathMessageCollection)
  //       .withConverter(
  //           fromFirestore: ((snapshot, _) =>
  //               MessageData.fromDocument(snapshot)),
  //           toFirestore: (MessageData msg, options) => msg.toJson())
  //       .where('idTo', isEqualTo: centerId.toString())
  //       .get();

  //   print('toMsg load data: ${toMsg.docs}');
  //   //setState(() {
  //   if (fromMsg.docs.isNotEmpty) {
  //     chatList.addAll(fromMsg.docs);
  //   }
  //   if (toMsg.docs.isNotEmpty) {
  //     chatList.addAll(toMsg.docs);
  //   }
  //   //});
  //   print('chatList length: ${chatList.length}');
  //   return chatList;
  // }

  void scrollListener() {
    if (listScrollController.offset >=
            listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      setState(() {
        _limit += _limitIncrement;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (chatList.length > 0) {
    //   isLoadingList = false;
    // }
    return Scaffold(
      body: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 18, left: 16, right: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: textColor,
                      size: 24,
                    ),
                  ),
                  const Text(
                    'Tin nhắn',
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 27,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              child: const ListNotificationScreen(),
                              type: PageTransitionType.rightToLeftWithFade));
                    },
                    icon: const Icon(
                      Icons.notifications,
                      color: textColor,
                      size: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          buildSearchBar(),
          Flexible(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatProvider.getStreamFireStore(
                  _textSearch, centerId.toString()),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasData) {
                  listChat = snapshot.data!.docs;
                  if (listChat.length > 0) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemBuilder: (context, index) =>
                          buildMsgListItem(snapshot.data?.docs[index]),
                      itemCount: listChat.length,
                      controller: listScrollController,
                    );
                  } else {
                    return Column(
                      children: [
                        const SizedBox(height: 150),
                        SizedBox(
                          height: 150,
                          width: 150,
                          child:
                              Image.asset('assets/images/sticker/app_icon.png'),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          'Chưa có đoạn chat nào.',
                          style: TextStyle(fontSize: 18, color: textColor),
                        )
                      ],
                    );
                  }
                }
                return Column(
                  children: [
                    const SizedBox(height: 150),
                    SizedBox(
                      height: 150,
                      width: 150,
                      child: Image.asset('assets/images/sticker/app_icon.png'),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Chưa có đoạn chat nào.',
                      style: TextStyle(fontSize: 18, color: textColor),
                    )
                  ],
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget buildSearchBar() {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
      child: TextField(
        textInputAction: TextInputAction.search,
        controller: searchController,
        onChanged: (value) {
          searchDebouncer.run(() {
            if (value.isNotEmpty) {
              btnClearController.add(true);
              setState(() {
                _textSearch = value;
              });
            } else {
              btnClearController.add(false);
              setState(() {
                _textSearch = "";
              });
            }
          });
        },
        decoration: InputDecoration(
          hintText: 'Tìm kiếm',
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(
            Icons.search_rounded,
            color: Colors.grey.shade500,
            size: 20,
          ),
          // suffixIcon: StreamBuilder<bool>(
          //     stream: btnClearController.stream.asBroadcastStream(),
          //     builder: (context, snapshot) {
          //       return snapshot.data == true
          //           ? GestureDetector(
          //               onTap: () {
          //                 searchController.clear();
          //                 btnClearController.add(false);
          //                 setState(() {
          //                   _textSearch = "";
          //                 });
          //               },
          //               child: Icon(Icons.clear_rounded,
          //                   color: Colors.grey.shade500, size: 20))
          //           : SizedBox.shrink();
          //     }),
          filled: true,
          fillColor: Colors.grey.shade200,
          contentPadding: const EdgeInsets.all(8),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
        ),
        style: TextStyle(height: 1.7),
      ),
    );
  }

  Widget buildMsgListItem(DocumentSnapshot? item) {
    if (item != null) {
      MessageData data = MessageData.fromDocument(item);
      return GestureDetector(
        onTap: () {
          var idTo = '';
          var nameTo = '';
          var avatarTo = '';
          if (data.idFrom == centerId.toString()) {
            idTo = data.idTo;
            nameTo = data.nameTo;
            avatarTo = data.avatarTo;
          } else {
            idTo = data.idFrom;
            nameTo = data.nameFrom;
            avatarTo = data.avatarFrom;
          }
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return ChatDetailPage(
                  arguments: ChatPageArguments(
                      peerId: idTo, peerAvatar: avatarTo, peerNickname: nameTo),
                );
              },
            ),
          );
        },
        child: Container(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(data.idFrom == centerId.toString()
                    ? data.avatarTo
                    : data.avatarFrom),
                maxRadius: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Text(
                              data.idFrom == centerId.toString()
                                  ? data.nameTo
                                  : data.nameFrom,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                          Text(
                            TimeUtils().checkOver24Hours(
                                    DateFormat('dd/MM/yyyy HH:mm:ss').format(
                                        DateTime.parse(data.lastTimestamp)))
                                ? DateFormat('dd-MM')
                                    .format(DateTime.parse(data.lastTimestamp))
                                : DateFormat('HH:mm')
                                    .format(DateTime.parse(data.lastTimestamp)),
                            style: TextStyle(
                                fontSize: 13, color: Colors.grey.shade500),
                          )
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 260,
                        child: Text(
                          data.typeContent == 0
                              ? data.lastContent
                              : data.typeContent == 2
                                  ? '[Sticker]'
                                  : '[Hình ảnh]',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey.shade500),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
