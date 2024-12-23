part of rememberour_view;

class _RememberourMobile extends StatefulWidget {
  final String email;
  final String userId;
  final String documentId;
  const _RememberourMobile({
    required this.documentId,
    required this.email,
    required this.userId,
  });

  @override
  State<_RememberourMobile> createState() => _RememberourMobileState();
}

class _RememberourMobileState extends State<_RememberourMobile>
    with TickerProviderStateMixin, LogMixin {
  late AnimationController _waveAnimationController;
  late AnimationController _text1AnimationController;
  late AnimationController _text2AnimationController;
  late Animation<Offset> _text1SlideAnimation;
  late Animation<double> _text1FadeAnimation;
  late Animation<Offset> _text2SlideAnimation;
  late Animation<double> _text2FadeAnimation;
  final _backgroundColor = ConstantVars.maintheme;
  final TextEditingController targetAmountController = TextEditingController();

  final _colors = [
    ConstantVars.maintheme,
    ConstantVars.cardColorTheme,
  ];

  final _durations = [
    5000,
    4000,
  ];

  final _heightPercentages = [
    0.65,
    0.66,
  ];

  @override
  void initState() {
    super.initState();
    warningLog('goal model ${RepositoryProvider.of<GoalModel>(context)}');
    context.read<GoalsBloc>().add(
          GoalsPostEvent(
            goal: RepositoryProvider.of<GoalModel>(context),
          ),
        );
    // Wave animation
    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _waveAnimationController.forward();

    // Text 1 animation
    _text1AnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _text1SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _text1AnimationController,
      curve: Curves.decelerate,
    ));
    _text1FadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _text1AnimationController,
      curve: Curves.decelerate,
    ));

    // Text 2 animation (delayed)
    _text2AnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _text2SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _text2AnimationController,
      curve: Curves.decelerate,
    ));
    _text2FadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_text2AnimationController)
      ..addListener(() {
        setState(() {
          // When text 2 fades in, text 1 fades out
          _text1FadeAnimation = Tween<double>(
            begin: 1.0,
            end: 0.0,
          ).animate(_text2AnimationController);
        });
      });
    // Delay the second text animation and navigate after it's done
    Future.delayed(const Duration(seconds: 3), () {
      _text2AnimationController.forward().then((_) {
        // Future.delayed(const Duration(seconds: 2), () {
        //   // Replace this with your actual home screen navigation
        //   app<NavigatorService>().buildAndPushReplacement(
        //     HomeView(
        //       email: widget.email,
        //       userId: widget.userId,
        //       documentId: widget.documentId,
        //     ),
        //   );
        // });
      });
    });
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    _text1AnimationController.dispose();
    _text2AnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final finance = RepositoryProvider.of<FinanceModel>(context);
    final user = RepositoryProvider.of<UserModel>(context);
    warningLog('check for user ${user.showOnBoarding}');
    return Scaffold(
      body: Stack(
        children: [
          // Wave background
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: WaveWidget(
              config: CustomConfig(
                colors: _colors,
                durations: _durations,
                heightPercentages: _heightPercentages,
              ),
              backgroundColor: _backgroundColor,
              size: const Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
          ),
          // Animated texts
          Column(
            children: [
              const SizedBox(height: 100),
              // Text 1
              FadeTransition(
                opacity: _text1FadeAnimation,
                child: SlideTransition(
                  position: _text1SlideAnimation,
                  child: const Text(
                    'Creating goals that matter',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Text 2 (animated after a delay)
              FadeTransition(
                opacity: _text2FadeAnimation,
                child: SlideTransition(
                  position: _text2SlideAnimation,
                  child: const Text(
                    'Lets get started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (user.showOnBoarding ?? true)
                Center(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/money.json',
                          height: 50,
                          width: 50,
                        ),
                        const SizedBox(height: 20),
                        FadeTransition(
                          opacity: _text2FadeAnimation,
                          child: const Text(
                            'How much do you need to achieve this goal?',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 30),
                        // Wrap TextField in a Container with constraints
                        Container(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: TextField(
                            controller: targetAmountController,
                            keyboardType: TextInputType.number,
                            style: const TextStyle(color: Colors.white),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                finance.income = value;
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Monthly Income',
                              prefixText: '₹',
                              labelStyle:
                                  const TextStyle(color: Colors.white70),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white70),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Beautiful animated submit button
                        BlocConsumer<GoalsBloc, GoalsState>(
                          listener: (context, state) {
                            if (state is SetFinanceSuccessState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Finance data saved successfully!'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              app<NavigatorService>().buildAndPushReplacement(
                                HomeView(
                                  email: widget.email,
                                  userId: widget.userId,
                                  documentId: widget.documentId,
                                ),
                              );
                            } else if (state is SetFinanceErrorState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              width: state is SetFinanceLoadingState ? 50 : 200,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: ConstantVars.maintheme,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      state is SetFinanceLoadingState ? 25 : 10,
                                    ),
                                  ),
                                  elevation: 5,
                                  shadowColor: Colors.black.withOpacity(0.5),
                                ),
                                onPressed: state is SetFinanceLoadingState
                                    ? null
                                    : () {
                                        if (targetAmountController
                                            .text.isNotEmpty) {
                                          context.read<GoalsBloc>().add(
                                                SetFinanceEvents(
                                                  amount: targetAmountController
                                                      .text,
                                                  userId: widget.userId,
                                                ),
                                              );
                                        }
                                      },
                                child: state is SetFinanceLoadingState
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            'Save Finance Data',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(width: 3),
                                          Icon(
                                            Icons.arrow_forward,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                        ],
                                      ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(
                height: 40,
              ),
              if (!(user.showOnBoarding ?? true))
                FadeTransition(
                  opacity: _text2FadeAnimation,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstantVars.maintheme,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                        ),
                        elevation: 5,
                        shadowColor: Colors.black.withOpacity(0.5),
                      ),
                      onPressed: () {
                        app<NavigatorService>().buildAndPushReplacement(
                          HomeView(
                            email: widget.email,
                            userId: widget.userId,
                            documentId: widget.documentId,
                          ),
                        );
                      },
                      child: const Text(
                        'Continue to Home',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
