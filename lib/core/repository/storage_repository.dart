import 'dart:developer' as dev;
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:journey/core/blocs/auth/auth_bloc.dart';
import 'package:journey/core/logger.dart';
import 'package:journey/core/repository/auth_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as im;

import '../get.dart';

class StorageRepository with LogMixin {
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _file;

  XFile? get image {
    return _file;
  }

  final storageRefUserProfile = FirebaseStorage.instance.ref();

  Future<XFile?> handlecameraOpening() async {
    final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 70);
    dev.log('$image', name: 'StorageRepository');
    return image;
  }

  Future<XFile?> handleGallerOpening() async {
    final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 70);
    debugLog('$image');
    return image;
  }

  Future<XFile?> getLostData() async {
    final LostDataResponse response = await _imagePicker.retrieveLostData();
    if (response.isEmpty) {
      return null;
    }
    if (response.file != null) {
      _file = response.file;
      return _file;
    } else {
      return null;
    }
  }

  Future<File?> compressMedia({XFile? xfile, String? userID}) async {
    File file = File(xfile!.path);
    final tempdir = await getTemporaryDirectory();
    final path = tempdir.path;
    im.Image? imageFile = im.decodeImage(file.readAsBytesSync());
    final compressedMedia = File('$path/img_$userID.jpg')
      ..writeAsBytesSync(im.encodeJpg(imageFile!, quality: 85));
    return compressedMedia;
  }

  Future<String?> uploadMedia({File? file, String? userID}) async {
    final ref =
        storageRefUserProfile.child('GoalsImages').child('GoalPic_$userID}');
    final TaskSnapshot task = await ref.putFile(file!);
    warningLog('${task.storage}');
    final String downloadUrl = await ref.getDownloadURL();
    warningLog(downloadUrl);
    return downloadUrl;
  }

  Future<String?> uploadLogMedia(
      {File? file, String? userID, String? goalId}) async {
    final ref = storageRefUserProfile
        .child('GoalsLogImages')
        .child('GoalPic_${userID}_$goalId}');
    final TaskSnapshot task = await ref.putFile(file!);
    warningLog('${task.storage}');
    final String downloadUrl = await ref.getDownloadURL();
    warningLog('checking for the url lof$downloadUrl');
    return downloadUrl;
  }

  // ignore: body_might_complete_normally_nullable
  Future<String?> entireUploadMediaFlowAndUpdatingUserDetails(
      {XFile? xFile,
      String? userID,
      String? userNameL,
      String? email,
      required String documentId}) async {
    warningLog(
        'checking file ${xFile?.name} , path to the file ${xFile?.path}');
    if (xFile == null) {
      try {
        warningLog('if the file is not there $userNameL');
        await app<AuthRepository>().patchUserNameAndPhotoUrl(
          userName: userNameL,
          photoUrl: '',
          emailId: email,
          userId: userID,
          documentID: documentId,
        );
      } catch (e) {
        errorLog(e.toString());
        throw ErrorUploadingImageAndPatchingData(
          message: e.toString(),
        );
      }
    } else {
      try {
        warningLog('$userNameL');
        final File? compressedFile =
            await compressMedia(xfile: xFile, userID: userID);
        final String? profileImageUrl =
            await uploadMedia(file: compressedFile, userID: userID);
        await app<AuthRepository>().patchUserNameAndPhotoUrl(
          userName: userNameL,
          photoUrl: profileImageUrl,
          emailId: email,
          documentID: documentId,
          userId: userID,
        );
        return profileImageUrl;
      } catch (e) {
        errorLog(e.toString());
        throw ErrorUploadingImageAndPatchingData(
          message: e.toString(),
        );
      }
    }
  }
}
