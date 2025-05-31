import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/api_service.dart';

import 'user_details_event.dart';
import 'user_details_state.dart';

class UserDetailBloc extends Bloc<UserDetailEvent, UserDetailState> {
  final ApiService api;

  UserDetailBloc(this.api) : super(UserDetailInitial()) {
    on<FetchUserDetail>(_onFetchUserDetail);
    on<RefreshUserDetail>(_onRefreshUserDetail);
  }

  Future<void> _onFetchUserDetail(FetchUserDetail event, Emitter<UserDetailState> emit) async {
    emit(UserDetailLoading());
    try {
      final user = await api.fetchUserDetail(event.userId);
      final posts = await api.fetchPosts(event.userId);
      final todos = await api.fetchTodos(event.userId);
      emit(UserDetailLoaded(user: user, posts: posts, todos: todos));
    } catch (e) {
      emit(UserDetailError(e.toString()));
    }
  }

  Future<void> _onRefreshUserDetail(RefreshUserDetail event, Emitter<UserDetailState> emit) async {
    
    await _onFetchUserDetail(FetchUserDetail(event.userId), emit);
  }
}
