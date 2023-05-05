class MappingUtils {
  String mapVietnameseDeliveryStatus(String status) {
    if (status.trim().toLowerCase().compareTo("pending") == 0) {
      return 'Đang chờ';
    } else if (status.trim().toLowerCase().compareTo("delivering") == 0) {
      return 'Đang vận chuyển';
    } else if (status.trim().toLowerCase().compareTo("completed") == 0) {
      return 'Hoàn tất';
    } else {
      return 'Lỗi trạng thái';
    }
  }

  String mapVietnameseNextDeliveryStatus(String status) {
    if (status.trim().toLowerCase().compareTo("pending") == 0) {
      return 'Đang vận chuyển';
    } else if (status.trim().toLowerCase().compareTo("delivering") == 0) {
      return 'Hoàn tất';
    } else if (status.trim().toLowerCase().compareTo("completed") == 0) {
      return 'Hoàn tất';
    } else {
      return 'Lỗi trạng thái';
    }
  }
}
