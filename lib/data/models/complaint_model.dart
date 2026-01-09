class ComplaintRequest {
  final String complaintType;
  final String participationType;
  final String agentId;
  final String billerId;
  final String servReason;
  final String complainDesc;
  final String txnRefId;
  final String complaintDisposition;

  ComplaintRequest({
    required this.complaintType,
    this.participationType = "",
    this.agentId = "",
    this.billerId = "",
    this.servReason = "",
    required this.complainDesc,
    required this.txnRefId,
    required this.complaintDisposition,
  });

  Map<String, dynamic> toJson() => {
        "complaintType": complaintType,
        "participationType": participationType,
        "agentId": agentId,
        "billerId": billerId,
        "servReason": servReason,
        "complainDesc": complainDesc,
        "txnRefId": txnRefId,
        "complaintDisposition": complaintDisposition,
      };
}
