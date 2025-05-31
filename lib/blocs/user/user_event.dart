import 'package:equatable/equatable.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object?> get props => [];
}

class FetchUsers extends UserEvent {
  final bool reset;
  final String? searchQuery;

  const FetchUsers({this.reset = false, this.searchQuery});

  @override
  List<Object?> get props => [reset, searchQuery];
}
