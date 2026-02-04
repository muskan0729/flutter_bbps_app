import 'package:flutter/cupertino.dart';

import 'bbps/biller_full_model.dart';

class BillerInfoModel {
  final BillerFullModel biller;

  BillerInfoModel({required this.biller});

  factory BillerInfoModel.fromJson(Map<String, dynamic> json) {
    debugPrint('data from Biller Fulll model');
    debugPrint( BillerFullModel.fromJson(json['biller'][0]).toString());
    return BillerInfoModel(biller: BillerFullModel.fromJson(json['biller'][0]));
  }

  @override
  String toString() {
    return '''
BillerInfoModel(
  biller: $biller
)
''';
  }
}
