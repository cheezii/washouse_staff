final _processes = [
  'Đang chờ',
  'Xác nhận',
  'Xử lý',
  'Sẵn sàng',
  'Hoàn tất',
];

class OrderUtils {
  String mapVietnameseOrderStatus(String status) {
    if (status.trim().toLowerCase().compareTo("pending") == 0) {
      return 'Đang chờ';
    } else if (status.trim().toLowerCase().compareTo("confirmed") == 0) {
      return 'Xác nhận';
    } else if (status.trim().toLowerCase().compareTo("received") == 0) {
      return 'Đã nhận';
    } else if (status.trim().toLowerCase().compareTo("processing") == 0) {
      return 'Xử lý';
    } else if (status.trim().toLowerCase().compareTo("ready") == 0) {
      return 'Sẵn sàng';
    } else if (status.trim().toLowerCase().compareTo("completed") == 0) {
      return 'Hoàn tất';
    } else if (status.trim().toLowerCase().compareTo("cancelled") == 0) {
      return 'Đã hủy';
    } else {
      return 'Not match status';
    }
  }

  String mapVietnameseOrderDetailStatus(String status) {
    if (status.trim().toLowerCase().compareTo("pending") == 0) {
      return 'Đang chờ';
    } else if (status.trim().toLowerCase().compareTo("received") == 0) {
      return 'Đã nhận';
    } else if (status.trim().toLowerCase().compareTo("processing") == 0) {
      return 'Xử lý';
    } else if (status.trim().toLowerCase().compareTo("completed") == 0) {
      return 'Hoàn tất';
    } else if (status.trim().toLowerCase().compareTo("cancelled") == 0) {
      return 'Đã hủy';
    } else {
      return 'Not match status';
    }
  }
}
