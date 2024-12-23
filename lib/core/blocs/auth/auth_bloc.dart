// ignore_for_file: public_member_api_docs, sort_constructors_first, body_might_complete_normally_nullable, prefer_final_fields, unused_field

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/repository/auth_repository.dart';
import 'package:journey/core/repository/storage_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> with LogMixin, HydratedMixin {
  final AuthRepository authRepository;
  final StorageRepository storageRepository;
  bool _isLoginSuccess = false;
  bool _isSignUpSuccess = false;
  bool _isPhoneAuthSuccess = false;
  AuthBloc({
    required this.authRepository,
    required this.storageRepository,
  }) : super(const AuthState()) {
    errorLog('checking for initial state $state');
    on<AuthEvent>((event, emit) {});

    on<FetchUserDetailsFromServer>((event, emit) async {
      emit(FetchUserLoadingState());
      try {
        final UserModel user =
            await authRepository.fetchUserDetails(userId: event.userId);
        emit(
          FetchUserSuccessState(
            userData: user,
          ),
        );
      } catch (e) {
        emit(
          FetchUserErrorState(
            message: e.toString(),
          ),
        );
      }
    });

    on<SignUpEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final UserModel user = await authRepository.signUpwithEmailAndPassword(
            password: event.password, email: event.email);
        warningLog('$user');
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', user.userId!);
        await prefs.setString('username', user.email!);
        await prefs.setString('email', event.email);
        await prefs.setString('documentId', user.documentId!);
        await prefs.setBool('showOnboarding', true);
        debugLog('Shared preference data $prefs');
        emit(
          AuthSuccess(
            email: event.email,
            userId: user.userId!,
            documentID: user.documentId!,
            showOnBoarding: true,
          ),
        );
      } on SignUpFailure catch (e) {
        warningLog(e.message);
        emit(
          SignUpFailure(
            message: e.toString(),
          ),
        );
      }
    });

    on<AuthGoogleSignInEvent>((event, emit) async {
      emit(GoogleSignInLoadingState());
      try {
        UserModel? user = await authRepository.completeGoogleSignInAndDbEntry();
        if (user?.showOnBoarding == true) {
          emit(
            AuthSuccess(
              email: user!.email,
              userId: user.userId,
              documentID: user.documentId,
              username: user.username,
              showOnBoarding: true,
            ),
          );
        } else {
          emit(
            AuthSuccess(
              email: user!.email,
              userId: user.userId,
              documentID: user.documentId,
              username: user.username,
              showOnBoarding: false,
            ),
          );
        }
      } catch (e) {
        emit(
          GoogleSignInErrorState(
            message: e.toString(),
          ),
        );
      }
    });

    on<UploadPictureAndUpdateUserData>((event, emit) async {
      emit(
        (DataUploadLoading()),
      );
      try {
        warningLog(
            'user Id ${event.userId},file ${event.file}, documentId  ${event.documentId}');
        final imageUrl =
            await storageRepository.entireUploadMediaFlowAndUpdatingUserDetails(
                xFile: event.file,
                userID: event.userId,
                email: event.email,
                userNameL: event.username,
                documentId: event.documentId);
        warningLog('$imageUrl');
        emit(
          AuthSuccess(
            username: event.username,
            userId: event.userId,
            email: event.email,
            documentID: event.documentId,
            file: imageUrl,
            onBoardingCompleted: true,
          ),
        );
      } on ErrorUploadingImageAndPatchingData catch (e) {
        errorLog(e.message);
        emit(
          ErrorUploadingImageAndPatchingData(
            message: e.toString(),
          ),
        );
      }
    });

    on<LogInEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final UserModel? userId = await authRepository.logInWithUserCredential(
            email: event.email, password: event.password);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId!.userId!);
        await prefs.setString('documentId', userId.documentId!);
        await prefs.setString('username', event.email);
        await prefs.setString('email', event.email);
        await prefs.setBool('showOnboarding', false);
        emit(
          AuthSuccess(
            email: event.email,
            userId: userId.userId,
            documentID: userId.documentId,
            showOnBoarding: false,
          ),
        );
      }
      //  on LogInFailure catch (e) {
      //   emit(
      //     AuthErrorState(
      //       message: e.toString(),
      //     ),
      //   );
      // }
      catch (e) {
        emit(
          AuthErrorState(
            message: e.toString(),
          ),
        );
      }
    });

    on<PhoneAuthenticationEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        final String? verificationId =
            await authRepository.sendCodeToPhone(event.phoneNumber);
        debugLog(
            'Id ${authRepository.verificationId} and repo $verificationId');
        emit(
          CodeSentToPhone(
            verificationId: verificationId,
            statename: 'CodeSentToPhone',
          ),
        );
      } on ErrorSendingCode catch (e) {
        emit(
          ErrorSendingCode(
              message: e.toString(), phoneNumber: event.phoneNumber),
        );
      }
    });

    on<VerifyPhoneCodeEvent>((event, emit) async {
      emit(
        VerifyingCodeState(),
      );
      try {
        final PhoneAuthCredential phoneAuthCredential =
            authRepository.phoneAuthCredentialFunction(
                verificationIdToken: event.verficationId, otp: event.code);
        debugLog('$phoneAuthCredential');
        final UserCredential userCredential = await authRepository
            .signInwithphoneCredentials(phoneAuthCredential);
        debugLog(
            'Does the user exist ?${userCredential.additionalUserInfo?.isNewUser}');
        emit(
          AuthSuccess(
            isNewUser: userCredential.additionalUserInfo!.isNewUser,
            email: userCredential.user?.phoneNumber,
            userId: userCredential.user?.uid,
            showOnBoarding: userCredential.additionalUserInfo?.isNewUser,
          ),
        );
      } on PhoneAuthFailure catch (e) {
        emit(
          PhoneAuthFailure(
            message: e.toString(),
          ),
        );
      }
    });

    on<CheckingForVerificationId>((event, emit) async {
      debugLog('${authRepository.verificationId}');
      await Future.delayed(const Duration(seconds: 15), () {
        if (authRepository.verificationId == null) {
          emit(CodeNotSentDueToViolation());
        }
      });
    });

    on<UpdateUserProfileDetails>((event, emit) async {
      emit(SignInLoading());
      try {} catch (e) {
        emit(
          ErrorPatchingUserName(
            message: e.toString(),
          ),
        );
      }
    });

    // on<FetchUserDetailsFromServer>((event, emit) async {
    //   emit(GetDataLoadingState());
    //   try {
    //     final UserModel userModel =
    //         await authRepository.fetchUserDetails(userId: event.userId);
    //     emit(
    //       UserDataFetched(userData: userModel),
    //     );
    //   } catch (e) {
    //     emit(
    //       ErrorFetchingUserData(
    //         message: e.toString(),
    //       ),
    //     );
    //   }
    // });

    on<SignInWithPhoneCredentialsEvent>((event, emit) async {
      emit(SignInLoading());
      try {
        debugLog('${event.phoneAuthCredential}');
        final UserCredential userCredential = await authRepository
            .signInwithphoneCredentials(event.phoneAuthCredential);
        debugLog(
            'Does the user exist ?${userCredential.additionalUserInfo?.isNewUser}');
        emit(
          AuthSuccess(
            isNewUser: userCredential.additionalUserInfo!.isNewUser,
            userId: userCredential.user?.uid,
            username: userCredential.user?.displayName,
          ),
        );
      } on PhoneAuthFailure catch (e) {
        emit(
          PhoneAuthFailure(
            message: e.toString(),
          ),
        );
      }
    });

    on<ForgotPasswordCodeEvent>((event, emit) async {
      emit(ForgotPasswordLoadingState());
      try {
        int? code = await authRepository.newForgotPasswordMethod(event.email);
        warningLog('code for $code');
        emit(
          ForgotPasswordSuccessState(verifyCode: code),
        );
      } on ForgotPasswordErrorState catch (e) {
        emit(
          ForgotPasswordErrorState(message: e.message),
        );
      }
    });

    on<NewForgotPasswordEvent>((event, emit) async {
      emit(NewForgotPasswordLoadingState());
      try {
        final String email =
            await authRepository.setNewpasswordMethod(email: event.email);
        emit(NewForgotPasswordSuccessState(email: email));
      } on NewForgotPasswordErrorState catch (e) {
        emit(
          NewForgotPasswordErrorState(message: e.message),
        );
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      warningLog('bloc started');
      emit(
        ResetPasswordLoadingState(),
      );
      try {
        warningLog('bloc functioning');
        await authRepository.setNewPassword(
          password: event.password,
        );
        emit(
          const ResetPasswordSuccessState(message: "Success"),
        );
      } on ResetPasswordErrorState catch (e) {
        emit(
          ResetPasswordErrorState(
            message: e.message,
          ),
        );
      } catch (e) {
        emit(
          ResetPasswordErrorState(
            message: e.toString(),
          ),
        );
      }
    });

    on<GoogleSignInEvent>((event, emit) async {
      warningLog('Google sign in');
      emit(GoogleSignInLoadingState());
      try {
        final UserModel? googleSignInAccount =
            await authRepository.completeGoogleSignInAndDbEntry();
        emit(
          AuthSuccess(
            username: googleSignInAccount?.username,
            userId: googleSignInAccount?.userId,
            documentID: googleSignInAccount?.documentId,
            isNewUser: googleSignInAccount?.showOnBoarding,
          ),
        );
      } on GoogleSignInErrorState catch (e) {
        emit(
          GoogleSignInErrorState(message: e.message),
        );
      }
    });

    on<OnAppStart>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId');
      final username = prefs.getString('username');
      final email = prefs.getString('email');
      final documentId = prefs.getString('documentId');
      final showOnboarding = prefs.getBool('showOnboarding') ??
          false; // Default to false if not found
      debugLog('Retrieved Shared Preferences Data:');
      debugLog('userId: ${prefs.getString('userId')}');
      debugLog('username: ${prefs.getString('username')}');
      debugLog('email: ${prefs.getString('email')}');
      debugLog('documentId: ${prefs.getString('documentId')}');
      debugLog('showOnboarding: ${prefs.getBool('showOnboarding')}');

      if (userId != null && username != null && email != null) {
        emit(
          AuthSuccess(
            userId: userId,
            username: username,
            email: email,
            documentID: documentId,
            showOnBoarding: showOnboarding,
          ),
        );
      } else {
        emit(AuthInitial());
      }
    });
    on<LogOutEvent>((event, emit) async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('userId');
      await prefs.remove('username');
      await prefs.remove('email');
      await prefs.remove('documentId');
      await prefs.remove('showOnboarding');
      // Log that data has been cleared
      warningLog('Shared Preferences Data Cleared');
      emit(
        AuthInitial(),
      );
    });
    // on<ClearHydrateEvent>((event, emit) => emit(ClearHydrateState()));
  }

  // @override
  // AuthState? fromJson(Map<String, dynamic> json) {
  //   warningLog('State pulled from storage $json');
  //   return AuthSuccess.fromMap(json);
  // }
  @override
  AuthState? fromJson(Map<String, dynamic> json) {
    errorLog('fromJson called with: $json'); // Log the raw JSON
    try {
      final state = AuthSuccess.fromMap(json); // Attempt deserialization
      errorLog(
          'State loaded from storage: $state'); // Log the deserialized state
      return state;
    } catch (e) {
      errorLog(
        'Error loading state from storage: $e',
      );
      return null; // Or handle the error differently, like returning an initial state
    }
  }

  @override
  Map<String, dynamic>? toJson(AuthState state) {
    if (state is AuthSuccess) {
      warningLog(
          'what state is being stored $state and toMap ${state.toMap()}');
      return state.toMap();
    }
    if (state is ClearHydrateState) {
      _clearState();
      warningLog('Cleared');
    }
  }

  void _clearState() async {
    await clear();
  }
}
