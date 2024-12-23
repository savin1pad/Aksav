part of loginbuffer_view;

class _LoginbufferMobile extends StatefulWidget {
  const _LoginbufferMobile();

  @override
  State<_LoginbufferMobile> createState() => _LoginbufferMobileState();
}

class _LoginbufferMobileState extends State<_LoginbufferMobile>
    with SingleTickerProviderStateMixin, LogMixin {
  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 5), () {
    //   Navigator.of(context).pop();
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        warningLog('State is $state');
        if (state is AuthErrorState) {
          app<NavigatorService>().pop();
        }
        if (state is SignUpFailure) {
          app<NavigatorService>().pop();
        }
        if (state is AuthSuccess) {
          warningLog(
              'checking for authsuccess and where it is navigating${state.showOnBoarding}');
          if (state.showOnBoarding == true) {
            app<NavigatorService>().buildAndPush(
              SurveyStackView(
                email: state.email!,
                userId: state.userId!,
                documentId: state.documentID!,
              ),
            );
          } else {
            app<NavigatorService>().buildAndPush(
              HomeView(
                email: state.email!,
                userId: state.userId!,
                documentId: state.documentID!,
              ),
            );
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ConstantVars.maintheme,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 50,
              ),
              Lottie.asset(
                'assets/loading.json',
              ),
              AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    'Authenticating...',
                    speed: const Duration(milliseconds: 350),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 40,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
