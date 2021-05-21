import 'package:data_connection_checker/data_connection_checker.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final DataConnectionChecker networkChecker;

  NetworkInfoImpl(this.networkChecker);
  @override
  Future<bool> get isConnected => networkChecker.hasConnection;
}
