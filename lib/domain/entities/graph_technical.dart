class GraphTechnical {
  AuditingPercentaje? auditingPercentaje;
  List<CountStatus>? countStatus;

  GraphTechnical({this.auditingPercentaje, this.countStatus});

  factory GraphTechnical.fromJson(Map<String, dynamic> json) => GraphTechnical(
    auditingPercentaje: json["auditing_percentaje"] == null
        ? null
        : AuditingPercentaje.fromJson(json["auditing_percentaje"]),
    countStatus: json["count_status"] == null
        ? []
        : List<CountStatus>.from(
            json["count_status"]!.map((x) => CountStatus.fromJson(x)),
          ),
  );

  Map<String, dynamic> toJson() => {
    "auditing_percentaje": auditingPercentaje?.toJson(),
    "count_status": countStatus == null
        ? []
        : List<dynamic>.from(countStatus!.map((x) => x.toJson())),
  };
}

class AuditingPercentaje {
  int? audited;
  int? auditedPercentage;
  int? notAudited;
  int? notAuditedPercentage;
  int? total;

  AuditingPercentaje({
    this.audited,
    this.auditedPercentage,
    this.notAudited,
    this.notAuditedPercentage,
    this.total,
  });

  factory AuditingPercentaje.fromJson(Map<String, dynamic> json) {
    return AuditingPercentaje(
      audited: (json["audited"] as num?)?.toInt(),
      auditedPercentage:
          (json["audited_percentage"] as num?)?.toInt(),
      notAudited: (json["not_audited"] as num?)?.toInt(),
      notAuditedPercentage:
          (json["not_audited_percentage"] as num?)?.toInt(),
      total: (json["total"] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
    "audited": audited,
    "audited_percentage": auditedPercentage,
    "not_audited": notAudited,
    "not_audited_percentage": notAuditedPercentage,
    "total": total,
  };
}

class CountStatus {
  int? count;
  String? status;

  CountStatus({this.count, this.status});

  factory CountStatus.fromJson(Map<String, dynamic> json) =>
      CountStatus(count: json["count"], status: json["status"]);

  Map<String, dynamic> toJson() => {"count": count, "status": status};
}
