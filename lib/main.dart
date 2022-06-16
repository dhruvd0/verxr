import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/config/router.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/auth/widgets/phone_auth/phone_auth.dart';
import 'package:verxr/features/home/widgets/home_page.dart';
import 'package:verxr/features/registration/bloc/profile_bloc.dart';
import 'package:verxr/features/registration/widgets/registration_page.dart';
import 'package:verxr/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    const MaterialApp(
      home: VerXR(),
    ),
  );
}

/// TODO: firebase phone auth
/// TODO: Theme setup
///TODO: Firebase Config/ Mock
/// TODO: Integration Test Setup

class VerXR extends StatelessWidget {
  const VerXR({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
      ],
      child: MaterialApp(
        theme: lightThemeData(),
        onGenerateRoute: onGenerateRoute,
        home: const Splash(),
      ),
    );
  }
}

class Splash extends StatefulWidget {
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
            Navigator.pushReplacementNamed(context, PhoneAuthPage.routeName);
          } else if (state is SuccessAuthState) {
            BlocProvider.of<ProfileBloc>(context).add(
              GetProfileEvent(FirebaseAuth.instance.currentUser!.uid),
            );
          }
        },
        child: Container(),
      ),
    );
  }
}
