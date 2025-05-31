import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/api_service.dart';
import 'user_detail_screen.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_state.dart';

class UserListScreen extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeToggle;

  const UserListScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeToggle,
  });

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late final UserBloc userBloc;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Use context.read<UserBloc>() later from BlocProvider above
    userBloc = UserBloc(ApiService());
    userBloc.add(const FetchUsers());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !(userBloc.state is UserLoading)) {
      userBloc.add(const FetchUsers());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    userBloc.close();
    super.dispose();
  }

  void onSearch(String query) {
    userBloc.add(FetchUsers(reset: true, searchQuery: query));
  }

  Future<void> _onRefresh() async {
    userBloc.add(FetchUsers(reset: true, searchQuery: _searchController.text));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>.value(
      value: userBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Users'),
          actions: [
            IconButton(
              icon: Icon(
                widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
              onPressed: () {
                widget.onThemeToggle(!widget.isDarkMode);
              },
              tooltip: widget.isDarkMode
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search users by name...',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            _searchController.clear();
                            onSearch('');
                            FocusScope.of(context).unfocus();
                            setState(() {});
                          },
                        )
                      : null,
                ),
                onChanged: (_) {
                  setState(() {});
                },
                onSubmitted: (value) {
                  onSearch(value);
                  FocusScope.of(context).unfocus();
                },
              ),
            ),

            Expanded(
  child: BlocBuilder<UserBloc, UserState>(
    builder: (context, state) {
      final users = userBloc.users;

      if (state is UserInitial ||
          (state is UserLoading && users.isEmpty)) {
        return const Center(child: CircularProgressIndicator());
      } else if (state is UserError) {
        return Center(child: Text('Error: ${state.message}'));
      }

      if (users.isEmpty) {
        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: const [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'No users found.',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: _onRefresh,
        child: ListView.builder(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: userBloc.hasMore ? users.length + 1 : users.length,
          itemBuilder: (context, index) {
            if (index == users.length) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
              );
            }

            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: user.image != null && user.image!.isNotEmpty
                    ? NetworkImage(user.image!)
                    : null,
                child: (user.image == null || user.image!.isEmpty)
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(user.fullName),
              subtitle: Text(user.email),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => UserDetailScreen(userId: user.id),
                ),
              ),
            );
          },
        ),
      );
    },
  ),
),

          ],
        ),
      ),
    );
  }
}
