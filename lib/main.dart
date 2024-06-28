import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gp5/locale/l10n/app_locale.dart';
import 'package:flutter_gp5/routes/app_routes.dart';
import 'package:flutter_gp5/screens/auth/bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static Locale? locale = AppLocale.defaultSystemLocale;

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  void setLocale(Locale locale) {
    setState(() {
      MyApp.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationRepository>(
          create: (_) => AuthenticationRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
      ],
      child: BlocProvider<AuthenticationBloc>(
        create: (context) => createAuthenticationBloc(context),
        child: MaterialApp(
          title: 'GP5',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: MyApp.locale,
        ),
      ),
    );
  }
}

AuthenticationBloc createAuthenticationBloc(BuildContext context) {
  return AuthenticationBloc(
    authenticationRepository: context.read<AuthenticationRepository>(),
    userRepository: context.read<UserRepository>(),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder(
          future: _checkAuthentication(context),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.data == true) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.home);
              });
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacementNamed(AppRoutes.login);
              });
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Future<bool> _checkAuthentication(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));
    var isLoggedIn = context.read<AuthenticationRepository>().isLoggedIn();
    return isLoggedIn;
  }
}