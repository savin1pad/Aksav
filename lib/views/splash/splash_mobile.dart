// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

part of splash_view;

class _SplashMobile extends StatefulWidget {
  _SplashMobile();

  @override
  State<_SplashMobile> createState() => _SplashMobileState();
}

class _SplashMobileState extends State<_SplashMobile> with LogMixin {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(OnAppStart());
    // Future.delayed(Duration(seconds: 3), () {
    //   app<NavigatorService>().buildAndPush(
    //     LoginView(),
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        warningLog('$state');
        if (state is AuthSuccess) {
          app<NavigatorService>().buildAndPush(
            HomeView(
              email: state.email!,
              userId: state.userId!,
              documentId: state.documentID!,
            ),
          );
        } else if (state is SignUpFailure) {
          app<NavigatorService>().buildAndPush(
            LoginView(),
          );
        } else {
          app<NavigatorService>().buildAndPush(
            SignupView(),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
