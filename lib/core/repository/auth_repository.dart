// ignore_for_file: body_might_complete_normally_nullable, unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:journey/core/blocs/auth/auth_bloc.dart';
import 'package:journey/core/contants.dart';
import 'package:journey/core/logger.dart';
// import 'package:journey/core/models/customerror.dart';
import 'package:journey/core/models/httpexception.dart';
import 'package:journey/core/models/user_model.dart';
import 'package:journey/core/services/httpservice.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

class AuthRepository with LogMixin {
  String? _token;
  String? _userId;
  String? _refreshToken;
  String? _email;
  String? _verificationId;
  String? _verificationFailedMessage;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  int? _resendingtoken;
  String? _errorMessage;
  String? _codephone;
  String? _userName;
  String? _getErrorMessage;
  bool? _showErrorDialog;
  late String _documentId;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final HttpService httpService = HttpService();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  var randome = Random();

  bool? get showErrorDialog {
    return _showErrorDialog;
  }

  String? get getErrorMessage {
    return _getErrorMessage;
  }

  String? get username {
    return _userName;
  }

  String get documentId {
    return _documentId;
  }

  String? get refreshToken {
    return _refreshToken;
  }

  String? get email {
    return _email;
  }

  String? get userId {
    return _userId;
  }

  String? get token {
    return _token;
  }

  String? get verificationId {
    return _verificationId;
  }

  String? get verificationfailedMessage {
    return _verificationFailedMessage;
  }

  String? get codePhone {
    return _codephone;
  }

  String? get errorMessage {
    return _errorMessage;
  }

  int? get resendingToken {
    return _resendingtoken;
  }

  logOut() {}

