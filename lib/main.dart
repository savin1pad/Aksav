// ignore_for_file: prefer_const_constructors

import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:journey/core/blocs/auth/auth_bloc.dart';
import 'package:journey/core/blocs/chat/chat_bloc.dart';
import 'package:journey/core/blocs/goal_log/goal_log_bloc.dart';
import 'package:journey/core/blocs/goals/goals_bloc.dart';
import 'package:journey/core/blocs/data/data_bloc.dart';
import 'package:journey/core/models/finance_model.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/repository/auth_repository.dart';
import 'package:journey/core/repository/chat_repository.dart';
import 'package:journey/core/repository/goal_log_repository.dart';
import 'package:journey/core/repository/goal_repository.dart';
import 'package:journey/core/repository/storage_repository.dart';
import 'package:journey/views/home/home_view.dart';
import 'package:journey/views/login/login_view.dart';
import 'package:journey/views/signup/signup_view.dart';
import 'package:path_provider/path_provider.dart';
import 'core/get.dart';
import 'core/services/navigator_service.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationDocumentsDirectory();
  final lockFile = File('${directory.path}/hydrated_box.lock');
  
  if (await lockFile.exists()) {
    await lockFile.delete();
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  initializeGetIt();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );
  log('Checking for storage ${HydratedBloc.storage}', name: 'Main.dart');
  runApp(
    const MainApplication(),
  );
}

class MainApplication extends StatelessWidget {
  const MainApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (context) => StorageRepository(),
        ),
        RepositoryProvider<UserModel>(
          create: (context) => UserModel(),
        ),
        RepositoryProvider<GoalModel>(
          create: (context) => GoalModel(),
        ),
        RepositoryProvider<FinanceModel>(
          create: (context) => FinanceModel(),
        ),
        RepositoryProvider<GoalRepository>(
          create: (context) => GoalRepository(),
        ),
        RepositoryProvider<ChatRepository>(
          create: (context) => ChatRepository(),
        ),
        RepositoryProvider<GoalLogRepository>(
          create: (context) => GoalLogRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
                authRepository: context.read<AuthRepository>(),
                storageRepository: context.read<StorageRepository>()),
          ),
          BlocProvider(
            create: (context) => DataBloc(
              storageRepository: context.read<StorageRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => GoalsBloc(
              goalRepository: context.read<GoalRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => ChatBloc(
              chatRepository: context.read<ChatRepository>(),
            ),
          ),
          BlocProvider(
            create: (context) => GoalLogBloc(
              goalLogRepository: context.read<GoalLogRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: app<NavigatorService>().navigatorKey,
          theme: ThemeData(
            textTheme: GoogleFonts.architectsDaughterTextTheme(),
            colorScheme: const ColorScheme.light(
              primary: Color(0xffDD5E89),
              secondary: Color(0xffF7BB97),
            ),
          ),
          home: const LoginView(),
          routes: {
            '/SignUp': (context) => const SignupView(),
            '/SignIn': (context) => const LoginView(),
            '/Home': (context) => const HomeView(
                  email: '',
                  userId: '',
                  documentId: '',
                ),
          },
        ),
      ),
    );
  }
}
