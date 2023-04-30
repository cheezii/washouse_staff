import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../components/constants/color_constants.dart';

class FeedbackServiceScreen extends StatefulWidget {
  const FeedbackServiceScreen({super.key});

  @override
  State<FeedbackServiceScreen> createState() => _FeedbackServiceScreenState();
}

class _FeedbackServiceScreenState extends State<FeedbackServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: 2,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Phân loại',
              style: TextStyle(fontSize: 17),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: 4,
              shrinkWrap: true,
              itemBuilder: (context, serviceIndex) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        'tên dịch vụ',
                        style: TextStyle(fontSize: 16),
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
              },
            ),
          ],
        );
      },
      separatorBuilder: (context, index) {
        return Divider(
          thickness: 1,
          color: Colors.grey.shade300,
        );
      },
    );
  }
}
