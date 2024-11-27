extension StringCasingExtension on String {
  String get toCapitalized =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String get toTitleCase => trim() // Remove leading/trailing spaces
      .split(RegExp(r'\s+')) // Split by one or more spaces
      .map((word) => word.toCapitalized)
      .join(' ');
}
