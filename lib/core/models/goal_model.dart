// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

class GoalModel extends Equatable {
  String? goal;
  double? finance;
  double? targetAmount; // Amount needed to achieve the goal
  double? allocatedAmount; // Amount allocated from finance distribution
  String? photoUrl;
  String? id;
  String? userId;
  bool? isSocial;
  bool? isCompleted;

  GoalModel({
    this.goal,
    this.finance,
    this.targetAmount,
    this.allocatedAmount,
    this.photoUrl,
    this.id,
    this.userId,
    this.isSocial,
    this.isCompleted = false,
  });

  // Update the props
  @override
  List<Object?> get props => [
        goal,
        finance,
        targetAmount,
        allocatedAmount,
        photoUrl,
        id,
        userId,
        isSocial,
        isCompleted
      ];

  // Update copyWith
  GoalModel copyWith({
    String? goal,
    double? finance,
    double? targetAmount,
    double? allocatedAmount,
    String? photoUrl,
    String? id,
    String? userId,
    bool? isSocial,
    bool? isCompleted,
  }) {
    return GoalModel(
      goal: goal ?? this.goal,
      finance: finance ?? this.finance,
      targetAmount: targetAmount ?? this.targetAmount,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      photoUrl: photoUrl ?? this.photoUrl,
      userId: userId ?? this.userId,
      id: id ?? this.id,
      isSocial: isSocial ?? this.isSocial,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  // Update toMap and fromMap methods
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'goal': goal,
      'finance': finance,
      'targetAmount': targetAmount,
      'allocatedAmount': allocatedAmount,
      'photoUrl': photoUrl,
      'id': id,
      'userId': userId,
      'isSocial': isSocial,
      'isCompleted': isCompleted,
    };
  }

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      goal: map['goal'] as String,
      finance: map['finance'] as double,
      targetAmount: map['targetAmount'] as double,
      allocatedAmount: map['allocatedAmount'] as double,
      photoUrl: map['photoUrl'] as String,
      id: map['id'] as String,
      userId: map['userId'] as String,
      isSocial: map['isSocial'] as bool,
      isCompleted: map['isCompleted'] as bool,
    );
  }
}
