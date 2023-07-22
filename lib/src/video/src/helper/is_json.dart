import 'dart:convert';

bool isJson(String input) {
  try {
    return jsonDecode(input) && input.isNotEmpty;
  } catch (error) {
    return false;
  }
}
