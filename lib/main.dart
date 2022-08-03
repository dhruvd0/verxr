import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verxr/config/router.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/features/auth/auth_bloc.dart';
import 'package:verxr/features/dashboard/widgets/dashboard_page.dart';
import 'package:verxr/features/registration/bloc/page_handler/cubit/registration_page_handler_cubit.dart';
import 'package:verxr/features/registration/bloc/profile/profile_bloc.dart';
import 'package:verxr/features/auth/widgets/email_login_page.dart';
import 'package:verxr/features/registration/controller/profile_api_controller.dart';
import 'package:verxr/features/registration/widgets/registration_page.dart';
import 'package:verxr/firebase_options.dart';
import 'package:verxr/config/common/dio.dart';

Future<void> main({FirebaseAuth? firebaseAuth}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await setupNetworkConfig();
  runApp(
    MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(firebaseAuth ?? FirebaseAuth.instance),
          ),
          BlocProvider(
            lazy: false,
            create: (context) =>
                ProfileBloc(context.read<AuthBloc>(), ProfileAPIController()),
          ),
          BlocProvider(
            lazy: false,
            create: (context) =>
                RegistrationPageHandlerCubit(context.read<ProfileBloc>()),
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

Future<void> setupNetworkConfig() async {
  await FirebaseRemoteConfig.instance.fetchAndActivate();
  dio = Dio(defaultDioOptions())..interceptors.add(CustomInterceptors());
}

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  static const String routeName = 'splash';

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void didChangeDependencies() {
    precacheImages();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    BlocProvider.of<AuthBloc>(context).add(CheckLoginEvent());
  }

  Future<void> precacheImages() async {
    List<String> imageList = [
      "splash.png",
      "logo.png",
      "Individual.png",
      "Group.png",
      "Institution.png"
    ];

    await Future.wait(
      imageList.map(
        (e) => precacheImage(
          Image.asset(
            'assets/$e',
            key: ValueKey(e),
          ).image,
          context,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, profileState) {
        debugPrint(profileState.toString());
        if (profileState is FetchedProfileState) {
          Navigator.pushReplacementNamed(
            context,
            DashboardPage.routeName,
          );
        } else if (profileState is UnregisteredProfileState) {
          Navigator.pushReplacementNamed(
            context,
            RegistrationPage.routeName,
          );
        } else if (profileState is ProfileErrorState) {
          Navigator.pushReplacementNamed(context, EmailLoginPage.routeName);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
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
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(50),
              child: Image.asset('assets/splash.png'),
            ),
          ),
        ),
      ),
    );
  }
}
