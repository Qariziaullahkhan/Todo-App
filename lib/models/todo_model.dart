class TodoModel {
  final int id;
  final String name;
  final String value;
  final String status;
  final String user;
  final String createdAt;
  final String updatedAt;

  TodoModel({
    required this.id,
    required this.name,
    required this.value,
    required this.status,
    required this.user,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      name: json['name'] ?? '', // Added name field
      value: json['value'] ?? '',
      status: json['status'] ?? 'open',
      user: json['user'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}