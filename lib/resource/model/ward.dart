// ignore_for_file: public_member_api_docs, sort_constructors_first
class Ward {
  int id;
  String name;
  Ward({
    required this.id,
    required this.name,
  });

  @override
  bool operator ==(dynamic other) {
    return other is Ward && id == other.id;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }

  factory Ward.fromJson(Map<String, dynamic> json) {
    return Ward(
      id: json['wardId'],
      name: json['wardName'],
    );
  }
}
