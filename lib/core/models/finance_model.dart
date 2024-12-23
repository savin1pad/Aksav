// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';

import 'package:equatable/equatable.dart';

class FinanceModel extends Equatable {
  String? userId;
  String? income;
  FinanceModel({
    this.userId,
    this.income,
  });

  FinanceModel copyWith({
    String? userId,
    String? income,
  }) {
    return FinanceModel(
      userId: userId ?? this.userId,
      income: income ?? this.income,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'income': income,
    };
  }

  factory FinanceModel.fromMap(Map<String, dynamic> map) {
    return FinanceModel(
      userId: map['userId'] != null ? map['userId'] as String : null,
      income: map['income'] != null ? map['income'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory FinanceModel.fromJson(String source) =>
      FinanceModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [userId, income];
}
