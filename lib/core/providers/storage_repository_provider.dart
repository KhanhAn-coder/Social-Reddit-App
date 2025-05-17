import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/providers/firebase_providers.dart';
import 'package:reddit_app/core/type_defs.dart';

final storageRepositoryProvider = Provider((ref) => StorageRepository(firebaseStorage: ref.watch(storageProvider)));

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage}) : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String id,
    required File? file,
    required Uint8List? webFile,
  })
  async{
    try{
      String url = '';
      if(file != null){
        final ref = _firebaseStorage.ref().child(path).child(id);
        UploadTask uploadTask = ref.putFile(file!);
        final snapshot = await uploadTask;
        url = await snapshot.ref.getDownloadURL();
        //return right(await snapshot.ref.getDownloadURL());
      }
      if(webFile != null){
        final ref = _firebaseStorage.ref().child(path).child(id);
        TaskSnapshot uploadTask = await ref.putData(webFile);
        url = await uploadTask.ref.getDownloadURL();
        //final snapshot =  uploadTask;
      }
      return right(url);

    }catch(e){
      return left(Failure(e.toString()));
    }

  }
}
