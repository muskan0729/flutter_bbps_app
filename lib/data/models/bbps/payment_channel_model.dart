class PaymentChannel {
  final String paymentChannelName;
  final double minAmount;
  final double maxAmount;

  PaymentChannel({
    required this.paymentChannelName,
    required this.minAmount,
    required this.maxAmount,
  });

  factory PaymentChannel.fromJson(Map<String, dynamic> json) {
    return PaymentChannel(
      paymentChannelName: json['paymentChannelName'],
      minAmount: double.parse(json['minAmount']),
      maxAmount: double.parse(json['maxAmount']),
    );
  }

  @override
  String toString() {
    return '''
  PaymentChannel(
    name: $paymentChannelName,
    min: $minAmount,
    max: $maxAmount
  )
''';
  }
}

class PaymentChannelGroup {
  final List<PaymentChannel> paymentChannelList;

  PaymentChannelGroup({required this.paymentChannelList});

  factory PaymentChannelGroup.fromJson(Map<String, dynamic> json) {
    final list = (json['paymentChannelList'] as List)
        .map((e) => PaymentChannel.fromJson(e))
        .toList();
    return PaymentChannelGroup(paymentChannelList: list);
  }

  @override
  String toString() {
    return '''
PaymentChannelGroup(
${paymentChannelList.map((e) => e.toString()).join('\n')}
)
''';
  }
}
