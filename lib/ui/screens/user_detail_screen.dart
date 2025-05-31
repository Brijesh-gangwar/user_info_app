import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/user_details/user_details_bloc.dart';
import '../../blocs/user_details/user_details_event.dart';
import '../../blocs/user_details/user_details_state.dart';
import '../../services/api_service.dart';
import '../widgets/user_avatar_widget.dart';

import '../widgets/user_section.dart';

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
    _userDetailBloc = UserDetailBloc(ApiService())
      ..add(FetchUserDetail(widget.userId));
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
    return BlocProvider.value(
      value: _userDetailBloc,
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<UserDetailBloc, UserDetailState>(
            builder: (context, state) {
              return Text(
                state is UserDetailLoaded
                    ? state.user.fullName
                    : 'User Details',
              );
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
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    UserAvatar(imageUrl: state.user.image),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        state.user.fullName,
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    userinfo(state.user),

                    const SizedBox(height: 16),

                    const Divider(),

                    UserSection(title: 'Posts', items: state.posts),
                    const SizedBox(height: 10),

                    const Divider(),
                    UserSection(title: 'Todos', items: state.todos),
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

  Widget userinfo(dynamic user) {
    if (user.fullName.isEmpty) {
      return const Text(
        'No user information available.',
        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         const SizedBox(height: 10),
         Text('Information',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        const SizedBox(height: 10),

        _infoRow('Email   ', user.email),
        const SizedBox(height: 6),

        _infoRow('Phone ', user.phone),
        const SizedBox(height: 6),

        _infoRow('Address', user.address),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label : ',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 16),
            softWrap: true,
          ),
        ),
      ],
    );
  }
}
