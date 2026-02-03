import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => <Object>[message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error del Servidor']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Error de Caché']);
}
