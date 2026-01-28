class InterchangeFee {
  final String feeCode;
  final String feeDirection;
  final double flatFee;
  final double percentFee;
  final double feeMinAmt;
  final double feeMaxAmt;

  InterchangeFee({
    required this.feeCode,
    required this.feeDirection,
    required this.flatFee,
    required this.percentFee,
    required this.feeMinAmt,
    required this.feeMaxAmt,
  });

  factory InterchangeFee.fromJson(Map<String, dynamic> json) {
    return InterchangeFee(
      feeCode: json['feeCode'],
      feeDirection: json['feeDirection'],
      flatFee: double.parse(json['flatFee']),
      percentFee: double.parse(json['percentFee']),
      feeMinAmt: double.parse(json['feeMinAmt'].toString()),
      feeMaxAmt: double.parse(json['feeMaxAmt'].toString()),
    );
  }

  @override
  String toString() {
    return '''
InterchangeFee(
  code: $feeCode,
  direction: $feeDirection,
  flatFee: $flatFee,
  percentFee: $percentFee,
  min: $feeMinAmt,
  max: $feeMaxAmt
)
''';
  }
}
