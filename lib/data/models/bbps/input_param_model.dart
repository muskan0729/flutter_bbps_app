class InputParam {
  final String? paramName;
  final String? dataType;
  final bool isOptional;
  final int? minLength;
  final int? maxLength;
  final String? regEx;
  final String? values;
  final bool visible;

  InputParam({
    this.paramName,
    this.dataType,
    this.isOptional = false,
    this.minLength,
    this.maxLength,
    this.regEx,
    this.values,
    this.visible = true,
  });

  factory InputParam.fromJson(Map<String, dynamic> json) {
    return InputParam(
      paramName: json['paramName'],
      dataType: json['dataType'],
      isOptional: json['isOptional']?.toString() == 'true' ? true : false,
      minLength: json['minLength'] != null
          ? int.tryParse(json['minLength'].toString())
          : null,
      maxLength: json['maxLength'] != null
          ? int.tryParse(json['maxLength'].toString())
          : null,
      regEx: json['regEx'],
      values: json['values'],
      visible: json['visibility']?.toString() == 'true' ? true : true,
    );
  }

  @override
  String toString() {
    return '''
InputParam(
  name: $paramName,
  type: $dataType,
  optional: $isOptional,
  minLength: $minLength,
  maxLength: $maxLength,
  regEx: $regEx,
  values: $values,
  visible: $visible
)
''';
  }
}

class InputParamGroup {
  final List<InputParam> paramsList;

  InputParamGroup({required this.paramsList});

  factory InputParamGroup.fromJson(Map<String, dynamic> json) {
    final params = (json['paramsList'] as List? ?? [])
        .map((e) => InputParam.fromJson(e))
        .toList();
    return InputParamGroup(paramsList: params);
  }

  @override
  String toString() {
    return '''
InputParamGroup(
${paramsList.map((e) => e.toString()).join('\n')}
)
''';
  }
}
