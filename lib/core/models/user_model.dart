// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'dart:convert';
import 'dart:core';

import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  String? email;
  String? username;
  String? userId;
  String? documentId;
  final String? uniqueUserId;
  final String? token;
  final String? refreshToken;
  String? whatDoYouWant;
  String? howMuchDoYouWant;
  String? howFarWillYouGo;
  String? whatIsYourName;
  String? photoUrl;
  final String? phoneNumber;
  final String? password;
  bool? showOnBoarding = false;
  UserModel({
    this.email,
    this.username,
    this.userId,
    this.documentId,
    this.uniqueUserId,
    this.token,
    this.refreshToken,
    this.whatDoYouWant,
    this.howMuchDoYouWant,
    this.howFarWillYouGo,
    this.whatIsYourName,
    this.photoUrl,
    this.phoneNumber,
    this.password,
    this.showOnBoarding,
  });

  UserModel copyWith({
    String? email,
    String? username,
    String? userId,
    String? documentId,
    String? uniqueUserId,
    String? token,
    String? refreshToken,
    String? whatDoYouWant,
    String? howMuchDoYouWant,
    String? howFarWillYouGo,
    String? whatIsYourName,
    String? photoUrl,
    String? phoneNumber,
    String? password,
    bool? showOnBoarding,
  }) {
    return UserModel(
      email: email ?? this.email,
      username: username ?? this.username,
      userId: userId ?? this.userId,
      documentId: documentId ?? this.documentId,
      uniqueUserId: uniqueUserId ?? this.uniqueUserId,
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      whatDoYouWant: whatDoYouWant ?? this.whatDoYouWant,
      howMuchDoYouWant: howMuchDoYouWant ?? this.howMuchDoYouWant,
      howFarWillYouGo: howFarWillYouGo ?? this.howFarWillYouGo,
      whatIsYourName: whatIsYourName ?? this.whatIsYourName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      password: password ?? this.password,
      showOnBoarding: showOnBoarding ?? this.showOnBoarding,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'username': username,
      'userId': userId,
      'documentId': documentId,
      'uniqueUserId': uniqueUserId,
      'token': token,
      'refreshToken': refreshToken,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'password': password,
      'showOnBoarding': showOnBoarding,
      'whatDoYouWant': whatDoYouWant,
      'howMuchDoYouWant': howMuchDoYouWant,
      'howFarWillYouGo': howFarWillYouGo,
      'whatIsYourName': whatIsYourName,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      email: map['email'] != null ? map['email'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      documentId:
          map['documentId'] != null ? map['documentId'] as String : null,
      uniqueUserId:
          map['uniqueUserId'] != null ? map['uniqueUserId'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
      refreshToken:
          map['refreshToken'] != null ? map['refreshToken'] as String : null,
      photoUrl: map['photoUrl'] != null ? map['photoUrl'] as String : null,
      phoneNumber:
          map['phoneNumber'] != null ? map['phoneNumber'] as String : null,
      password: map['password'] != null ? map['password'] as String : null,
      showOnBoarding:
          map['showOnBoarding'] != null ? map['showOnBoarding'] as bool : null,
      howFarWillYouGo: map['howFarWillYouGo'] != null
          ? map['howFarWillYouGo'] as String
          : null,
      howMuchDoYouWant: map['howMuchDoYouWant'] != null
          ? map['howMuchDoYouWant'] as String
          : null,
      whatDoYouWant:
          map['whatDoYouWant'] != null ? map['whatDoYouWant'] as String : null,
      whatIsYourName: map['whatIsYourName'] != null
          ? map['whatIsYourName'] as String
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      email,
      username,
      userId,
      documentId,
      uniqueUserId,
      token,
      refreshToken,
      whatDoYouWant,
      howMuchDoYouWant,
      howFarWillYouGo,
      whatIsYourName,
      photoUrl,
      phoneNumber,
      password,
      showOnBoarding,
    ];
  }
}
