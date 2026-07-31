import 'package:get/get.dart';

String controlTypeKey(String code) => code.replaceAll('.', '_');

extension ControlTypeLabel on String {
  String get controlTypeLabel => controlTypeKey(this).tr;
}
