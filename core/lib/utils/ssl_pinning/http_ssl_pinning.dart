import 'dart:io';
import 'package:flutter/services.dart';
import 'package:http/io_client.dart';

class HttpSSLPinning {
  static IOClient? ioClient;

  static IOClient get client => ioClient!;

  static Future<void> init() async {
    ioClient = await createIoClient;
  }

  static Future<IOClient> get createIoClient async {
    final sslCert = await rootBundle.load('certificates/certificates.pem');
    SecurityContext securityContext = SecurityContext(withTrustedRoots: false);
    securityContext.setTrustedCertificatesBytes(sslCert.buffer.asInt8List());
    HttpClient client = HttpClient(context: securityContext);
    client.badCertificateCallback = (X509Certificate cert, String host, int port) => false;
    return IOClient(client);
  }
}