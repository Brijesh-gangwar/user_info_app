import '../../models/User.dart';

abstract class UserDetailState {}

class UserDetailInitial extends UserDetailState {}

class UserDetailLoading extends UserDetailState {}

class UserDetailLoaded extends UserDetailState {
  final User user;
  final List<String> posts;
  final List<String> todos;

  UserDetailLoaded({
    required this.user,
    required this.posts,
    required this.todos,
  });
}

class UserDetailError extends UserDetailState {
  final String message;
  UserDetailError(this.message);
}
