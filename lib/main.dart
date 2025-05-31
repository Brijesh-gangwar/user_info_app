import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/user_list_screen.dart';

// 1. ThemeCubit: manages theme state
class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false); // false = light mode by default

  void toggleTheme() => emit(!state);
}

void main() {
  runApp(
    BlocProvider(
      create: (_) => ThemeCubit(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDarkMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'User CRUD App',
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
          ),
          home: UserListScreen(
            isDarkMode: isDarkMode,
            onThemeToggle: (value) {
              context.read<ThemeCubit>().toggleTheme();
            },
          ),
        );
      },
    );
  }
}
