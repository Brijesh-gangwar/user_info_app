import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/User.dart';
import '../../services/api_service.dart';
import 'user_event.dart';
import 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final ApiService api;
  final int limit = 10;

  List<User> users = [];
  int skip = 0;
  bool hasMore = true;
  String currentSearch = '';

  bool isLoading = false; 

  UserBloc(this.api) : super(UserInitial()) {
    on<FetchUsers>(_onFetchUsers);
  }

  Future<void> _onFetchUsers(FetchUsers event, Emitter<UserState> emit) async {
    if (isLoading) return;
    isLoading = true;

    try {
      if (event.reset) {
        users.clear();
        skip = 0;
        hasMore = true;
        currentSearch = event.searchQuery ?? '';
      }

      if (!hasMore) {
        isLoading = false;
        return;
      }


      if (users.isEmpty || event.reset) {
        emit(UserLoading());
      }

      final fetchedUsers = await api.fetchUsers(
        limit: limit,
        skip: skip,
        search: currentSearch,
      );

      users.addAll(fetchedUsers);
      skip += limit;
      hasMore = fetchedUsers.length == limit;

      emit(UserLoaded(users: List.from(users), hasMore: hasMore));
    } catch (e) {
      emit(UserError(e.toString()));
    } finally {
      isLoading = false;
    }
  }
}
