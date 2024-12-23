// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable

part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class DataLoadingAuth extends AuthState {}

class SignInLoading extends AuthState {}

class CompletedSignUpFlow extends AuthState {
  final String username;
  final String email;
  final String userId;
  final XFile? file;
  const CompletedSignUpFlow({
    required this.username,
    required this.email,
    required this.userId,
    this.file,
  });

  @override
  List<Object?> get props => [username, email, userId, file];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'userId': userId,
      'file': file,
    };
  }

  factory CompletedSignUpFlow.fromMap(Map<String, dynamic> map) {
    return CompletedSignUpFlow(
        username: map['username'] as String,
        email: map['email'] as String,
        userId: map['userId'] as String,
        file: map['file']);
  }

  String toJson() => json.encode(toMap());

  factory CompletedSignUpFlow.fromJson(String source) =>
      CompletedSignUpFlow.fromMap(json.decode(source) as Map<String, dynamic>);
}

class SignUpSuccess extends AuthState {
  final String email;
  final String userId;
  final String documentID;
  final String statname;
  const SignUpSuccess({
    required this.email,
    required this.userId,
    required this.documentID,
    required this.statname,
  });
  @override
  List<Object> get props => [email, userId, documentID];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'userId': userId,
      'documentID': documentID,
      'statname': statname,
    };
  }

  factory SignUpSuccess.fromMap(Map<String, dynamic> map) {
    return SignUpSuccess(
      email: map['email'] as String,
      userId: map['userId'] as String,
      documentID: map['documentID'] as String,
      statname: map['statname'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SignUpSuccess.fromJson(String source) =>
      SignUpSuccess.fromMap(json.decode(source) as Map<String, dynamic>);

  SignUpSuccess copyWith({
    String? email,
    String? userId,
    String? documentID,
    String? statname,
  }) {
    return SignUpSuccess(
      email: email ?? this.email,
      userId: userId ?? this.userId,
      documentID: documentID ?? this.documentID,
      statname: statname ?? this.statname,
    );
  }
}

class LogInSuccess extends AuthState {
  final String email;
  final String userId;
  final String stateName;
  const LogInSuccess({
    required this.email,
    required this.userId,
    required this.stateName,
  });
  @override
  List<Object> get props => [email, userId];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'email': email,
      'userId': userId,
      'stateName': stateName,
    };
  }

  factory LogInSuccess.fromMap(Map<String, dynamic> map) {
    return LogInSuccess(
      email: map['email'] as String,
      userId: map['userId'] as String,
      stateName: map['stateName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LogInSuccess.fromJson(String source) =>
      LogInSuccess.fromMap(json.decode(source) as Map<String, dynamic>);

  LogInSuccess copyWith({
    String? email,
    String? userId,
    String? stateName,
  }) {
    return LogInSuccess(
      email: email ?? this.email,
      userId: userId ?? this.userId,
      stateName: stateName ?? this.stateName,
    );
  }
}

class ForgotPasswordLoadingState extends AuthState {}

class ForgotPasswordSuccessState extends AuthState {
  final dynamic verifyCode;
  const ForgotPasswordSuccessState({
    required this.verifyCode,
  });
  @override
  List<Object> get props => [
        verifyCode,
      ];
}

class ForgotPasswordErrorState extends AuthState {
  final String message;
  const ForgotPasswordErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}

class ResetPasswordErrorState extends AuthState {
  final String message;
  const ResetPasswordErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}

class ResetPasswordLoadingState extends AuthState {}

class ResetPasswordSuccessState extends AuthState {
  final String message;
  const ResetPasswordSuccessState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}

class NewForgotPasswordLoadingState extends AuthState {}

class NewForgotPasswordErrorState extends AuthState {
  final String message;
  const NewForgotPasswordErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [
        message,
      ];
}

class NewForgotPasswordSuccessState extends AuthState {
  final String email;
  const NewForgotPasswordSuccessState({
    required this.email,
  });
  @override
  List<Object> get props => [
        email,
      ];
}

class GoogleSignInErrorState extends AuthState {
  final String message;
  const GoogleSignInErrorState({
    required this.message,
  });
}

class GoogleSignInLoadingState extends AuthState {}

class GoogleSignInSuccessState extends AuthState {
  final String email;
  final String userId;
  final String documentId;
  const GoogleSignInSuccessState({
    required this.email,
    required this.userId,
    required this.documentId,
  });
}

class ResetAuthState extends AuthState {}

class PhoneAuthSuccess extends AuthState {
  final bool isNewUser;
  final UserCredential userCredential;
  final String statname;
  const PhoneAuthSuccess({
    required this.isNewUser,
    required this.userCredential,
    required this.statname,
  });
  @override
  List<Object> get props => [isNewUser, userCredential];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'isNewUser': isNewUser,
      'userCredential': userCredential,
      'statname': statname,
    };
  }

  factory PhoneAuthSuccess.fromMap(Map<String, dynamic> map) {
    return PhoneAuthSuccess(
      isNewUser: map['isNewUser'] as bool,
      userCredential: map['userCredential'] as UserCredential,
      statname: map['statname'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory PhoneAuthSuccess.fromJson(String source) =>
      PhoneAuthSuccess.fromMap(json.decode(source) as Map<String, dynamic>);

  PhoneAuthSuccess copyWith({
    bool? isNewUser,
    UserCredential? userCredential,
    String? statname,
  }) {
    return PhoneAuthSuccess(
      isNewUser: isNewUser ?? this.isNewUser,
      userCredential: userCredential ?? this.userCredential,
      statname: statname ?? this.statname,
    );
  }
}

class ClearHydrateState extends AuthState {}

class AuthSuccess extends AuthState {
  final String? username;
  final String? email;
  final String? userId;
  final String? file;
  final bool? isNewUser;
  final String? documentID;
  final UserCredential? userCredential;
  final bool? showOnBoarding;
  final bool? onBoardingCompleted;
  const AuthSuccess({
    this.username,
    this.email,
    this.userId,
    this.file,
    this.isNewUser,
    this.documentID,
    this.userCredential,
    this.showOnBoarding,
    this.onBoardingCompleted,
  });

  AuthSuccess copyWith({
    String? username,
    String? email,
    String? userId,
    String? file,
    bool? isNewUser,
    String? documentID,
    UserCredential? userCredential,
    bool? showOnBoarding,
    bool? onBoardingCompleted,
  }) {
    return AuthSuccess(
      username: username ?? this.username,
      email: email ?? this.email,
      userId: userId ?? this.userId,
      file: file ?? this.file,
      isNewUser: isNewUser ?? this.isNewUser,
      documentID: documentID ?? this.documentID,
      userCredential: userCredential ?? this.userCredential,
      showOnBoarding: showOnBoarding ?? this.showOnBoarding,
      onBoardingCompleted: onBoardingCompleted ?? this.onBoardingCompleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'userId': userId,
      'file': file,
      'isNewUser': isNewUser,
      'documentID': documentID,
      'userCredential': userCredential,
      'showOnBoarding': showOnBoarding,
      'onBoardingCompleted': onBoardingCompleted,
    };
  }

  factory AuthSuccess.fromMap(Map<String, dynamic> map) {
    return AuthSuccess(
      username: map['username'] != null ? map['username'] as String : null,
      email: map['email'] != null ? map['email'] as String : null,
      userId: map['userId'] != null ? map['userId'] as String : null,
      file: map['file'] != null ? map['file'] as String : null,
      isNewUser: map['isNewUser'] != null ? map['isNewUser'] as bool : null,
      documentID:
          map['documentID'] != null ? map['documentID'] as String : null,
      userCredential: map['userCredential'] != null
          ? map['userCredential'] as UserCredential
          : null,
      showOnBoarding:
          map['showOnBoarding'] != null ? map['showOnBoarding'] as bool : null,
      onBoardingCompleted: map['onBoardingCompleted'] != null
          ? map['onBoardingCompleted'] as bool
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory AuthSuccess.fromJson(String source) =>
      AuthSuccess.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AuthSuccess(username: $username, email: $email, userId: $userId, file: $file, isNewUser: $isNewUser, documentID: $documentID, userCredential: $userCredential, showOnBoarding: $showOnBoarding, onBoardingCompleted: $onBoardingCompleted)';
  }

  @override
  List<Object?> get props => [
        username,
        userCredential,
        email,
        userId,
        username,
        documentID,
        showOnBoarding,
        onBoardingCompleted,
        file,
        isNewUser,
      ];
}

class CodeSentToPhone extends AuthState {
  final String? verificationId;
  final String statename;
  const CodeSentToPhone({
    required this.verificationId,
    required this.statename,
  });
  @override
  List<Object?> get props => [verificationId, statename];

  CodeSentToPhone copyWith({
    String? verificationId,
    String? statename,
  }) {
    return CodeSentToPhone(
      verificationId: verificationId ?? this.verificationId,
      statename: statename ?? this.statename,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'verificationId': verificationId,
      'statename': statename,
    };
  }

  factory CodeSentToPhone.fromMap(Map<String, dynamic> map) {
    return CodeSentToPhone(
      verificationId: map['verificationId'] != null
          ? map['verificationId'] as String
          : null,
      statename: map['statename'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CodeSentToPhone.fromJson(String source) =>
      CodeSentToPhone.fromMap(json.decode(source) as Map<String, dynamic>);
}

class CodeVerified extends AuthState {
  final PhoneAuthCredential phoneAuthCredential;
  final String stateName;
  const CodeVerified({
    required this.phoneAuthCredential,
    required this.stateName,
  });
  @override
  List<Object> get props => [phoneAuthCredential, stateName];

  CodeVerified copyWith({
    PhoneAuthCredential? phoneAuthCredential,
    String? stateName,
  }) {
    return CodeVerified(
      phoneAuthCredential: phoneAuthCredential ?? this.phoneAuthCredential,
      stateName: stateName ?? this.stateName,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'phoneAuthCredential': phoneAuthCredential,
      'stateName': stateName,
    };
  }

  factory CodeVerified.fromMap(Map<String, dynamic> map) {
    return CodeVerified(
      phoneAuthCredential: map['phoneAuthCredential'] as PhoneAuthCredential,
      stateName: map['stateName'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory CodeVerified.fromJson(String source) =>
      CodeVerified.fromMap(json.decode(source) as Map<String, dynamic>);
}

class VerifyingCodeState extends AuthState {}

class ErrorVerifyingCode extends AuthState {
  final String message;
  const ErrorVerifyingCode({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class DataUploadLoading extends AuthState {}

class ErrorUploadingImageAndPatchingData extends AuthState {
  final String message;

  const ErrorUploadingImageAndPatchingData({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class FetchUserLoadingState extends AuthState {}

class FetchUserSuccessState extends AuthState {
  final UserModel userData;

  const FetchUserSuccessState({
    required this.userData,
  });

  @override
  List<Object> get props => [userData];
}

class FetchUserErrorState extends AuthState {
  final String message;
  const FetchUserErrorState({
    required this.message,
  });

  @override
  List<Object> get props => [message];
}

class LogInFailure extends AuthState {
  final String message;
  final String email;
  const LogInFailure({required this.message, required this.email});
  @override
  List<Object> get props => [message, email];
}

class SignUpFailure extends AuthState {
  final String message;
  const SignUpFailure({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class GetDataLoadingState extends AuthState {}

class UserDataFetched extends AuthState {
  final UserModel userData;
  const UserDataFetched({
    required this.userData,
  });
  @override
  List<Object> get props => [userData];
}

class ErrorFetchingUserData extends AuthState {
  final String message;
  const ErrorFetchingUserData({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ErrorPatchingUserName extends AuthState {
  final String message;
  const ErrorPatchingUserName({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ErrorCreatingUserDetailsInDb extends AuthState {
  final String message;
  const ErrorCreatingUserDetailsInDb({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class PhoneAuthFailure extends AuthState {
  final String message;
  const PhoneAuthFailure({required this.message});
  @override
  List<Object> get props => [message];
}

class NewErrorSendingCode extends AuthState {
  final String message;
  const NewErrorSendingCode({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class BufferStatePhoneCode extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  const AuthErrorState({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class ErrorSendingCode extends AuthState {
  final String? message;
  final String phoneNumber;
  const ErrorSendingCode({
    required this.message,
    required this.phoneNumber,
  });
  @override
  List<Object?> get props => [phoneNumber, message];
}

class CodeNotSentDueToViolation extends AuthState {}
