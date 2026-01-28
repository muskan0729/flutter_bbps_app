class JsonUtils {
  static Map<String, dynamic>? asMap(dynamic v) {
    return v is Map<String, dynamic> ? v : null;
  }

  static List asList(dynamic v) {
    return v is List ? v : const [];
  }

  static String asString(dynamic v, [String def = '']) {
    return v?.toString() ?? def;
  }

  static bool asBool(dynamic v, [bool def = false]) {
    if (v == null) return def;
    if (v is bool) return v;
    return v.toString().toLowerCase() == 'true';
  }

  static double asDouble(dynamic v, [double def = 0]) {
    if (v == null) return def;
    return double.tryParse(v.toString()) ?? def;
  }

  static int asInt(dynamic v, [int def = 0]) {
    if (v == null) return def;
    return int.tryParse(v.toString()) ?? def;
  }
}
