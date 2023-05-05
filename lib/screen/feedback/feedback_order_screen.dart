import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:page_transition/page_transition.dart';
import 'package:washouse_staff/resource/controller/feedback_controller.dart';
import 'package:washouse_staff/screen/feedback/feedback_details_screen.dart';

import '../../components/constants/color_constants.dart';
import '../../resource/model/feedback.dart';
import 'component/feedback_widget.dart';

class FeedbackOrderScreen extends StatefulWidget {
  const FeedbackOrderScreen({super.key});

  @override
  State<FeedbackOrderScreen> createState() => _FeedbackOrderScreenState();
}

class _FeedbackOrderScreenState extends State<FeedbackOrderScreen> {
  FeedbackController feedbackController = FeedbackController();
  bool isMore = true;
  bool isLoading = false;
  List<FeedbackModel> feedbackList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Wait for getOrderInformation to complete
      var feedbacks = await feedbackController.getCenterFeedback();
      if (feedbacks != null) {
        setState(() {
          // Update state with loaded data
          feedbackList = feedbacks.where((element) => element.orderId != null).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle error
      setState(() {
        isLoading = false;
      });
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: LoadingAnimationWidget.prograssiveDots(color: kPrimaryColor, size: 50),
      );
    } else {
      return ListView.separated(
        padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
        itemCount: feedbackList.length,
        shrinkWrap: true,
        itemBuilder: ((context, index) {
          return FeedbackWidget(
            avatar: (feedbackList[index].accountAvatar == null) ? 'avatar Người dùng' : feedbackList[index].accountAvatar!,
            name: (feedbackList[index].accountName == null) ? 'Người dùng' : feedbackList[index].accountName!,
            orderID: feedbackList[index].orderId!,
            date: feedbackList[index].createdDate!,
            content: (feedbackList[index].content == null) ? '' : feedbackList[index].content!,
            press: () => setState(() {
              isMore = !isMore;
            }),
            isLess: isMore,
            onTap: () =>
                Navigator.push(context, PageTransition(child: FeedbackDetailsScreen(feedback: feedbackList[index]), type: PageTransitionType.fade)),
          );
        }),
        separatorBuilder: (context, index) {
          return Divider(
            thickness: 1,
            color: Colors.grey.shade300,
          );
        },
      );
    }
  }
}
