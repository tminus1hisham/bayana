extension SentenceCase on String {
  String get sentenceCase {
    final text = replaceAll(RegExp(r'\s+'), ' ').trim();
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
}
