import 'package:flutter/material.dart';
import '../../../data/models/biller_info_model.dart';

class BillerInfoRawView extends StatelessWidget {
  final BillerInfoModel billerInfo;

  const BillerInfoRawView({super.key, required this.billerInfo});

  @override
  Widget build(BuildContext context) {
    return SelectableText(
      billerInfo.toString(),
      style: const TextStyle(fontSize: 13, fontFamily: 'monospace'),
    );
  }
}