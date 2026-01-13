class BillerModel {
  final String blrId;
  final String blrName;

  BillerModel({required this.blrId, required this.blrName});

  factory BillerModel.fromJson(Map<String, dynamic> json) {
    return BillerModel(blrId: json['blr_id'], blrName: json['blr_name']);
  }
}
