class AllRound {
  DateTime createdAt;
  String createdBy;
  int idRoundRegister;
  List<String> images;
  String lat;
  String long;
  dynamic nameSector;
  String observations;
  bool outRound;
  dynamic pool;
  dynamic roundId;
  dynamic sectorPoolId;

  AllRound({
    required this.createdAt,
    required this.createdBy,
    required this.idRoundRegister,
    required this.images,
    required this.lat,
    required this.long,
    required this.nameSector,
    required this.observations,
    required this.outRound,
    required this.pool,
    required this.roundId,
    required this.sectorPoolId,
  });

  factory AllRound.fromJson(Map<String, dynamic> json) => AllRound(
    createdAt: DateTime.parse(json["created_at"]),
    createdBy: json["created_by"],
    idRoundRegister: json["id_round_register"],
    images: List<String>.from(json["images"].map((x) => x)),
    lat: json["lat"],
    long: json["long"],
    nameSector: json["name_sector"],
    observations: json["observations"],
    outRound: json["out_round"],
    pool: json["pool"],
    roundId: json["round_id"],
    sectorPoolId: json["sector_pool_id"],
  );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_round_register": idRoundRegister,
    "images": List<dynamic>.from(images.map((x) => x)),
    "lat": lat,
    "long": long,
    "name_sector": nameSector,
    "observations": observations,
    "out_round": outRound,
    "pool": pool,
    "round_id": roundId,
    "sector_pool_id": sectorPoolId,
  };
}
