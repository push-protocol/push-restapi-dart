import '../../push_restapi_dart.dart';

class PushAPIInitializeProps {
  void Function(ProgressHookType)? progressHook;
  String? account;
  String? version;
  Map<String, Map<String, String>>? versionMeta;
  bool autoUpgrade;
  String? origin;

  PushAPIInitializeProps({
    this.progressHook,
    this.account,
    this.version = Constants.ENC_TYPE_V3,
    this.versionMeta,
    this.autoUpgrade = true,
    this.origin,
  });
}
