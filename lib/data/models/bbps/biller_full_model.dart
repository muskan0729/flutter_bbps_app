import 'input_param_model.dart';
import 'payment_mode_model.dart';
import 'payment_channel_model.dart';
import 'interchange_fee_model.dart';
import '../../../core/utils/json_utils.dart';

class BillerFullModel {
  final String billerId;
  final String billerAliasName;
  final String billerName;
  final String billerCategory;
  final bool billerAdhoc;
  final String billerCoverage;
  final String billerFetchRequiremet;
  final String billerPaymentExactness;
  final String billerSupportBillValidation;
  final List<InputParamGroup> billerInputParams;
  final String billerAmountOptions;
  final PaymentModeList billerPaymentModes;
  final String rechargeAmountInValidationRequest;
  final String billerDescription;
  final String supportPendingStatus;
  final String supportDeemed;
  final String billerTimeout;
  final List<PaymentChannelGroup> billerPaymentChannels;
  final List<dynamic> billerAdditionalInfo;
  final List<dynamic> billerAdditionalInfoPayment;
  final List<dynamic> planAdditionalInfo;
  final String planMdmRequirement;
  final String billerResponseType;
  final List<dynamic> billerPlanResponseParams;
  final InterchangeFee? interchangeFeeCCF1;
  final String billerStatus;

  BillerFullModel({
    required this.billerId,
    required this.billerAliasName,
    required this.billerName,
    required this.billerCategory,
    required this.billerAdhoc,
    required this.billerCoverage,
    required this.billerFetchRequiremet,
    required this.billerPaymentExactness,
    required this.billerSupportBillValidation,
    required this.billerInputParams,
    required this.billerAmountOptions,
    required this.billerPaymentModes,
    required this.rechargeAmountInValidationRequest,
    required this.billerDescription,
    required this.supportPendingStatus,
    required this.supportDeemed,
    required this.billerTimeout,
    required this.billerPaymentChannels,
    required this.billerAdditionalInfo,
    required this.billerAdditionalInfoPayment,
    required this.planAdditionalInfo,
    required this.planMdmRequirement,
    required this.billerResponseType,
    required this.billerPlanResponseParams,
    required this.interchangeFeeCCF1,
    required this.billerStatus,
  });

  factory BillerFullModel.fromJson(Map<String, dynamic> json) {
    return BillerFullModel(
      billerId: JsonUtils.asString(json['billerId']),
      billerAliasName: JsonUtils.asString(json['billerAliasName']),
      billerName: JsonUtils.asString(json['billerName']),
      billerCategory: JsonUtils.asString(json['billerCategory']),
      billerAdhoc: JsonUtils.asBool(json['billerAdhoc']),
      billerCoverage: JsonUtils.asString(json['billerCoverage']),
      billerFetchRequiremet: JsonUtils.asString(json['billerFetchRequiremet']),
      billerPaymentExactness: JsonUtils.asString(
        json['billerPaymentExactness'],
      ),
      billerSupportBillValidation: JsonUtils.asString(
        json['billerSupportBillValidation'],
      ),

      billerInputParams: JsonUtils.asList(
        json['billerInputParams'],
      ).map((e) => InputParamGroup.fromJson(JsonUtils.asMap(e) ?? {})).toList(),

      billerAmountOptions: JsonUtils.asString(json['billerAmountOptions']),

      billerPaymentModes: PaymentModeList.fromJson(
        JsonUtils.asMap(json['billerPaymentModes']) ?? {},
      ),

      rechargeAmountInValidationRequest: JsonUtils.asString(
        json['rechargeAmountInValidationRequest'],
      ),

      billerDescription: JsonUtils.asString(json['billerDescription']),
      supportPendingStatus: JsonUtils.asString(json['supportPendingStatus']),
      supportDeemed: JsonUtils.asString(json['supportDeemed']),
      billerTimeout: JsonUtils.asString(json['billerTimeout']),

      billerPaymentChannels: JsonUtils.asList(json['billerPaymentChannels'])
          .map((e) => PaymentChannelGroup.fromJson(JsonUtils.asMap(e) ?? {}))
          .toList(),

      interchangeFeeCCF1: JsonUtils.asMap(json['interchangeFeeCCF1']) != null
          ? InterchangeFee.fromJson(
              JsonUtils.asMap(json['interchangeFeeCCF1'])!,
            )
          : null,

      billerAdditionalInfo: JsonUtils.asList(json['billerAdditionalInfo']),
      billerAdditionalInfoPayment: JsonUtils.asList(
        json['billerAdditionalInfoPayment'],
      ),
      planAdditionalInfo: JsonUtils.asList(json['planAdditionalInfo']),
      billerPlanResponseParams: JsonUtils.asList(
        json['billerPlanResponseParams'],
      ),

      planMdmRequirement: JsonUtils.asString(json['planMdmRequirement']),
      billerResponseType: JsonUtils.asString(json['billerResponseType']),
      billerStatus: JsonUtils.asString(json['billerStatus']),
    );
  }
  @override
  String toString() {
    return '''
BillerFullModel(
  billerId: $billerId,
  billerAliasName: $billerAliasName,
  billerName: $billerName,
  billerCategory: $billerCategory,
  billerAdhoc: $billerAdhoc,
  billerCoverage: $billerCoverage,
  billerFetchRequiremet: $billerFetchRequiremet,
  billerPaymentExactness: $billerPaymentExactness,
  billerSupportBillValidation: $billerSupportBillValidation,
  billerAmountOptions: $billerAmountOptions,
  rechargeAmountInValidationRequest: $rechargeAmountInValidationRequest,
  billerDescription: $billerDescription,
  supportPendingStatus: $supportPendingStatus,
  supportDeemed: $supportDeemed,
  billerTimeout: $billerTimeout,
  planMdmRequirement: $planMdmRequirement,
  billerResponseType: $billerResponseType,
  billerStatus: $billerStatus,

  billerInputParams:
${billerInputParams.map((e) => e.toString()).join('\n')}

  billerPaymentModes:
$billerPaymentModes

  billerPaymentChannels:
${billerPaymentChannels.map((e) => e.toString()).join('\n')}

  interchangeFeeCCF1:
$interchangeFeeCCF1
)
''';
  }
}