  Future<UserModel> signUpwithEmailAndPassword(
      {required String password, required String email}) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAQeWJnestvLmjU2U6RqFTGG76dNfyEcZ4');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      warningLog('$response');
      final responseData = json.decode(response.body);
      debugLog('${responseData}');
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _refreshToken = responseData['refreshToken'];
      _email = responseData['email'];
      errorLog(
          'user id $_userId and email $email and refreshtoken length ${_refreshToken?.length} and token length ${_token?.length}');
      final String documentId = await createUserDetailsInDb(
        token: _token!,
        userId: _userId!,
        email: _email!,
        phoneNumber: '',
        password: password,
      );
      UserModel user = UserModel(
        email: email,
        username: '',
        userId: _userId,
        documentId: documentId,
        uniqueUserId: '',
        token: _token,
        refreshToken: _refreshToken,
        photoUrl: '',
        password: password,
      );
      return user;
    } catch (e) {
      throw SignUpFailure(
        message: e.toString(),
      );
    }
  }

  Future<GoogleSignInAccount?> handleGoogleSignIn() async {
    final GoogleSignInAccount? account;
    try {
      account = await _googleSignIn.signIn();
    } catch (e) {
      throw GoogleSignInErrorState(
        message: e.toString(),
      );
    }
    return account;
  }

  Future<String> createUserDetailsInDb({
    required String token,
    required String userId,
    required String? email,
    required String? phoneNumber,
    required String? password,
  }) async {
    final url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/userDetails.json');
    try {
      final docId = const Uuid().v4();
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'userId': userId,
          'token': token,
          'refreshToken': refreshToken,
          'documentId': docId,
          'uniqueUserId': const Uuid().v4(),
          'silentLogin': true,
          'phoneNumber': phoneNumber,
          'password': password,
        }),
      );
      final responseData = json.decode(response.body.toString()) as Map;
      warningLog(
          'the response data ${responseData.values.first} ${responseData.keys}');
      _documentId = responseData.values.first;
      warningLog(_documentId);
      return _documentId;
    } catch (e) {
      errorLog(e.toString());
      throw ErrorCreatingUserDetailsInDb(
        message: e.toString(),
      );
    }
  }

  Future<UserModel?> logInWithUserCredential(
      {required String email, required String password}) async {
    var url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAQeWJnestvLmjU2U6RqFTGG76dNfyEcZ4');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': false,
          },
        ),
      );
      final responseData = json.decode(response.body);
      dev.log('$responseData', name: 'LogInWithUserCredentials');
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _refreshToken = responseData['refreshToken'];
      _email = responseData['email'];
      final UserModel? user = await fetchUserDetailsE(email);
      return user;
    } catch (e) {
      // throw LogInFailure(message: e.toString(), email: email);
      _showErrorDialog = true;
      _getErrorMessage = e.toString();
      rethrow;
    }
  }

  Future<UserModel?> fetchUserDetailsE(String email) async {
    var url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/userDetails.json?orderBy="email"&equalTo="${email}"');
    try {
      warningLog('Checking for url $url');
      final response = await http.get(url);
      dev.log('$response and response body ${response.body}',
          name: 'Fetching User Details');
      final responseData = json.decode(response.body);

      dev.log('${response.contentLength}', name: 'FetchUserDetails');
      responseData.forEach((key, value) {
        _token = value['token'];
        _documentId = key;
        _userId = value['userId'];
        _email = value['email'];
        _refreshToken = value['refreshToken'];
      });
      UserModel userModel = UserModel(
        email: _email,
        username: '',
        userId: _userId,
        documentId: _documentId,
        uniqueUserId: '',
        token: _token,
        refreshToken: _refreshToken,
        photoUrl: '',
        password: '',
      );
      dev.log(
          'token of the user:$_token,document id of the user$_documentId, email of the user $_email, userId of the user $userId',
          name: 'Fetching User Details');
      return userModel;
    } catch (e) {
      rethrow;
    }
  }

  Future<int?> newForgotPasswordMethod(String email) async {
    dev.log('Email $email', name: 'newForgotPasswordMethod');
    String serviceId = 'service_zhc5bgh';
    String templateId = 'template_x8w1poh';
    String userId = 'B68ZoSONy8WafNwCf';
    String accessToken = 'OowDsZiGveBo9HVPlBMI7';
    var passCode = randome.nextInt(900000) + 100000;
    try {
      UserModel? idToken = await fetchUserDetailsE(email);
      dev.log('$idToken', name: 'NewForgotPasswordMethod');
      if (idToken!.token!.isEmpty) {
        dev.log('User Does Not exist', name: 'NewForgotPasswordMethod');
        throw const ForgotPasswordErrorState(
          message: 'Email does not exist',
        );
      }
      final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
      final response = await http.post(
        url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'accessToken': accessToken,
            'template_params': {
              'user_name': email,
              'user_email': email,
              'from_name': "Stories",
              'user_subject': "Resetting the password",
              'user_message': "The code to reset your password is $passCode",
              'reply_to': "mysteriumappsllp@gmail.com",
            }
          },
        ),
      );
      // ignore: unnecessary_string_interpolations
      dev.log(
          '${response.statusCode} and also passcode ${passCode} body of the response ${response.body}',
          name: 'NewForgotPasswordMethod');
      return passCode;
    } catch (e) {
      throw ForgotPasswordErrorState(
        message: e.toString(),
      );
    }
  }

  patchUserNameAndPhotoUrl(
      {required final String? userName,
      required final String? photoUrl,
      required final String? emailId,
      required final String? userId,
      required final String documentID}) async {
    var url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/userDetails/${documentID}.json');
    warningLog('$userName');
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            "userName": userName,
            "photoUrl": photoUrl,
          },
        ),
      );
      warningLog(response.body);
      final responseData = json.decode(response.body) as Map;
      debugLog('$responseData');
    } catch (e) {
      throw ErrorPatchingUserName(
        message: e.toString(),
      );
    }
  }

  patchUserDetails({required UserModel user}) async {
    var url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/userDetails/${user.documentId}.json');
    warningLog('$user');
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            "whatDoYouWant": user.whatDoYouWant,
            "whatIsYourName": user.whatIsYourName,
            "howFarWillYouGo": user.howFarWillYouGo
          },
        ),
      );
      warningLog(response.body);
      final responseData = json.decode(response.body) as Map;
      debugLog('$responseData');
    } catch (e) {
      throw ErrorPatchingUserName(
        message: e.toString(),
      );
    }
  }

  Future<UserModel> fetchUserDetails({required String userId}) async {
    var url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/userDetails.json?orderBy="userId"&equalTo="${userId}"');
    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<dynamic, dynamic>;
      dev.log('$responseData', name: 'Fetching User Details');
      dev.log('${response.contentLength}', name: 'FetchUserDetails');
      List<UserModel> userModel = [];
      responseData.forEach((key, value) {
        userModel.add(
          UserModel(
            email: value['email'],
            username: value['username'],
            userId: value['userId'],
            documentId: key,
            uniqueUserId: value['uniqueUserId'],
            token: value['token'],
            refreshToken: value['refreshToken'],
            photoUrl: value['photoUrl'],
            password: value['password'],
          ),
        );
      });

      dev.log('${userModel}', name: 'Fetching User Details');
      return userModel.first;
    } catch (e) {
      throw ErrorFetchingUserData(
        message: e.toString(),
      );
    }
  }

  Future<String?> sendCodeToPhone(String phoneNumber) async {
    var completer = Completer<String>();
    await _auth.verifyPhoneNumber(
      verificationCompleted: (PhoneAuthCredential authCredential) {},
      verificationFailed: (FirebaseAuthException authException) {
        _verificationFailedMessage = authException.message;
        errorLog('error message $_verificationFailedMessage');
        _errorMessage = verificationfailedMessage;

        throw ErrorSendingCode(
            message: authException.message, phoneNumber: phoneNumber);
      },
      codeSent: (verificationid, resendingToken) async {
        dev.log('$_verificationId',
            name: 'checking for the verification id from codesent function');
        _codephone = Constants.sentCode;
        _verificationId = verificationid;

        _resendingtoken = resendingToken;
        completer.complete(_verificationId);
      },
      codeAutoRetrievalTimeout: (verifcationid) {
        errorLog('TimeOut issue');
      },
      phoneNumber: phoneNumber,
    );
    warningLog('Sending code to phone method End ${completer.future}');
    return completer.future;
  }

  PhoneAuthCredential phoneAuthCredentialFunction(
      {required String verificationIdToken, required String otp}) {
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationIdToken, smsCode: otp);
    return phoneAuthCredential;
  }

  setNewPassword({required final String password}) async {
    final user = FirebaseAuth.instance.currentUser;
    warningLog('the password $password and user details $user');
    await user?.updatePassword(password).then((value) {
      warningLog('Password set successfully');
    }).catchError((erro) {
      warningLog('Error message ${erro}');
    });
  }

  setFinalNewPassword({required final String password}) async {
    final url = Uri.parse(
        'https://story-c0de2-default-rtdb.asia-southeast1.firebasedatabase.app/userDetails/${documentId}.json');
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            'password': password,
          },
        ),
      );
      final responseBody = json.decode(response.body);
      warningLog('Response Body $responseBody');
      return password;
    } catch (e) {
      throw ForgotPasswordErrorState(message: e.toString());
    }
  }

  Future<String> setNewpasswordMethod({required final String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).whenComplete(() {
        warningLog('Password resetfor $email');
      });
      return email;
    } catch (e) {
      throw NewForgotPasswordErrorState(message: e.toString());
    }
  }

  Future<AuthCredential?> googleSignInMethod() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) {
      warningLog('Google Sign in account is null');
      return null;
    }
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
    AuthCredential authCredential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);
    return authCredential;
  }

  Future<UserModel?> completeGoogleSignInAndDbEntry() async {
    AuthCredential? authCredential;
    try {
      authCredential = await googleSignInMethod();
    } catch (e) {
      throw const GoogleSignInErrorState(message: 'No Account found');
    }
    UserCredential userCredential =
        await _auth.signInWithCredential(authCredential!);
    if (userCredential.user == null) {
      errorLog('User not found on authentication');
    }
    if (userCredential.additionalUserInfo?.isNewUser == true) {
      final String documentId = await createUserDetailsInDb(
        token: userCredential.credential!.token.toString(),
        userId: userCredential.user!.uid,
        email: userCredential.user!.email,
        phoneNumber: userCredential.user!.phoneNumber,
        password: userCredential.additionalUserInfo!.providerId,
      );
      UserModel user = UserModel(
        email: userCredential.user?.email,
        userId: userCredential.user?.uid,
        documentId: documentId,
        username: userCredential.user?.displayName,
        token: userCredential.user?.refreshToken,
        refreshToken: userCredential.user?.refreshToken,
        phoneNumber: userCredential.user?.phoneNumber,
        photoUrl: userCredential.user?.photoURL,
        showOnBoarding: userCredential.additionalUserInfo?.isNewUser,
      );
      return user;
    } else {
      UserModel user = UserModel(
          email: userCredential.user?.email,
          userId: userCredential.user?.uid,
          documentId: documentId,
          username: userCredential.user?.displayName,
          token: userCredential.user?.refreshToken,
          refreshToken: userCredential.user?.refreshToken,
          phoneNumber: userCredential.user?.phoneNumber,
          photoUrl: userCredential.user?.photoURL,
          showOnBoarding: userCredential.additionalUserInfo?.isNewUser);
      return user;
    }
  }

  Future<UserCredential> signInwithphoneCredentials(
      PhoneAuthCredential phoneAuthCredential) async {
    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);
      // dev.log('$authCredential',
      //     name: 'Checking for authcredential in authrepository');
      warningLog(
          'checking if the user is new or not? ${authCredential.additionalUserInfo?.isNewUser}');
      warningLog('${authCredential}');
      if (authCredential.additionalUserInfo?.isNewUser == true) {
        warningLog('${authCredential.user!.phoneNumber}');
        final String newToken = const Uuid().v4();
        final String documentId = await createUserDetailsInDb(
            token: newToken,
            userId: authCredential.user!.uid,
            email: '',
            phoneNumber: authCredential.user!.phoneNumber,
            password: '');

        _userId = authCredential.user!.uid;
        _documentId = documentId;
        UserModel user = UserModel(
          userId: _userId,
          documentId: _documentId,
          phoneNumber: authCredential.user?.phoneNumber,
          token: newToken,
        );
        warningLog('$user');
        return authCredential;
      } else {
        _userId = authCredential.user!.uid;
        return authCredential;
      }
    } on FirebaseAuthException catch (e) {
      debugLog('${e.message}, ${e.credential}, ${e.code}');
      _errorMessage = e.message;
      throw PhoneAuthFailure(message: e.message!);
    }
  }
}
