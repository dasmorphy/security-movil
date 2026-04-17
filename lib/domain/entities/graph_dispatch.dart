class GraphDispatch {
  int discrepancy;
  List<DispatchByStatus> dispatchByStatus;

  GraphDispatch({required this.discrepancy, required this.dispatchByStatus});

  int get totalRecords =>
      dispatchByStatus.fold(0, (sum, s) => sum + s.count);
 
  double get discrepancyPercentage =>
      totalRecords == 0 ? 0 : (discrepancy / totalRecords) * 100;
 
  int get okRecords => totalRecords - discrepancy;

  factory GraphDispatch.fromJson(Map<String, dynamic> json) => GraphDispatch(
    discrepancy: json["discrepancy"],
    dispatchByStatus: List<DispatchByStatus>.from(
      json["dispatch_by_status"].map((x) => DispatchByStatus.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "discrepancy": discrepancy,
    "dispatch_by_status": List<dynamic>.from(
      dispatchByStatus.map((x) => x.toJson()),
    ),
  };
}

class DispatchByStatus {
  int count;
  int idStatus;
  String statusName;

  DispatchByStatus({
    required this.count,
    required this.idStatus,
    required this.statusName,
  });

  factory DispatchByStatus.fromJson(Map<String, dynamic> json) =>
      DispatchByStatus(
        count: json["count"],
        idStatus: json["id_status"],
        statusName: json["status_name"],
      );

  Map<String, dynamic> toJson() => {
    "count": count,
    "id_status": idStatus,
    "status_name": statusName,
  };
}
