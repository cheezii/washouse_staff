import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:washouse_staff/resource/model/feedback.dart';

import '../../components/constants/color_constants.dart';

class FeedbackDetailsScreen extends StatelessWidget {
  final FeedbackModel feedback;
  const FeedbackDetailsScreen({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: textColor,
            size: 24,
          ),
        ),
        centerTitle: true,
        title: const Text('Chi tiết đánh giá', style: TextStyle(color: textColor, fontSize: 25)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mã đơn: #${feedback.orderId}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tên khách hàng: ${feedback.accountName}',
                  style: TextStyle(fontSize: 17, color: textColor),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ngày đánh giá: ${feedback.createdDate}',
                  style: TextStyle(fontSize: 17, color: textColor),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              alignment: Alignment.center,
              child: RatingBarIndicator(
                rating: feedback.rating!.toDouble(),
                itemBuilder: (context, index) => const Icon(
                  Icons.star,
                  color: kPrimaryColor,
                ),
                itemCount: 5,
                itemSize: 35,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                direction: Axis.horizontal,
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nội dung đánh giá',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(8),
                  width: 360,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade500,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${feedback.content}',
                    style: TextStyle(fontSize: 16, color: textColor),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Dịch vụ đã đặt',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                ListView.separated(
                  padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                  itemCount: 4,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      child: Row(
                        children: [
                          Text(
                            'tên dịch vụ',
                            style: TextStyle(fontSize: 17),
                          ),
                          const Spacer(),
                          RatingBarIndicator(
                            rating: 4.5,
                            itemBuilder: (context, index) => const Icon(
                              Icons.star,
                              color: kPrimaryColor,
                            ),
                            itemCount: 5,
                            itemSize: 25,
                            direction: Axis.horizontal,
                          ),
                        ],
                      ),
                    );
                  }),
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 1,
                      color: Colors.grey.shade300,
                    );
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
