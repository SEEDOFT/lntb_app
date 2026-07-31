import 'package:get/get.dart';

extension AppDateTimeFormat on DateTime {
  /// Formats the DateTime as "dd mmm yyyy h:mm A" with Khmer month and period formatting when in Khmer locale.
  /// Example: "31 កក្កដា 2026 02:45 ព្រឹក" (Khmer) or "31 Jul 2026 02:45 PM" (English)
  String toAppFormattedString() {
    final local = toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final isKhmer = Get.locale?.languageCode == 'km';

    final enMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    final kmMonths = [
      'មករា',
      'កុម្ភៈ',
      'មីនា',
      'មេសា',
      'ឧសភា',
      'មិថុនា',
      'កក្កដា',
      'សីហា',
      'កញ្ញា',
      'តុលា',
      'វិច្ឆិកា',
      'ធ្នូ'
    ];

    final month =
        isKhmer ? kmMonths[local.month - 1] : enMonths[local.month - 1];
    final year = local.year.toString();

    var hour = local.hour;
    final minute = local.minute.toString().padLeft(2, '0');
    final isAm = hour < 12;

    hour = hour % 12;
    if (hour == 0) hour = 12;
    final hourStr = hour.toString().padLeft(2, '0');

    final period = isKhmer ? (isAm ? 'ព្រឹក' : 'ល្ងាច') : (isAm ? 'AM' : 'PM');

    return '$day $month $year $hourStr:$minute $period';
  }

  /// Formats a date as a short header like "31 Jul 2026" (Khmer-aware).
  String toDayHeaderString() {
    final local = toLocal();
    final isKhmer = Get.locale?.languageCode == 'km';

    const enMonths = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    const kmMonths = [
      'មករា',
      'កុម្ភៈ',
      'មីនា',
      'មេសា',
      'ឧសភា',
      'មិថុនា',
      'កក្កដា',
      'សីហា',
      'កញ្ញា',
      'តុលា',
      'វិច្ឆិកា',
      'ធ្នូ'
    ];

    final month =
        isKhmer ? kmMonths[local.month - 1] : enMonths[local.month - 1];
    return '${local.day} $month ${local.year}';
  }

  /// Formats a day header subtitle as a weekday name (Khmer-aware).
  String toDayHeaderSubtitle() {
    final local = toLocal();
    final isKhmer = Get.locale?.languageCode == 'km';

    const enWeekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    const kmWeekdays = [
      'ច័ន្ទ',
      'អង្គារ',
      'ពុធ',
      'ព្រហស្បតិ៍',
      'សុក្រ',
      'សៅរ៍',
      'អាទិត្យ'
    ];

    final weekday = local.weekday - 1;
    return isKhmer ? kmWeekdays[weekday] : enWeekdays[weekday];
  }
}
