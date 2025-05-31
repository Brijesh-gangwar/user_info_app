abstract class UserDetailEvent {}

class FetchUserDetail extends UserDetailEvent {
  final int userId;
 FetchUserDetail(this.userId);
}

class RefreshUserDetail extends UserDetailEvent {
  final int userId;
   RefreshUserDetail(this.userId);
}
