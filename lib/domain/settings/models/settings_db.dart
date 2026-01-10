//--------SETTINGS MODEL--------//
// Simple key-value settings model (Drift handles DB operations)

class SettingsDBValue {
  int? id;
  late String name;
  String? value;

  SettingsDBValue({
    this.id,
    required this.name,
    this.value,
  });
}
