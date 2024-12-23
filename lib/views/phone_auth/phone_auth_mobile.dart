// ignore_for_file: prefer_const_constructors, unused_local_variable

part of phone_auth_view;

class _PhoneAuthMobile extends StatefulWidget {
  const _PhoneAuthMobile();

  @override
  State<_PhoneAuthMobile> createState() => _PhoneAuthMobileState();
}

class _PhoneAuthMobileState extends State<_PhoneAuthMobile>
    with TickerProviderStateMixin, LogMixin {
  final GlobalKey<FormState> _signUpFormKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late AnimationController _textFieldsController;
  late Animation<Offset> _slideAnimation;
  Animation<double>? _fadeAnimation;
  String? phoneNumber, password;
  bool hasShownSignUpDialog = false;
  bool hasShownSnackbar = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _textFieldsController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start from below the screen
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textFieldsController,
      curve: Curves.decelerate,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0, // Start fully transparent
      end: 1.0, // End fully opaque
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.decelerate,
    ));

    // Start animations
    _animationController.forward();
    _textFieldsController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _textFieldsController.dispose();
    super.dispose();
  }

  void _showErrorSignUpDialogPhone({String? message}) {
    showDialog(
        context: context,
        builder: (context) => CustomDialogBox(
              message: message,
            ));
  }

  _showErrorOnPhoneSignUp({String? httpException}) {
    var errorMessage = 'Authentication Error';
    if (httpException.toString().contains('EMAIL_EXISTS')) {
      //change keywords according to databasse
      errorMessage = 'This Email address is already in use';
    } else if (httpException.toString().contains('INVALID_EMAIL')) {
      //change keywords according to databasse
      errorMessage = 'Please try again with a valid Email address';
    } else if (httpException.toString().contains('WEAK_PASSWORD')) {
      //change keywords according to databasse
      errorMessage = 'Weak password';
    } else if (httpException.toString().contains('EMAIL_NOT_FOUND')) {
      errorMessage = 'Email Not Found';
    } else if (httpException.toString().contains('INVALID_PASSWORD')) {
      errorMessage = 'Wrong Password';
    } else if (httpException.toString().contains(
        'We have blocked all requests from this device due to unusual activity. Try again later.')) {
      errorMessage = "Unusual activity from Number";
    }
    _showErrorSignUpDialogPhone(message: httpException);
  }

  submit() {
    final form = _signUpFormKey.currentState;
    if (form == null || !form.validate()) return;
    form.save();
    context.read<AuthBloc>().add(
          PhoneAuthenticationEvent(phoneNumber: phoneNumber!),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        debugLog('$state');
        if (state is ErrorSendingCode) {
          _showErrorOnPhoneSignUp(httpException: state.message);
        }
        if (state is CodeSentToPhone) {
          app<NavigatorService>().buildAndPush(VerifyCodeView());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                stops: const [0.4, 0.6],
                colors: [
                  ConstantVars.maintheme,
                  Colors.white,
                ],
              ),
            ),
            child: FadeTransition(
              opacity: _fadeAnimation!,
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      SlideTransition(
                        position: _slideAnimation,
                        child: Image.asset(
                          'assets/icon.jpeg',
                          height: 150,
                          width: 150,
                        ),
                      ),
                      SizedBox(height: 10),
                      SlideTransition(
                        position: _slideAnimation,
                        child: Text(
                          'Welcome to Aksa',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                      SlideTransition(
                        position: _slideAnimation,
                        child: AnimatedContainer(
                          duration: const Duration(seconds: 1),
                          curve: Curves.easeIn,
                          width: 350,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: state is AuthLoading
                                ? Colors.white54
                                : ConstantVars.cardColorTheme,
                          ),
                          child: Form(
                            key: _signUpFormKey,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  customText2('Sign Up'),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  IntlPhoneField(
                                    decoration: const InputDecoration(
                                      labelText: 'Phone Number',
                                      filled: true,
                                      fillColor: Colors.white,
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(),
                                      ),
                                    ),
                                    initialCountryCode: 'IN',
                                    onChanged: (phone) {
                                      log(phone.completeNumber);
                                      phoneNumber = phone.completeNumber;
                                    },
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  GestureDetector(
                                    onTap: submit,
                                    child: CustomContainer(
                                      title: state is AuthLoading
                                          ? 'Sending Code'
                                          : 'Send Code',
                                      icon: Icons.phone,
                                      height: 50,
                                      width: 140,
                                      showShadow: false,
                                      textSize: 20,
                                      color: Colors.green,
                                      textColor: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 20),
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
          ),
        );
      },
    );
  }
}
