import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../components/constants/color_constants.dart';

class FeedbackWidget extends StatelessWidget {
  final String avatar;
  final String orderID;
  final String name;
  final String date;
  final String content;
  final bool isLess;
  final GestureTapCallback press;
  final GestureTapCallback onTap;
  const FeedbackWidget(
      {super.key,
      required this.avatar,
      required this.orderID,
      required this.name,
      required this.content,
      required this.isLess,
      required this.press,
      required this.onTap,
      required this.date});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 45.0,
              width: 45.0,
              margin: const EdgeInsets.only(right: 16.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/placeholder.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(44.0),
              ),
            ),
            const SizedBox(height: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$name - #$orderID',
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                RatingBarIndicator(
                  rating: 4.5,
                  itemBuilder: (context, index) => const Icon(
                    Icons.star,
                    color: kPrimaryColor,
                  ),
                  itemCount: 5,
                  itemSize: 20,
                  direction: Axis.horizontal,
                ),
                const SizedBox(height: 10),
                Text(
                  date,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: press,
                  child: isLess
                      ? SizedBox(
                          width: MediaQuery.of(context).size.width * .74,
                          child: Text(
                            content,
                            style: const TextStyle(
                              fontSize: 17,
                              color: textColor,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: MediaQuery.of(context).size.width * .7,
                          child: Text(
                            content,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 17,
                              color: textColor,
                            ),
                          ),
                        ),
                ),
                // const SizedBox(height: 10),
                // GestureDetector(
                //     onTap: press,
                //     child: Text(
                //       isLess ? 'Ẩn bớt' : 'Xem thêm',
                //       style: const TextStyle(color: textNoteColor),
                //       textAlign: TextAlign.right,
                //     )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
