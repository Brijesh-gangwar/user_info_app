import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/user_details/user_details_bloc.dart';
import '../../blocs/user_details/user_details_event.dart';
import '../../blocs/user_details/user_details_state.dart';

import '../../services/api_service.dart';


class UserDetailScreen extends StatefulWidget {
  final int userId;

  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  late final UserDetailBloc _userDetailBloc;

  @override
  void initState() {
    super.initState();
    _userDetailBloc = UserDetailBloc(ApiService());
    _userDetailBloc.add(FetchUserDetail(widget.userId));
  }

  @override
  void dispose() {
    _userDetailBloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _userDetailBloc.add(RefreshUserDetail(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserDetailBloc>(
      create: (_) => _userDetailBloc,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<UserDetailBloc, UserDetailState>(
            builder: (context, state) {
              if (state is UserDetailLoaded) {
                return Text(state.user.fullName);
              }
              return const Text('User Details');
            },
          ),
        ),
        body: BlocBuilder<UserDetailBloc, UserDetailState>(
          builder: (context, state) {
            if (state is UserDetailLoading || state is UserDetailInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UserDetailError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is UserDetailLoaded) {
              final user = state.user;
              final posts = state.posts;
              final todos = state.todos;

              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    // User Avatar
                    Center(
                      child: CircleAvatar(
                        radius: 50,
                        backgroundImage: (user.image != null && user.image!.isNotEmpty)
                            ? NetworkImage(user.image!)
                            : null,
                        child: (user.image == null || user.image!.isEmpty)
                            ? const Icon(Icons.person, size: 50)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // User Info
                    Text('Name: ${user.fullName}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text('Email: ${user.email}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Phone: ${user.phone}', style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('Address: ${user.address}', style: const TextStyle(fontSize: 16)),
                    const Divider(height: 32),

                    // Posts Section
                    const Text('Posts:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    posts.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('No posts available.', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                          )
                        : Column(
                            children: posts.map((post) => ListTile(title: Text(post))).toList(),
                          ),
                    const Divider(),

                    // Todos Section
                    const Text('Todos:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    todos.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text('No todos available.', style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
                          )
                        : Column(
                            children: todos.map((todo) => ListTile(title: Text(todo))).toList(),
                          ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
