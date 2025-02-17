// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, sized_box_for_whitespace, avoid_types_as_parameter_names, unused_field, deprecated_member_use

part of home_view;

class _HomeMobile extends StatefulWidget {
  final String? email;
  final String? userId;
  final String? documentId;

  _HomeMobile(
      {required this.email, required this.userId, required this.documentId});

  @override
  State<_HomeMobile> createState() => _HomeMobileState();
}

class _HomeMobileState extends State<_HomeMobile>
    with LogMixin, TickerProviderStateMixin {
  int _selectedIndex = 0; // Start with the Home screen
  DateTime? _lastPressedAt; // Track last back press

  late AnimationController _slideController;
  late AnimationController _fadeController;

  // Animations
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  static const gradientColors = [
    Color(0xFF2E3192), // Deep Blue
    Color(0xFF1BFFFF), // Cyan
  ];

  @override
  void initState() {
    super.initState();

    // Initialize slide animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    // Initialize fade animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    // Start animations
    _slideController.forward();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  // Define screens for each tab
  final List<Widget> _screens = [
    HomeScreenWidget(), // Replace with your actual Home screen widget
    SocialscreenwidgetView(), // Replace with your Social screen widget
    ProfileScreenWidget(), // Replace with your Profile screen widget
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        warningLog('$state');
        if (state is ClearHydrateState) {
          app<NavigatorService>().buildAndPush(
            LoginView(),
          );
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: SafeArea(
            child: Scaffold(
              body: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: gradientColors,
                      ),
                    ),
                    child: _screens[_selectedIndex],
                  ),
                ),
              ),
              bottomNavigationBar: CurvedNavigationBar(
                index: _selectedIndex,
                onTap: (index) {
                  setState(() {
                    _selectedIndex = index;
                    // Reset and restart animations on tab change
                    _slideController.reset();
                    _fadeController.reset();
                    _slideController.forward();
                    _fadeController.forward();
                  });
                },
                backgroundColor: Colors.transparent,
                color: const Color(0xFF2E3192),
                items: const <Widget>[
                  Icon(Icons.home, size: 30, color: Colors.white),
                  Icon(Icons.group, size: 30, color: Colors.white),
                  Icon(Icons.person, size: 30, color: Colors.white),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class HomeScreenWidget extends StatefulWidget {
  const HomeScreenWidget({super.key});

  @override
  State<HomeScreenWidget> createState() => _HomeScreenWidgetState();
}

class _HomeScreenWidgetState extends State<HomeScreenWidget> {
  double? totalFinance;
  List<GoalModel> goals = [];

  @override
  void initState() {
    super.initState();
    // Use Future.microtask to avoid calling setState during build
    Future.microtask(() => _fetchFinanceAndGoals());
  }

  Future<void> _fetchFinanceAndGoals() async {
    final user = RepositoryProvider.of<UserModel>(context, listen: false);
    if (user.userId != null) {
      context.read<GoalsBloc>()
        ..add(GetFinanceEvents(userId: user.userId!))
        ..add(GoalsGetEvent(userId: user.userId!));
    }
  }

  Widget _buildDashboardHeader() {
    return BlocBuilder<GoalsBloc, GoalsState>(
      buildWhen: (previous, current) => current is GetFinanceSuccessState,
      builder: (context, state) {
        if (state is GetFinanceSuccessState) {
          return Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            width: double.infinity,
            height: 600, // Fixed height for the chart
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[400]!, Colors.blue[600]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: FinanceDistributionChart(
              totalFinance: double.tryParse(state.finance.income ?? '0') ?? 0.0,
            ),
          );
        }
        return const SizedBox(
          height: 300,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildGoalsCarousel() {
    return BlocBuilder<GoalsBloc, GoalsState>(
      buildWhen: (previous, current) => current is GoalsGetSuccessState,
      builder: (context, state) {
        if (state is GoalsGetSuccessState) {
          if (state.goals.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No goals yet. Add your first goal!',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            );
          }
          // Get screen dimensions
          final screenWidth = MediaQuery.of(context).size.width;
          final itemWidth = screenWidth * 0.85; // 85% of screen width
          const itemHeight = 400.0; // Fixed height for goal cards
          return Container(
            height: itemHeight,
            child: Swiper(
              itemBuilder: (context, index) {
                return Container(
                  width: itemWidth,
                  child: GoalWidget(
                    goal: state.goals[index],
                    onSocialToggle: (isSocial) {
                      context.read<GoalsBloc>().add(
                            GoalsUpdateSocialEvent(
                              goalId: state.goals[index].id!,
                              isSocial: isSocial,
                            ),
                          );
                    },
                  ),
                );
              },
              itemCount: state.goals.length,
              itemWidth: itemWidth,
              itemHeight: itemHeight,
              layout: SwiperLayout.STACK,
              scale: 0.9,
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildAddGoalButton() {
    final user = RepositoryProvider.of<UserModel>(context);
    return FloatingActionButton.extended(
      onPressed: () {
        app<NavigatorService>().buildAndPush(
          SurveyStackView(
            email: user.email!,
            userId: user.userId!,
            documentId: user.documentId!,
          ),
        );
      },
      backgroundColor: ConstantVars.maintheme,
      label: const Icon(Icons.add, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<GoalsBloc, GoalsState>(
      listener: (context, state) {
        if (state is GetFinanceSuccessState) {
          setState(() {
            totalFinance = double.tryParse(state.finance.income ?? '0') ?? 0.0;
          });
        } else if (state is GoalsGetSuccessState) {
          setState(() {
            goals = state.goals;
          });
        }
      },
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: _fetchFinanceAndGoals,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                _buildDashboardHeader(),
                const SizedBox(height: 20),
                _buildGoalsCarousel(),
              ],
            ),
          ),
        ),
        floatingActionButton: _buildAddGoalButton(),
      ),
    );
  }
}

class SocialScreenWidget extends StatefulWidget {
  const SocialScreenWidget({super.key});

  @override
  State<SocialScreenWidget> createState() => _SocialScreenWidgetState();
}

class _SocialScreenWidgetState extends State<SocialScreenWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    _controller.forward();
    _fetchSocialGoals();
  }

  void _fetchSocialGoals() {
    final user = RepositoryProvider.of<UserModel>(context, listen: false);
    if (user.userId != null) {
      context.read<GoalsBloc>().add(
            GoalsGetSocialEvent(),
          );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Goals', style: TextStyle(fontSize: 24)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              height: constraints.maxHeight,
              child: BlocBuilder<GoalsBloc, GoalsState>(
                builder: (context, state) {
                  if (state is GoalsGetSocialSuccessState) {
                    final socialGoals = state.goals
                        .where((goal) => goal.isSocial ?? false)
                        .toList();

                    if (socialGoals.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Lottie.asset(
                              'assets/survey2.json',
                              height: 200,
                              width: 200,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'No social goals yet!\nMake your goals social to see them here.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: socialGoals.length,
                      itemBuilder: (context, index) {
                        return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Container(
                              height: 400,
                              child: GoalWidget(
                                goal: socialGoals[index],
                                onSocialToggle: (isSocial) {
                                  if (socialGoals[index].userId ==
                                      RepositoryProvider.of<UserModel>(context)
                                          .userId) {
                                    context.read<GoalsBloc>().add(
                                          GoalsUpdateSocialEvent(
                                            goalId: socialGoals[index].id!,
                                            isSocial: isSocial,
                                          ),
                                        );
                                  }
                                },
                              ),
                            ));
                      },
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProfileScreenWidget extends StatefulWidget {
  const ProfileScreenWidget({super.key});

  @override
  State<ProfileScreenWidget> createState() => _ProfileScreenWidgetState();
}

class _ProfileScreenWidgetState extends State<ProfileScreenWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late GoalModel? latestGoal;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
    _fetchLatestGoal();
  }

  Future<void> _fetchLatestGoal() async {
    setState(() {
      isLoading = true;
    });
    final userId = context.read<UserModel>().userId;
    if (userId != null) {
      final goals =
          await context.read<GoalRepository>().getGoals(userId: userId);
      if (goals.isNotEmpty) {
        setState(() {
          latestGoal = goals.first;
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = RepositoryProvider.of<UserModel>(context);
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        log('state: $state', name: "profile screen");
        if (state is ClearHydrateState) {
          app<NavigatorService>().buildAndPush(LoginView());
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        alignment: Alignment.center,
                        children: [
                          // Background gradient and wave
                          Container(
                            height: 200,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.blue[400]!, Colors.blue[800]!],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Lottie.asset(
                              'assets/survey2.json',
                              fit: BoxFit.fill,
                            ),
                          ),
                          // Profile picture
                          Positioned(
                            bottom: -50,
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: user.photoUrl != null
                                    ? NetworkImage(user.photoUrl!)
                                    : const AssetImage('assets/icon.jpeg')
                                        as ImageProvider,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60),
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              Text(
                                latestGoal?.id ?? 'Anonymous User',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                user.email ?? '',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 32),
                              _buildInfoCard(
                                title: 'Your Dream',
                                value: latestGoal?.goal ?? 'Not set',
                                icon: Icons.star,
                                animation: 'assets/survey2.json',
                              ),
                              _buildInfoCard(
                                title: 'Target Amount',
                                value: latestGoal?.targetAmount.toString() ??
                                    'Not set',
                                icon: Icons.attach_money,
                                animation: 'assets/money.json',
                              ),
                              _buildInfoCard(
                                title: 'Allocated Amount',
                                value: latestGoal?.allocatedAmount.toString() ??
                                    'Not set',
                                icon: Icons.trending_up,
                                animation: 'assets/notsure.json',
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                onPressed: () {
                                  log('clicked', name: "profile screen");
                                  context
                                      .read<AuthBloc>()
                                      .add(ClearHydrateEvent());
                                },
                                icon: const Icon(Icons.logout),
                                label: const Text('Logout'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 32,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        );
      },
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required String animation,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: Lottie.asset(animation, repeat: true),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class FinanceData {
  final String category;
  final double percentage;
  final Color color;

  FinanceData(this.category, this.percentage, this.color);
}
