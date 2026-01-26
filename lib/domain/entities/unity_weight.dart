class UnityWeight {
  final int idUnity;
  final String name;
  final String code;
  final String createdAt;
  final String updatedAt;

  UnityWeight({
    required this.idUnity, 
    required this.name, 
    required this.code, 
    required this.createdAt, 
    required this.updatedAt
  });

  factory UnityWeight.fromJson(Map<String, dynamic> json) => UnityWeight(
    idUnity: json['id_unity'],
    name: json['name'],
    code: json['code'],
    createdAt: json['created_at'],
    updatedAt: json['updated_at'],
  );

}