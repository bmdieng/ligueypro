String safeDecodeUriComponent(String value) {
  if (value.isEmpty) {
    return value;
  }

  try {
    return Uri.decodeComponent(value);
  } on ArgumentError {
    return value;
  } on FormatException {
    return value;
  }
}
