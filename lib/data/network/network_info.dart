import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfoImpl implements NetworkInfo {
  final InternetConnection _internetConnection;

  NetworkInfoImpl(this._internetConnection);
  @override
  Future<bool> get isConnected => _internetConnection.hasInternetAccess;
}
