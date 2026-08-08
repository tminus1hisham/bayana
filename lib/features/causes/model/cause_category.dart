enum CauseCategory {
  health('Health'),
  education('Education'),
  emergency('Emergency'),
  environment('Environment'),
  empowerment('Empowerment');

  const CauseCategory(this.label);

  final String label;

  static CauseCategory fromUserId(int userId) {
    final index = (userId - 1) % values.length;
    return values[index < 0 ? index + values.length : index];
  }
}
