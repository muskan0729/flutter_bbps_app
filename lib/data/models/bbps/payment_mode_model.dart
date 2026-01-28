class PaymentMode {
  final String paymentModeName;
  final double minAmount;
  final double maxAmount;

  PaymentMode({
    required this.paymentModeName,
    required this.minAmount,
    required this.maxAmount,
  });

  factory PaymentMode.fromJson(Map<String, dynamic> json) {
    return PaymentMode(
      paymentModeName: json['paymentModeName'],
      minAmount: double.parse(json['minAmount']),
      maxAmount: double.parse(json['maxAmount']),
    );
  }

  @override
  String toString() {
    return '''
  PaymentMode(
    name: $paymentModeName,
    min: $minAmount,
    max: $maxAmount
  )
''';
  }
}

class PaymentModeList {
  final List<PaymentMode> paymentModeList;

  PaymentModeList({required this.paymentModeList});

  factory PaymentModeList.fromJson(Map<String, dynamic> json) {
    final list = (json['paymentModeList'] as List)
        .map((e) => PaymentMode.fromJson(e))
        .toList();
    return PaymentModeList(paymentModeList: list);
  }

  @override
  String toString() {
    return '''
PaymentModeList(
${paymentModeList.map((e) => e.toString()).join('\n')}
)
''';
  }
}
