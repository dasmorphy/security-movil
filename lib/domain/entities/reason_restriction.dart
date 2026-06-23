class ReasonRestriction {
  DateTime createdAt;
  String createdBy;
  int idReason;
  String reason;

  ReasonRestriction({
    required this.createdAt,
    required this.createdBy,
    required this.idReason,
    required this.reason,
  });

  factory ReasonRestriction.fromJson(Map<String, dynamic> json) =>
      ReasonRestriction(
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        idReason: json["id_reason"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_reason": idReason,
    "reason": reason,
  };
}
