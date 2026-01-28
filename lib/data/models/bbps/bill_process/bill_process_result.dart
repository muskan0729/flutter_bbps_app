class BillProcessResult {
  final Map<String, String> inputParams;
  final int billAmount;

  BillProcessResult({required this.inputParams, required this.billAmount});

  factory BillProcessResult.fromApi(Map<String, dynamic> decrypted) {
    final inputs = <String, String>{};

    final inputList = decrypted['inputParams']?['input'] as List? ?? [];
    for (final i in inputList) {
      inputs[i['paramName']] = i['paramValue'];
    }
    final rawAmount = decrypted['billerResponse']?['billAmount'];

    return BillProcessResult(
      inputParams: inputs,
      billAmount: rawAmount is int
          ? rawAmount
          : int.tryParse(rawAmount?.toString() ?? '0') ?? 0,
    );
  }

  Map<String, dynamic> toPaymentPayload() {
    return {
      'inputParams': {
        'input': inputParams.entries
            .map((e) => {'paramName': e.key, 'paramValue': e.value})
            .toList(),
      },
      'billerResponse': {'billAmount': billAmount.toString()},
    };
  }
}
