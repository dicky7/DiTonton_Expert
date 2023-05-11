

import 'package:equatable/equatable.dart';

import '../../../utils/connection/connection.dart';

abstract class InternetState extends Equatable {
  const InternetState();
  @override
  List<Object> get props => [];
}

class InternetLoading extends InternetState {}
class InternetConnected extends InternetState {
  final ConnectionType connectionType;

  InternetConnected(this.connectionType);
  @override
  // TODO: implement props
  List<Object> get props =>[
    connectionType
  ];
}
class InternetDisconnected extends InternetState {}