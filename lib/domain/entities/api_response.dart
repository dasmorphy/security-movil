class ApiResponse<T> {
  final bool success;
  final String? message;
  final dynamic errorCode;
  final T? data;
  final String? externalTransactionId;
  final String? internalTransactionId;

  ApiResponse({
    required this.success,
    this.message,
    this.errorCode,
    this.data,
    this.externalTransactionId,
    this.internalTransactionId,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) => ApiResponse(
    data: json["data"],
    errorCode: json["error_code"],
    externalTransactionId: json["external_transaction_id"],
    internalTransactionId: json["internal_transaction_id"],
    message: json["message"],
    success: json["success"] ?? false,
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "error_code": errorCode,
    "external_transaction_id": externalTransactionId,
    "internal_transaction_id": internalTransactionId,
    "message": message,
    "success": success,
  };
}
