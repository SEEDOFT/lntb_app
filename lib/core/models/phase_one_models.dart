import 'package:get/get.dart';
import 'package:lntb_app/core/constants/device_power_constants.dart';

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
    this.placement,
    this.serialNumber,
    this.firmwareVersion,
    this.ratedPowerWatts,
    this.lastSeenAt,
    this.typeCode,
    this.typeName,
  });
  final int id;
  final String name;
  final String? placement;
  final String macAddress;
  final String status;
  final String accessRole;
  final String? serialNumber;
  final String? firmwareVersion;
  final int? ratedPowerWatts;
  final DateTime? lastSeenAt;
  final String? typeCode;
  final String? typeName;

  bool get isOwner => accessRole == 'owner';
  bool get isOnline => status == 'active';
  bool get isControllable => switch (typeCode) {
        'fan' || 'roof' || 'camera' || 'smart_farm_controller' => true,
        _ => false,
      };

  bool get isFan => typeCode == 'fan';
  bool get isRoof => typeCode == 'roof';
  bool get isCamera => typeCode == 'camera';
  bool get isMeter => typeCode == 'water_energy_meter';

  /// Khmer-aware display name for seeded demo devices; falls back to the
  /// user-set name.
  String get deviceDisplayName =>
      kKhmerDeviceNames[name] ?? name;

  factory DeviceModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as Map<String, dynamic>?;

    return DeviceModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? 'LNTB',
      placement: json['placement'] as String?,
      macAddress: json['mac_address'] as String? ?? '',
      status: (json['status'] as Map<String, dynamic>?)?['code'] as String? ??
          'retired',
      accessRole: json['access_role'] as String? ?? 'shared',
      serialNumber: json['serial_number'] as String?,
      firmwareVersion: json['firmware_version'] as String?,
      ratedPowerWatts: json['rated_power_watts'] as int?,
      lastSeenAt: DateTime.tryParse(json['last_seen_at'] as String? ?? ''),
      typeCode: type?['code'] as String?,
      typeName: type?['name'] as String?,
    );
  }
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
    this.deviceTypeCode,
    this.deviceTypeName,
  });
  final int id;
  final int deviceId;
  final String controlType;
  final String status;
  final DateTime requestedAt;
  final String? deviceName;
  final String? failureMessage;
  final String? deviceTypeCode;
  final String? deviceTypeName;

  bool get isPending => status == 'pending';
  bool get isCompleted => status == 'completed';

  factory ControlRecord.fromJson(Map<String, dynamic> json) {
    final device = json['device'] as Map<String, dynamic>?;
    final type = device?['type'] as Map<String, dynamic>?;
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
      deviceTypeCode: type?['code'] as String?,
      deviceTypeName: type?['name'] as String?,
    );
  }
}

/// A control-history record enriched with the paired runtime and the estimated
/// energy used while the action was active.
class HistoryTimelineEntry {
  const HistoryTimelineEntry({
    required this.record,
    this.runtime,
    this.energyKwh,
  });

  final ControlRecord record;

  /// Duration the action was active (start→stop pairing). Null when no
  /// matching start/stop pair is known.
  final Duration? runtime;

  /// Estimated energy in kWh for this action, or null when unknown.
  final double? energyKwh;

  String get deviceDisplayName =>
      record.deviceName != null && kKhmerDeviceNames.containsKey(record.deviceName)
          ? kKhmerDeviceNames[record.deviceName]!
          : record.deviceName ?? 'device'.tr;
}

class DeviceAccess {  const DeviceAccess({
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
    required this.deviceReference,
    required this.activationToken,
    this.name,
  });
  final String deviceReference;
  final String activationToken;
  final String? name;

  factory ClaimPayload.fromJson(Map<String, dynamic> json) {
    final version = json['v'];
    final reference = json['device_ref'] as String?;
    final token = json['activation_token'] as String?;
    final validReference = reference != null &&
        RegExp(
          r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
        ).hasMatch(reference);
    if (version != 1 ||
        !validReference ||
        token == null ||
        token.length != 43 ||
        !RegExp(r'^[A-Za-z0-9_-]{43}$').hasMatch(token)) {
      throw const FormatException('Unsupported device QR code.');
    }
    return ClaimPayload(
      deviceReference: reference,
      activationToken: token,
      name: json['device_name'] as String?,
    );
  }
}

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.typeCode,
    required this.statusCode,
    this.data,
    this.createdAt,
  });
  final int id;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final String typeCode;
  final String statusCode;
  final DateTime? createdAt;

  bool get isUnread => statusCode == 'unread';

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as Map<String, dynamic>?;
    final status = json['status'] as Map<String, dynamic>?;
    return NotificationItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      data: json['data'] as Map<String, dynamic>?,
      typeCode: type?['code'] as String? ?? 'system',
      statusCode: status?['code'] as String? ?? 'unread',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? ''),
    );
  }

  NotificationItem copyWith({String? statusCode}) => NotificationItem(
        id: id,
        title: title,
        body: body,
        data: data,
        typeCode: typeCode,
        statusCode: statusCode ?? this.statusCode,
        createdAt: createdAt,
      );
}
