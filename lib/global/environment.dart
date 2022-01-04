import 'dart:io';

class Environments {
  static String apiUrl = Platform.isAndroid
      ? 'http://192.168.0.3:16999/api'
      : 'http://localhost:16999/api';

  static String socketUrl = Platform.isAndroid
      ? 'http://192.168.0.3:16999'
      : 'http://localhost:16999';
}
