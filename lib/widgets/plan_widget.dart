// ignore_for_file: must_be_immutable

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/goal_model.dart';
import 'package:journey/global/constants.dart';

class PlanWidget extends StatefulWidget {
  final GoalModel goalModel;
  double needsAmount;
  double wantsAmount;
  double savingsAmount;
  final Animation<Offset> slideAnimation;
  PlanWidget({
    Key? key,
    required this.goalModel,
    required this.needsAmount,
    required this.wantsAmount,
    required this.savingsAmount,
    required this.slideAnimation,
    // Initialize other parameters
  }) : super(key: key);

  @override
  State<PlanWidget> createState() => _PlanWidgetState();
}

class _PlanWidgetState extends State<PlanWidget>
    with TickerProviderStateMixin, LogMixin {
  int touchedIndex = -1;
  double _needsPercentage = 50; // Initial percentages
  double _wantsPercentage = 30;
  double _savingsPercentage = 20;
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

  @override
  Widget build(BuildContext context) {
    double needsAmount = (widget.goalModel.finance! * _needsPercentage) / 100;
    double wantsAmount = (widget.goalModel.finance! * _wantsPercentage) / 100;
    double savingsAmount =
        (widget.goalModel.finance! * _savingsPercentage) / 100;
    Map<String, double> needsData = {
      'Grocery': needsAmount * 0.15,
      'Rent/Loan': needsAmount * 0.30,
      'Insurance': needsAmount * 0.25,
      'Healthcare': needsAmount * 0.10,
      'Transportation': needsAmount * 0.20,
    };
    Map<String, double> wantsData = {
      'Restaurants': wantsAmount * 0.20,
      'Travels': wantsAmount * 0.15,
      'Shopping': wantsAmount * 0.27,
      'Entertainment': wantsAmount * 0.10,
      'Personal Care': wantsAmount * 0.16,
      'Hobbies/Skill Enhancement': wantsAmount * 0.12,
    };
    Map<String, double> savingsData = {
      'FD/RD/Gold': savingsAmount * 0.20,
      'Mutual Funds': savingsAmount * 0.30,
      'Stocks': savingsAmount * 0.10,
      'Towards Goals': savingsAmount * 0.40,
    };
    return SingleChildScrollView(
      child: Column(
        children: [
          SlideTransition(
            position: widget.slideAnimation,
            child: Slider(
              value: _needsPercentage.clamp(0, 100),
              onChanged: (value) {
                setState(() {
                  _needsPercentage = value;
                  // If needs + wants > 100, adjust wants, else adjust savings
                  if (_needsPercentage + _wantsPercentage > 100) {
                    _wantsPercentage = 100 - _needsPercentage;
                    _savingsPercentage = 0; // Ensure savings is 0 if needed
                  } else {
                    _savingsPercentage =
                        100 - _needsPercentage - _wantsPercentage;
                  }
                });
              },
              min: 0,
              max: 100,
              divisions: 100,
              label: 'Needs: ${_needsPercentage.round()}%',
            ),
          ),
          // Chart Area (switch based on selected tab)
          SlideTransition(
            position: widget.slideAnimation,
            child: const Text(
              'NEEDS',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SlideTransition(
            position: widget.slideAnimation,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ConstantVars.maintheme,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 100,
                  width: 250,
                  decoration: const BoxDecoration(),
                  child: SlideTransition(
                    position: widget.slideAnimation,
                    child: PieChart(
                      PieChartData(
                        sections: showingSections(needsData),
                        sectionsSpace: 0,
                        centerSpaceRadius: 70,
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (event is FlTapUpEvent ||
                                event is FlLongPressEnd ||
                                event is FlPanEndEvent) {
                              touchedIndex =
                                  -1; // Reset if it's a tap up or end of long press/pan
                            } else if (event is FlTapDownEvent &&
                                pieTouchResponse
                                        ?.touchedSection?.touchedSectionIndex !=
                                    null) {
                              // Only update touchedIndex if a section is actually touched
                              touchedIndex = pieTouchResponse!
                                  .touchedSection!.touchedSectionIndex;
                              warningLog('touched index : $touchedIndex');
                            }
                          });
                        }),
                        // pieTouchData: PieTouchData(
                        //   touchCallback:
                        //       (FlTouchEvent event, pieTouchResponse) {
                        //     setState(() {
                        //       final desiredTouch = pieTouchResponse
                        //           ?.touchedSection
                        //           ?.touchedSection is! PointerUpEvent;
                        //       if (desiredTouch &&
                        //           pieTouchResponse?.touchedSection != null &&
                        //           pieTouchResponse?.touchedSection!
                        //                   .touchedSectionIndex !=
                        //               null) {
                        //         final index = pieTouchResponse
                        //             ?.touchedSection!.touchedSectionIndex;
                        //         // Update the title of the touched section
                        //         final updatedSections =
                        //             needsData.entries.map((entry) {
                        //           return PieChartSectionData(
                        //             value: entry.value,
                        //             title: needsData.keys
                        //                         .toList()[index ?? 0] ==
                        //                     entry.key
                        //                 ? entry.key
                        //                 : '', // Show title only for touched section
                        //             color: Colors.primaries[needsData.keys
                        //                     .toList()
                        //                     .indexOf(entry.key) %
                        //                 Colors.primaries.length],
                        //           );
                        //         }).toList();
                        //         // Update the chart data
                        //         needsData = {
                        //           for (var section in updatedSections)
                        //             section.title: section.value
                        //         };
                        //       } else {
                        //         // Reset titles when no section is touched
                        //         needsData = {
                        //           for (var entry in needsData.entries)
                        //             entry.key: entry.value
                        //         };
                        //       }
                        //     });
                        //   },
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SlideTransition(
              position: widget.slideAnimation,
              child: Slider(
                value: _wantsPercentage.clamp(0, 100),
                onChanged: (value) {
                  setState(() {
                    _wantsPercentage = value;
                    // If wants + savings > 100, adjust savings, else adjust needs
                    if (_wantsPercentage + _savingsPercentage > 100) {
                      _savingsPercentage = 100 - _wantsPercentage;
                      _needsPercentage = 0; // Ensure needs is 0 if needed
                    } else {
                      _needsPercentage =
                          100 - _wantsPercentage - _savingsPercentage;
                    }
                  });
                },
                min: 0,
                max: 100,
                divisions: 100,
                label: 'Wants: ${_wantsPercentage.round()}%',
              ),
            ),
          ),
          SlideTransition(
            position: widget.slideAnimation,
            child: const Text(
              'WANTS',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SlideTransition(
            position: widget.slideAnimation,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ConstantVars.maintheme,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  height: 100,
                  width: 250,
                  decoration: const BoxDecoration(),
                  child: SlideTransition(
                    position: widget.slideAnimation,
                    child: PieChart(
                      PieChartData(
                        sections: showingSections(wantsData),
                        //  wantsData.entries.map((entry) {
                        //   return PieChartSectionData(
                        //     value: entry.value,
                        //     title: entry.key,
                        //     color: Colors.primaries[
                        //         wantsData.keys.toList().indexOf(entry.key) %
                        //             Colors.primaries.length],
                        //     // Assign colors from a list, cycling if needed
                        //   );
                        // }).toList(),
                        sectionsSpace: 0,
                        centerSpaceRadius: 70,
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (event is FlTapUpEvent ||
                                event is FlLongPressEnd ||
                                event is FlPanEndEvent) {
                              touchedIndex =
                                  -1; // Reset if it's a tap up or end of long press/pan
                            } else if (event is FlTapDownEvent &&
                                pieTouchResponse
                                        ?.touchedSection?.touchedSectionIndex !=
                                    null) {
                              // Only update touchedIndex if a section is actually touched
                              touchedIndex = pieTouchResponse!
                                  .touchedSection!.touchedSectionIndex;
                              warningLog('touched index : $touchedIndex');
                            }
                          });
                        }),
                        // pieTouchData: PieTouchData(
                        //   touchCallback:
                        //       (FlTouchEvent event, pieTouchResponse) {
                        //     setState(() {
                        //       final desiredTouch = pieTouchResponse
                        //           ?.touchedSection
                        //           ?.touchedSection is! PointerUpEvent;
                        //       if (desiredTouch &&
                        //           pieTouchResponse?.touchedSection !=
                        //               null &&
                        //           pieTouchResponse?.touchedSection!
                        //                   .touchedSectionIndex !=
                        //               null) {
                        //         final index = pieTouchResponse
                        //             ?.touchedSection!.touchedSectionIndex;
                        //         // Update the title of the touched section
                        //         final updatedSections =
                        //             wantsData.entries.map((entry) {
                        //           return PieChartSectionData(
                        //             value: entry.value,
                        //             title: wantsData.keys
                        //                         .toList()[index ?? 0] ==
                        //                     entry.key
                        //                 ? entry.key
                        //                 : '', // Show title only for touched section
                        //             color: Colors.primaries[wantsData.keys
                        //                     .toList()
                        //                     .indexOf(entry.key) %
                        //                 Colors.primaries.length],
                        //           );
                        //         }).toList();
                        //         // Update the chart data
                        //         wantsData = {
                        //           for (var section in updatedSections)
                        //             section.title: section.value
                        //         };
                        //       } else {
                        //         // Reset titles when no section is touched
                        //         wantsData = {
                        //           for (var entry in needsData.entries)
                        //             entry.key: entry.value
                        //         };
                        //       }
                        //     });
                        //   },
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: SlideTransition(
              position: widget.slideAnimation,
              child: Slider(
                value: _savingsPercentage.clamp(0, 100),
                onChanged: (value) {
                  setState(() {
                    _savingsPercentage = value;
                    // If needs + savings > 100, adjust needs, else adjust wants
                    if (_needsPercentage + _savingsPercentage > 100) {
                      _needsPercentage = 100 - _savingsPercentage;
                      _wantsPercentage = 0; // Ensure wants is 0 if needed
                    } else {
                      _wantsPercentage =
                          100 - _needsPercentage - _savingsPercentage;
                    }
                  });
                },
                min: 0,
                max: 100,
                divisions: 100,
                label: 'Savings: ${_savingsPercentage.round()}%',
              ),
            ),
          ),
          SlideTransition(
            position: widget.slideAnimation,
            child: const Text(
              'SAVINGS',
              style: TextStyle(color: Colors.black),
            ),
          ),
          SlideTransition(
            position: widget.slideAnimation,
            child: Container(
              height: 300,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ConstantVars.maintheme,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: 100,
                  width: 250,
                  decoration: const BoxDecoration(),
                  child: SlideTransition(
                    position: widget.slideAnimation,
                    child: PieChart(
                      PieChartData(
                        sections: showingSections(savingsData),
                        //  savingsData.entries.map((entry) {
                        //   return PieChartSectionData(
                        //     value: entry.value,
                        //     title: entry.key,
                        //     color: Colors.primaries[savingsData.keys
                        //             .toList()
                        //             .indexOf(entry.key) %
                        //         Colors.primaries.length],
                        //     // Assign colors from a list, cycling if needed
                        //   );
                        // }).toList(),
                        sectionsSpace: 0,
                        centerSpaceRadius: 70,
                        pieTouchData: PieTouchData(touchCallback:
                            (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (event is FlTapUpEvent ||
                                event is FlLongPressEnd ||
                                event is FlPanEndEvent) {
                              touchedIndex =
                                  -1; // Reset if it's a tap up or end of long press/pan
                            } else if (event is FlTapDownEvent &&
                                pieTouchResponse
                                        ?.touchedSection?.touchedSectionIndex !=
                                    null) {
                              // Only update touchedIndex if a section is actually touched
                              touchedIndex = pieTouchResponse!
                                  .touchedSection!.touchedSectionIndex;
                              warningLog('touched index : $touchedIndex');
                            }
                          });
                        }),
                        // pieTouchData: PieTouchData(
                        //   touchCallback:
                        //       (FlTouchEvent event, pieTouchResponse) {
                        //     setState(() {
                        //       final desiredTouch = pieTouchResponse
                        //           ?.touchedSection
                        //           ?.touchedSection is! PointerUpEvent;
                        //       if (desiredTouch &&
                        //           pieTouchResponse?.touchedSection !=
                        //               null &&
                        //           pieTouchResponse?.touchedSection!
                        //                   .touchedSectionIndex !=
                        //               null) {
                        //         final index = pieTouchResponse
                        //             ?.touchedSection!.touchedSectionIndex;
                        //         // Update the title of the touched section
                        //         final updatedSections =
                        //             savingsData.entries.map((entry) {
                        //           return PieChartSectionData(
                        //             value: entry.value,
                        //             title: savingsData.keys
                        //                         .toList()[index ?? 0] ==
                        //                     entry.key
                        //                 ? entry.key
                        //                 : '', // Show title only for touched section
                        //             color: Colors.primaries[savingsData.keys
                        //                     .toList()
                        //                     .indexOf(entry.key) %
                        //                 Colors.primaries.length],
                        //           );
                        //         }).toList();
                        //         // Update the chart data
                        //         savingsData = {
                        //           for (var section in updatedSections)
                        //             section.title: section.value
                        //         };
                        //       } else {
                        //         // Reset titles when no section is touched
                        //         savingsData = {
                        //           for (var entry in needsData.entries)
                        //             entry.key: entry.value
                        //         };
                        //       }
                        //     });
                        //   },
                        // ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 400,
          )
        ],
      ),
    );
  }
}
