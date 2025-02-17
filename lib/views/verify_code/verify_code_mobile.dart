// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables, unused_local_variable, use_build_context_synchronously

part of verify_code_view;

class _VerifyCodeMobile extends StatefulWidget {
  _VerifyCodeMobile();

  @override
  State<_VerifyCodeMobile> createState() => _VerifyCodeMobileState();
}

class _VerifyCodeMobileState extends State<_VerifyCodeMobile>
    with TickerProviderStateMixin, LogMixin {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  TextEditingController codeController = TextEditingController();
  late AnimationController _animationController;
  late AnimationController _textFieldsController;
  late AnimationController _popUpControllerAnimation;
  late Animation<Offset> _slideAnimation;
  Animation<Size>? _heightAnimation;
  Animation<Color?>? colorAnimation;
  Animation<Size>? _popUpAnimation;
  String? code, verificationIdToken;
  bool hasShownSignUpDialog = false;
  bool hasShownSnackbar = false;
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _textFieldsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _popUpControllerAnimation = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 600),
    );
    _popUpAnimation = Tween<Size>(begin: Size(100, 50), end: Size(250, 100))
        .animate(CurvedAnimation(
            parent: _popUpControllerAnimation, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      });
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1.5, 0), end: const Offset(0, 0))
            .animate(
      CurvedAnimation(
          parent: _textFieldsController, curve: Curves.linearToEaseOut),
    )..addListener(() {
            setState(() {});
          });
    _heightAnimation = Tween<Size>(
      begin: const Size(100, 100),
      end: const Size(300, 300),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn)
        ..addListener(() {
          setState(() {});
        }),
    );
    colorAnimation = ColorTween(begin: Colors.grey, end: Colors.white)
        .animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
    _heightAnimation?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _textFieldsController.forward();
      }
    });
    colorAnimation?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
      }
    });
    _slideAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _textFieldsController.stop();
      }
    });
    _popUpAnimation?.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _popUpControllerAnimation.stop();
      }
    });
    Future.delayed(
      Duration(seconds: 3),
      () => context.read<AuthBloc>().add(CheckingForVerificationId()),
    );
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textFieldsController.dispose();
    _popUpControllerAnimation.dispose();
    super.dispose();
  }

  submit({required String verificationID, required String code}) {
    final form = _signUpFormKey.currentState;
    if (form == null || !form.validate()) return;
    debugLog(code);
    form.save();
    context.read<AuthBloc>().add(
          VerifyPhoneCodeEvent(code: code, verficationId: verificationID),
        );
  }

  void _showVerifyPhoneCode({String? message}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: const Center(
          child: Text(
            'Authentication Error',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        contentPadding: EdgeInsets.only(top: 20),
        content: SizedBox(
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(message!),
              ),
              SizedBox(
                height: 22,
              ),
              InkWell(
                onTap: () => app<NavigatorService>()
                    .buildAndPushReplacement(PhoneAuthView()),
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    "Exit",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showVerifyPhoneCodeSuccess({String? message, AuthSuccess? state}) {
    warningLog(
        'new user ${state!.isNewUser},onboarding ${state.showOnBoarding} ,email ${state.email} , userId ${state.userId}, document id ${RepositoryProvider.of<AuthRepository>(context).documentId} ');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: const Center(
          child: Text(
            'Success',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        contentPadding: EdgeInsets.only(top: 20),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                // ignore: avoid_unnecessary_containers
                child: Container(child: Text(message!)),
              ),
              SizedBox(
                height: 22,
              ),
              InkWell(
                onTap: () {
                  state.showOnBoarding!
                      ? app<NavigatorService>().buildAndPush(
                          OnboardingView(
                            email: '${state.email}',
                            userId: state.userId!,
                            documentId:
                                RepositoryProvider.of<AuthRepository>(context)
                                    .documentId,
                          ),
                        )
                      : app<NavigatorService>().buildAndPush(
                          HomeView(
                            email: '${state.email}',
                            userId: state.userId!,
                            documentId:
                                RepositoryProvider.of<AuthRepository>(context)
                                    .documentId,
                          ),
                        );
                },
                child: Container(
                  padding: EdgeInsets.only(top: 20.0, bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showErrorOnVerifyingCode({String? httpException}) {
    var errorMessage = 'Authentication Error';
    if (httpException.toString().contains('The sms code has expired')) {
      //change keywords according to databasse
      errorMessage = 'Code has expired';
    } else if (httpException.toString().contains(
        'The sms verification code used to create the phone auth credential is invalid')) {
      //change keywords according to databasse
      errorMessage = 'Invalid Code';
    } else if (httpException.toString().contains('WEAK_PASSWORD')) {
      //change keywords according to databasse
      errorMessage = 'Weak password';
    } else if (httpException.toString().contains('EMAIL_NOT_FOUND')) {
      errorMessage = 'Email Not Found';
    } else if (httpException.toString().contains('INVALID_PASSWORD')) {
      errorMessage = 'Wrong Password';
    } else if (httpException.toString().contains(
        'We have blocked all requests from this device due to unusual activity. Try again later.')) {
      errorMessage = "Multiple Attempts try again later";
    }
    _showVerifyPhoneCode(message: errorMessage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        debugLog('$state');
        infoLog('${context.read<AuthRepository>().verificationId}');
        infoLog(
            'Reading error message in view ${context.read<AuthRepository>().errorMessage}');
        if (state is PhoneAuthFailure) {
          _showErrorOnVerifyingCode(httpException: state.message);
        }
        if (state is CodeNotSentDueToViolation) {
          _showErrorOnVerifyingCode(
              httpException:
                  'We have blocked all requests from this device due to unusual activity. Try again later.');
        }
        if (state is AuthSuccess) {
          // app<NavigatorService>().buildAndPush(
          //   HomeView(),
          // );
          warningLog('$state');
          warningLog(RepositoryProvider.of<AuthRepository>(context).documentId);
          _showVerifyPhoneCodeSuccess(
            message: 'Code Verified',
            state: state,
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    ConstantVars.maintheme,
                    ConstantVars.maintheme,
                  ],
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 25,
                    ),
                    Center(
                      child: Text(
                        'Journey',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                    ),
                    Center(
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeIn,
                        height: state is VerifyingCodeState ? 300 : 250,
                        width: state is VerifyingCodeState ? 325 : 350,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          color: state is VerifyingCodeState
                              ? Colors.white60
                              : ConstantVars.cardColorTheme,
                        ),
                        child: Form(
                          key: _signUpFormKey,
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                customText2(
                                  'Verify Code',
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 8.0),
                                  child: SlideTransition(
                                    position: _slideAnimation,
                                    // child: IntlPhoneField(
                                    //   decoration: const InputDecoration(
                                    //     labelText: 'Phone Number',
                                    //     border: OutlineInputBorder(
                                    //       borderSide: BorderSide(),
                                    //     ),
                                    //   ),
                                    //   initialCountryCode: 'IN',
                                    //   onChanged: (phone) {
                                    //     log(phone.completeNumber);
                                    //     phoneNumber = phone.completeNumber;
                                    //   },
                                    // ),
                                    child: TextFormField(
                                      autocorrect: false,
                                      keyboardType: TextInputType.phone,
                                      controller: codeController,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        labelText: 'Code',
                                        labelStyle: TextStyle(
                                          color: ConstantVars.maintheme,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: ConstantVars.maintheme,
                                        ),
                                      ),
                                      // validator: (String? value) {
                                      //   if (value == null || value.trim().isEmpty) {
                                      //     return 'Must Contain a PhoneNumber';
                                      //   }
                                      //   if (value.length < 10 || value.length > 10) {
                                      //     return 'Length of phone number invalid';
                                      //   }
                                      //   return null;
                                      // },
                                      onSaved: (String? value) {
                                        debugLog('$value');
                                        code = value;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () => submit(
                                    verificationID: context
                                        .read<AuthRepository>()
                                        .verificationId!,
                                    code: codeController.text.trim(),
                                  ),
                                  child: CustomContainer(
                                    icon: Icons.verified,
                                    height: 50,
                                    width: 140,
                                    showShadow: false,
                                    textSize: 20,
                                    color: Colors.green,
                                    textColor: Colors.white,
                                    title: state is VerifyingCodeState
                                        ? 'Verifying...'
                                        : 'Verify Code',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
