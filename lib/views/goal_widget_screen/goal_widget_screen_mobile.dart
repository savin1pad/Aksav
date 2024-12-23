// ignore_for_file: unused_field, prefer_final_fields, unused_element

part of goal_widget_screen_view;

class _GoalWidgetScreenMobile extends StatefulWidget {
  final GoalModel goalModel;
  const _GoalWidgetScreenMobile({required this.goalModel});

  @override
  State<_GoalWidgetScreenMobile> createState() =>
      _GoalWidgetScreenMobileState();
}

class _GoalWidgetScreenMobileState extends State<_GoalWidgetScreenMobile>
    with TickerProviderStateMixin, LogMixin {
  int _selectedIndex = 0; // For tab selection (Plan/Chat)
  double _needsPercentage = 50; // Initial percentages
  double _wantsPercentage = 30;
  double _savingsPercentage = 20;
  TabController? _tabController;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  int touchedIndex = -1;

  List<PieChartSectionData> showingSections(Map<String, double> data) {
    return data.entries.map<PieChartSectionData>((entry) {
      final isTouched = touchedIndex == data.keys.toList().indexOf(entry.key);
      final fontSize = isTouched ? 18.0 : 14.0;
      final radius = isTouched ? 70.0 : 50.0;
      final value = entry.value;

      return PieChartSectionData(
        color: Colors.primaries[
            data.keys.toList().indexOf(entry.key) % Colors.primaries.length],
        value: value,
        title: '${value.toStringAsFixed(1)} ${entry.key}',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          overflow: TextOverflow.ellipsis,
          color: const Color(0xffffffff),
        ),
      );
    }).toList();
  }

  Future<void> _showAddFinanceDialog(BuildContext context) async {
    final TextEditingController amountController = TextEditingController();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add to Total Finance'),
          content: TextField(
            controller: amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              hintText: 'Enter amount to add',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Get the entered amount
                double amountToAdd =
                    double.tryParse(amountController.text) ?? 0.0;

                // Update the UI
                setState(() {
                  widget.goalModel.finance =
                      (widget.goalModel.finance ?? 0) + amountToAdd;
                });

                // Update the backend (replace with your actual backend logic)
                try {
                  // context.read<GoalsBloc>().add(
                  // GoalsUpdateFinanceEvent(
                  //   goalId: widget.goalModel.id!,
                  //   newFinance: widget.goalModel.finance!,
                  // ),
                  //     );
                  //
                  // Handle success (e.g., show a success message)
                } catch (e) {
                  // Handle errors (e.g., show an error message)
                  warningLog('Error updating finance: $e');
                }

                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.decelerate,
      ),
    );
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate amounts based on sliders and total finance
    // double needsAmount = (widget.goalModel.finance! * _needsPercentage) / 100;
    // double wantsAmount = (widget.goalModel.finance! * _wantsPercentage) / 100;
    // double savingsAmount =
    //     (widget.goalModel.finance! * _savingsPercentage) / 100;
    // Divide 'needs', 'wants', and 'savings' based on provided percentages

    return BlocConsumer<GoalsBloc, GoalsState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0, // Adjust as needed
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.network(
                      widget
                          .goalModel.photoUrl!, // Assuming photoUrl is not null
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ];
            },
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // Fancy Card with Slide-in Animation (using AnimatedOpacity for simplicity)
                  SlideTransition(
                    position: _slideAnimation,
                    child: Card(
                      elevation: 5,
                      margin: const EdgeInsets.all(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              'Target: ${widget.goalModel.targetAmount!.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Tabs
                  TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.deepOrange,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicatorWeight: 3,
                    tabs: [
                      // AnimatedContainer(
                      //   duration: const Duration(milliseconds: 300),
                      //   decoration: BoxDecoration(
                      //     color: _selectedIndex == 0
                      //         ? Colors.blue
                      //         : Colors.transparent,
                      //     borderRadius: BorderRadius.circular(20),
                      //   ),
                      //   child: Tab(
                      //     child: Text(
                      //       'Plan',
                      //       style: TextStyle(
                      //         color: _selectedIndex == 0
                      //             ? Colors.white
                      //             : Colors.black,
                      //         fontSize: 16,
                      //         fontWeight: FontWeight.bold,
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _selectedIndex == 1
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Tab(
                          child: Text(
                            'Social',
                            style: TextStyle(
                              color: _selectedIndex == 1
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: _selectedIndex == 2
                              ? Colors.blue
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Tab(
                          child: Text(
                            'Log',
                            style: TextStyle(
                              color: _selectedIndex == 2
                                  ? Colors.white
                                  : Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue,
                    ),
                    onTap: (index) {
                      setState(() {
                        _selectedIndex =
                            index; // Simply update the selected index
                      });
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // "Plan" Tab View
                        // LayoutBuilder(builder: (context, constraints) {
                        //   return PlanWidget(
                        //     goalModel: widget.goalModel,
                        //     needsAmount: needsAmount,
                        //     wantsAmount: wantsAmount,
                        //     savingsAmount: savingsAmount,
                        //     slideAnimation: _slideAnimation,
                        //   );
                        // }),

                        // "Social" Tab View
                        BlocProvider(
                          create: (context) => ChatBloc(
                            chatRepository: ChatRepository(),
                          ),
                          child: ChatScreen(
                            goalId: widget.goalModel.id!,
                            isLog: true,
                            currentUserId: widget.goalModel.userId!,
                          ),
                        ),
                        BlocProvider(
                          create: (context) => GoalLogBloc(
                            goalLogRepository: GoalLogRepository(),
                          ),
                          child: ChatScreen(
                            goalId: widget.goalModel.id!,
                            isLog: true,
                            currentUserId: widget.goalModel.userId!,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
