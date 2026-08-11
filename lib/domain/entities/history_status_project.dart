import 'package:zentinel/domain/entities/task_technical.dart';

class HistoryStatusProject {
  String commentary;
  DateTime createdAt;
  String createdBy;
  int idHistory;
  String previousStatus;
  String status;
  TaskTechnical task;
  int techTaskId;

  HistoryStatusProject({
    required this.commentary,
    required this.createdAt,
    required this.createdBy,
    required this.idHistory,
    required this.previousStatus,
    required this.status,
    required this.task,
    required this.techTaskId,
  });

  factory HistoryStatusProject.fromJson(Map<String, dynamic> json) =>
      HistoryStatusProject(
        commentary: json["commentary"],
        createdAt: DateTime.parse(json["created_at"]),
        createdBy: json["created_by"],
        idHistory: json["id_history"],
        previousStatus: json["previous_status"],
        status: json["status"],
        task: TaskTechnical.fromJson(json["task"]),
        techTaskId: json["tech_task_id"],
      );

  Map<String, dynamic> toJson() => {
    "commentary": commentary,
    "created_at": createdAt.toIso8601String(),
    "created_by": createdBy,
    "id_history": idHistory,
    "previous_status": previousStatus,
    "status": status,
    "task": task.toJson(),
    "tech_task_id": techTaskId,
  };
}