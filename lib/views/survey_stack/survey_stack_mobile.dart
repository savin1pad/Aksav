// ignore_for_file: unused_field, use_build_context_synchronously

part of survey_stack_view;

class _SurveyStackMobile extends StatefulWidget {
  final String email;
  final String userId;
  final String documentId;
  const _SurveyStackMobile({
    required this.documentId,
    required this.email,
    required this.userId,
  });

  @override
  State<_SurveyStackMobile> createState() => _SurveyStackMobileState();
}

class _SurveyStackMobileState extends State<_SurveyStackMobile> {
  int _currentQuestion = 1;
  final bool _isLoading = false;
  final card.SwiperController _cardSwiperController = card.SwiperController();
  final bool _isSwiperActive = true;
  List<Widget> cards = [];
  Map<String, dynamic> responses = {};
  final _backgroundColor = ConstantVars.maintheme;
  late AudioPlayer _audioPlayer;

  Future<void> _requestPermissions() async {
  final cameraStatus = await Permission.camera.status;
  if (!cameraStatus.isGranted) {
    await Permission.camera.request();
  }

  final photosStatus = await Permission.photos.status;
  if (!photosStatus.isGranted) {
    await Permission.photos.request();
  }
}

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
    _requestPermissions();
    cards = [
      const Survey1View(),
      const Survey2View(),
      const Survey3View(),
    ];
    _audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    final user = RepositoryProvider.of<UserModel>(context, listen: false);
    final goal = RepositoryProvider.of<GoalModel>(context, listen: false);
    return BlocConsumer<DataBloc, DataState>(
      listener: (context, state) {
        if (state is GoalUploadImageSuccessState) {
          setState(() {
            goal.photoUrl = state.imageUrl;
          });
          app<NavigatorService>().buildAndPushReplacement(
            RememberourView(
              documentId: widget.documentId,
              email: widget.email,
              userId: widget.userId,
            ),
          );
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: ConstantVars.maintheme,
            body: Stack(
              children: [
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
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 40.0, right: 40.0, top: 50),
                        child: LinearProgressIndicator(
                          value: _currentQuestion / 4,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            ConstantVars.cardColorTheme,
                          ),
                          borderRadius: BorderRadius.circular(8.0),
                          minHeight: 12,
                        ),
                      ),
                      card.Swiper(
                        itemCount: cards.length,
                        layout: card.SwiperLayout.TINDER,
                        controller: _cardSwiperController,
                        itemHeight: 700,
                        itemWidth: 500,
                        scale: 1.0,
                        onIndexChanged: (value) {
                          setState(() {
                            _currentQuestion = value + 1;
                          });
                          switch (value) {
                            case 0:
                              break;
                            case 1:
                              if (RepositoryProvider.of<GoalModel>(context)
                                      .goal ==
                                  null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please enter something to progress'),
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _cardSwiperController.previous();
                                });
                              }
                              break;
                            case 2:
                              if (RepositoryProvider.of<GoalModel>(context)
                                      .targetAmount ==
                                  null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Please enter something to progress'),
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  _cardSwiperController.previous();
                                });
                              }
                              break;
                          }
                          if (_isSwiperActive) {
                            _cardSwiperController.move(value - 1);
                          }
                        },
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          Widget child = const SizedBox();
                          if (card is Survey1View) {
                            child = const Survey1View();
                          } else if (card is Survey2View) {
                            child = const Survey2View();
                          } else if (card is Survey3View) {
                            child = const Survey3View();
                          }
                          return child;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            _currentQuestion == 1
                                ? const SizedBox()
                                : GestureDetector(
                                    onTap: () =>
                                        _cardSwiperController.previous(),
                                    child: Center(
                                      child: Container(
                                        width: 90,
                                        height: 40,
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: 50),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                blurRadius: 6.0,
                                                spreadRadius: 1,
                                                offset: const Offset(0, 5),
                                              ),
                                            ],
                                            color: Colors.white),
                                        child: const Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.arrow_back,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                ' Back',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'UnileverShilling',
                                                  color: Colors.black,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                            GestureDetector(
                              onTap: () async {
                                if (_currentQuestion == 3) {
                                  user.documentId = widget.documentId;
                                  user.email = widget.email;
                                  user.userId = widget.userId;
                                  goal.userId = widget.userId;
                                  goal.isSocial = false;
                                  goal.id = const Uuid().v4();
                                  if (goal.photoUrl != null) {
                                    user.showOnBoarding = false;
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool(
                                        'showOnboarding', false);
                                    await _audioPlayer
                                        .play(AssetSource('casette.mp3'));
                                    context.read<DataBloc>().add(
                                        GoalUploadImageEvent(
                                            xFile: File(goal.photoUrl!),
                                            userID: goal.id));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content:
                                            Text('Please make a selection'),
                                        duration: Duration(seconds: 1),
                                      ),
                                    );
                                  }
                                } else {
                                  _cardSwiperController.next();
                                }
                              },
                              child: Center(
                                child: Container(
                                  width: 90,
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 50),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 6.0,
                                        spreadRadius: 1,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                    gradient: LinearGradient(
                                      colors: [
                                        ConstantVars.maintheme,
                                        ConstantVars.maintheme,
                                      ],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        _currentQuestion == 3
                                            ? const Text(
                                                'Submit ',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'UnileverShilling',
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              )
                                            : const Text(
                                                'Next ',
                                                style: TextStyle(
                                                  fontFamily:
                                                      'UnileverShilling',
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                ),
                                              ),
                                        const Icon(
                                          Icons.arrow_forward,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
