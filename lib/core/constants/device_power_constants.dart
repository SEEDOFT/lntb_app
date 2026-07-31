/// Per-device power draw in watts used for runtime energy estimation.
///
/// These values are declared in the app (not entered by the user). Change
/// them here to adjust every estimate across the app.
library;

const int kFanPowerWatts = 85;
const int kRoofPowerWatts = 60;
const int kCameraPowerWatts = 12;
const int kWaterPumpPowerWatts = 750;
const int kControllerPowerWatts = 120;

/// Rated power in watts keyed by device type code.
const Map<String, int> kDeviceTypePowerWatts = {
  'fan': kFanPowerWatts,
  'roof': kRoofPowerWatts,
  'camera': kCameraPowerWatts,
  'water_energy_meter': kWaterPumpPowerWatts,
  'smart_farm_controller': kControllerPowerWatts,
};

/// Khmer display names for the seeded demo devices.
///
/// Device names are user-editable, so unknown names fall back to the original
/// value.
const Map<String, String> kKhmerDeviceNames = {
  'Exhaust Fan': 'កង្ហារបញ្ចេញខ្យល់',
  'Roof Actuator': 'ឧបករណ៍បើកដំបូល',
  'Surveillance Camera': 'កាមេរ៉ាឃ្លាំមើល',
  'Water Meter': 'ម៉ែត្រទឹក',
};

int wattsForType(String? typeCode, String? controlType) {
  if (typeCode != null && kDeviceTypePowerWatts.containsKey(typeCode)) {
    return kDeviceTypePowerWatts[typeCode]!;
  }
  if (controlType != null && controlType.startsWith('irrigation.')) {
    return kWaterPumpPowerWatts;
  }
  return kControllerPowerWatts;
}
