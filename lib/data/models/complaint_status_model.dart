// ===============================
// REQUEST MODEL (Already correct)
// ===============================
class ComplaintStatusRequest {
  final String complaintType;
  final String complaintId;

  ComplaintStatusRequest({
    required this.complaintType,
    required this.complaintId,
  });

  Map<String, dynamic> toJson() => {
        "complaintType": complaintType,
        "complaintId": complaintId,
      };
}

// ===============================
// RESPONSE MODEL (ADD THIS)
// ===============================
class ComplaintStatusResponse {
  final String complaintAssigned;
  final String complaintId;
  final String complaintStatus;
  final String complaintResponseCode;
  final String complaintResponseReason;
  final String complaintRemarks;

  ComplaintStatusResponse({
    required this.complaintAssigned,
    required this.complaintId,
    required this.complaintStatus,
    required this.complaintResponseCode,
    required this.complaintResponseReason,
    required this.complaintRemarks,
  });

  factory ComplaintStatusResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintStatusResponse(
      complaintAssigned: json['complaintAssigned'] ?? '',
      complaintId: json['complaintId'] ?? '',
      complaintStatus: json['complaintStatus'] ?? '',
      complaintResponseCode: json['complaintResponseCode'] ?? '',
      complaintResponseReason: json['complaintResponseReason'] ?? '',
      complaintRemarks: json['complaintRemarks'] ?? '',
    );
  }
}
