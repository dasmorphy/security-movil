class LocationTechnical {
  String? address;
  int clientId;
  DateTime createdAt;
  String createdBy;
  int idLocation;
  String? lat;
  String? long;
  String name;
  DateTime updatedAt;
  String updatedBy;

  LocationTechnical({
    this.address,
    required this.clientId,
    required this.createdAt,
    required this.createdBy,
    required this.idLocation,
    this.lat,
    this.long,
    required this.name,
    required this.updatedAt,
    required this.updatedBy,
  });

  factory LocationTechnical.fromJson(Map<String, dynamic> json) =>
      LocationTechnical(
        address: json["address"],
        clientId: json["client_id"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        idLocation: json["id_location"],
        lat: json["lat"],
        long: json["long"],
        name: json["name"],
        updatedAt: DateTime.parse(json["updated_at"]),
        updatedBy: json["updated_by"],
      );

  Map<String, dynamic> toJson() => {
    "address": address,
    "client_id": clientId,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_location": idLocation,
    "lat": lat,
    "long": long,
    "name": name,
    "updated_at": updatedAt.toIso8601String(),
    "updated_by": updatedBy,
  };
}
