// ignore_for_file: public_member_api_docs, sort_constructors_first
class Notification {
  String content;
  String day;
  Notification({
    required this.content,
    required this.day,
  });
}

List<Notification> listNoti = [
  Notification(
      content: 'Đơn hàng #ID của bạn đã được chấp nhận',
      day: '27/03/2023 10:43:57'),
  Notification(
      content: 'Đơn hàng #ID của bạn đã hoàn thành xong',
      day: '26/03/2023 23:43:57'),
  Notification(
      content: 'Đơn hàng #ID của bạn đang được xử lý',
      day: '01/04/2023 15:43:57'),
  Notification(
      content: 'Đơn hàng #ID của bạn đã được chấp nhận',
      day: '02/04/2023 07:43:57'),
  Notification(
      content: 'Đơn hàng #ID của bạn đang được giao',
      day: '27/03/2023 16:43:57'),
];
