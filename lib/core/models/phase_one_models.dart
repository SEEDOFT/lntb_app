class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    this.email,
    this.countryCode,
    this.phoneNumber,
  });
  final int id;
  final String name;
  final String? email;
  final String? countryCode;
  final String? phoneNumber;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as int,
        name: json['name'] as String? ?? '',
        email: json['email'] as String?,
        countryCode: json['country_code'] as String?,
        phoneNumber: json['phone_number'] as String?,
      );

  String get contact =>
      email ?? '${countryCode ?? ''} ${phoneNumber ?? ''}'.trim();
}

class DeviceModel {
  const DeviceModel({
    required this.id,
    required this.name,
    required this.macAddress,
    required this.status,
    required this.accessRole,
    this.serialNumber,
    this.firmwareVersion,
    this.lastSeenAt,
  });
  final int id;
  final String name;
  final String macAddress;
  final String status;
  final String accessRole;
  final String? serialNumber;
  final String? firmwareVersion;
  final DateTime? lastSeenAt;

  bool get isOwner => accessRole == 'owner';
  bool get isOnline => status == 'active';

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
        id: json['id'] as int,
        name: json['name'] as String? ?? 'LNTB IoT',
        macAddress: json['mac_address'] as String? ?? '',
        status: (json['status'] as Map<String, dynamic>?)?['code'] as String? ??
            'retired',
        accessRole: json['access_role'] as String? ?? 'shared',
        serialNumber: json['serial_number'] as String?,
        firmwareVersion: json['firmware_version'] as String?,
        lastSeenAt: DateTime.tryParse(json['last_seen_at'] as String? ?? ''),
      );
}

class ControlRecord {
  const ControlRecord({
    required this.id,
    required this.deviceId,
    required this.controlType,
    required this.status,
    required this.requestedAt,
    this.deviceName,
    this.failureMessage,
  });
  final int id;
  final int deviceId;
  final String controlType;
  final String status;
  final DateTime requestedAt;
  final String? deviceName;
  final String? failureMessage;

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';

  factory ControlRecord.fromJson(Map<String, dynamic> json) {
    final device = json['device'] as Map<String, dynamic>?;
    return ControlRecord(
      id: json['id'] as int,
      deviceId: json['device_id'] as int,
      controlType: json['control_type'] as String? ?? '',
      status: (json['status'] as Map<String, dynamic>?)?['code'] as String? ??
          'pending',
      requestedAt: DateTime.tryParse(json['requested_at'] as String? ?? '') ??
          DateTime.now(),
      deviceName: device?['name'] as String?,
      failureMessage: json['failure_message'] as String?,
    );
  }
}

class DeviceAccess {
  const DeviceAccess({
    required this.id,
    required this.user,
    required this.status,
  });
  final int id;
  final AppUser user;
  final String status;

  factory DeviceAccess.fromJson(Map<String, dynamic> json) => DeviceAccess(
        id: json['id'] as int,
        user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
        status: (json['status'] as Map<String, dynamic>?)?['code'] as String? ??
            'active',
      );
}

class ClaimPayload {
  const ClaimPayload({
    required this.macAddress,
    required this.claimCode,
    this.name,
  });
  final String macAddress;
  final String claimCode;
  final String? name;

  factory ClaimPayload.fromJson(Map<String, dynamic> json) {
    final mac = json['mac_address'] as String?;
    final code = json['claim_code'] as String?;
    if (mac == null || code == null || mac.isEmpty || code.isEmpty) {
      throw const FormatException('Unsupported device QR code.');
    }
    return ClaimPayload(
      macAddress: mac,
      claimCode: code,
      name: json['name'] as String?,
    );
  }
}
