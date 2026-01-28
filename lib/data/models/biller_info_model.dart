import 'bbps/biller_full_model.dart';

class BillerInfoModel {
  final BillerFullModel biller;

  BillerInfoModel({required this.biller});

  factory BillerInfoModel.fromJson(Map<String, dynamic> json) {
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
