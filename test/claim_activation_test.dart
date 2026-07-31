import 'package:flutter_test/flutter_test.dart';
import 'package:lntb_app/core/models/phase_one_models.dart';

void main() {
  const reference = '123e4567-e89b-12d3-a456-426614174000';
  const token = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNO_1';

  test('parses a versioned owner-bound activation QR', () {
    final payload = ClaimPayload.fromJson({
      'v': 1,
      'device_ref': reference,
      'activation_token': token,
      'device_name': 'Greenhouse Controller',
    });

    expect(payload.deviceReference, reference);
    expect(payload.activationToken, token);
    expect(payload.name, 'Greenhouse Controller');
  });

  test('rejects legacy and malformed activation QR payloads', () {
    expect(
      () => ClaimPayload.fromJson({
        'mac_address': 'AA:BB:CC:DD:EE:FF',
        'claim_code': 'ABCD-EFGH-1234',
      }),
      throwsFormatException,
    );
    expect(
      () => ClaimPayload.fromJson({
        'v': 2,
        'device_ref': reference,
        'activation_token': token,
      }),
      throwsFormatException,
    );
  });
}
