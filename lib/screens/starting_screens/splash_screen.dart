import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/auth/auth_event.dart';
import 'package:ca_app/blocs/auth/auth_state.dart';
import 'package:ca_app/utils/assets.dart';
import 'package:ca_app/utils/constanst/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(AuthAppInitEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      bloc: BlocProvider.of<AuthBloc>(context),
      listener: (context, state) {
       

        if (state is AuthSuccessState) {
          if (state.role == 'CA') {
            context.pushReplacement('/ca_dashboard');
          } else if (state.role == 'SUBCA') {
            context.pushReplacement('/subca_dashboard');
          } else if (state.role == 'CUSTOMER') {
            context.pushReplacement('/customer_dashboard');
          }
        } else if (state is AuthErrorState) {
          debugPrint('vcbnvcbcxnbcvnb');

          context.pushReplacement('/login');
        }
      },
      child: Scaffold(
        backgroundColor: ColorConstants.white,
        body: Container(
          padding: EdgeInsets.all(55),
          child: Center(
            child: Image.asset(splashLogo),
          ),
        ),
      ),
    );
  }
}
