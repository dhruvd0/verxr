import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/config/router.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/home/widgets/home_page.dart';
import 'package:verxr/features/registration/bloc/profile_bloc.dart';
import 'package:verxr/features/auth/widgets/email_login_page.dart';
import 'package:verxr/features/registration/widgets/registration_page.dart';
import 'package:verxr/firebase_options.dart';

void main({FirebaseAuth? firebaseAuth}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(firebaseAuth ?? FirebaseAuth.instance),
          ),
          BlocProvider(
            create: (context) => ProfileBloc(context.read<AuthBloc>()),
          ),
        ],
        child: MaterialApp(
          theme: lightThemeData(),
          onGenerateRoute: onGenerateRoute,
          home: const Splash(),
        ),
      ),
    ),
  );
}

///TODO: Firebase Config/ Mock
/// TODO: Integration Test Setup

class Splash extends StatefulWidget {
  static const String routeName = 'splash';

  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() {
    BlocProvider.of<AuthBloc>(context).add(CheckLoginEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, profileState) {
        if (profileState is FetchedProfileState) {
          Navigator.pushReplacementNamed(
            context,
            HomePage.routeName,
          );
        } else if (profileState is AuthenticatedProfileState) {
          Navigator.pushReplacementNamed(
            context,
            RegistrationPage.routeName,
          );
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LogOutAuthState) {
            Navigator.pushReplacementNamed(context, EmailLoginPage.routeName);
          } else if (state is SuccessAuthState) {
            BlocProvider.of<ProfileBloc>(context).add(
              GetProfileEvent(
                BlocProvider.of<AuthBloc>(context)
                    .firebaseAuth
                    .currentUser!
                    .uid,
              ),
            );
          }
        },
        child: Container(),
      ),
    );
  }
}
