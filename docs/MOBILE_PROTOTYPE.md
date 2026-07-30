# LNTB Mobile Prototype

The proposal-based farm experience is available as a deterministic Flutter
prototype before the later backend and physical-device milestones.

## Run modes

Development design mode:

```text
fvm flutter run --dart-define=LNTB_DATA_SOURCE=demo
```

API mode:

```text
fvm flutter run --dart-define=LNTB_DATA_SOURCE=api
```

`demo` is the default for non-release builds. A release build that requests
demo mode fails during startup; release builds must explicitly select `api`.

Demo farm controls update only the in-memory prototype repository. They never
submit an API request. The fixed prototype clock is `2026-07-30T08:00:00Z`, so
the same scenario produces repeatable readings, usage, ripeness results, and
history.

## Prototype navigation

The five primary destinations are Home, Farm, Devices, History, and Profile.
Owned and shared devices are filters within Devices. The existing zone board
continues to support multi-device selection. Tasks, Harvest Entry, and AI
Assistant remain in source but are not exposed from the proposal prototype.

## Scenario coverage

Tap the visible **Demo Data** strip in a development build to select:

- Healthy connected farm
- Dry soil warning
- Device offline
- Stale telemetry
- Sensor calibration required
- Pump command pending
- Partial multi-device failure
- Excess runtime safety stop
- Water/energy meter unavailable
- Ready-to-harvest result
- Low-confidence ripeness result
- Shared-user view

## Safety behavior

- Pump/fan start, roof open, and camera capture require confirmation.
- Stop and close actions are immediately available.
- Start/open is blocked for offline, stale, faulted, or uncalibrated state.
- An offline stop is represented as queued.
- Automatic irrigation is visibly disabled until safety validation.
- Prototype thresholds are identified as demonstration values, not agronomic
  recommendations.

## Contract status

The prototype repository interfaces and models are review candidates, not a
frozen backend contract. Freeze JSON fixtures, pagination, error codes,
capability codes, lifecycle terminology, units, and timestamp formats only
after Khmer/English design review is approved.
