import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart' as Paths;
import 'package:firebase_storage/firebase_storage.dart';

class PictureBloc {
  PictureBlocState blocState;
  String latestError = '';
  String displayMessage = '';
  String dbReference;
  String noConnectionError;
  String selectionError;
  String fireStoreReferenceFolder;

  final _StateController = BehaviorSubject<PictureBlocState>();

  StreamSink<PictureBlocState> get _stateSink => _StateController.sink;

  Stream<PictureBlocState> get StateStream => _StateController.stream;

  final _EventController = StreamController<PictureBlocEvent>();

  Sink<PictureBlocEvent> get EventSink => _EventController.sink;

  PictureBloc(
      {this.dbReference,
      this.noConnectionError,
      this.selectionError,
      @required this.fireStoreReferenceFolder}) {
    if (noConnectionError == null) {
      noConnectionError =
          'Something whent wrong! \n Please check your Connection';
    }
    if (selectionError == null) {
      selectionError =
          'This picture could not be selected \n Check if it is JPG';
    }
    blocState = PictureBlocState(dbReference: this.dbReference);
    _stateSink.add(blocState);
    _EventController.stream.listen(_mapEventToState);
  }

  void refresh(PictureBlocUIState state) async {
    blocState.state = state;
    _stateSink.add(blocState);
  }

  void _mapEventToState(PictureBlocEvent event) async {
    this.latestError = '';
    this.displayMessage = '';
    if (event is PictureSelectEvent) {
      refresh(PictureBlocUIState.Waiting);
      await blocState.selected(pic: event.pictureFile).then((value) {
        if (value == '') {
          refresh(PictureBlocUIState.Fin);
        } else {
          refresh(PictureBlocUIState.Fail);
          latestError = value;
          displayMessage = selectionError;
        }
        return value;
      });
    }

    if (event is PictureResizeEvent) {
      refresh(PictureBlocUIState.Waiting);
      String result;
      try {
        result = await blocState.resize().then((value) {
          if (value == '') {
            refresh(PictureBlocUIState.Fin);
            displayMessage = 'Bild wurde geladen!!';
            return value;
          } else {
            refresh(PictureBlocUIState.Fail);
            latestError = value;
            displayMessage = 'Es ist ein fehler aufgetreten';
            return value;
          }
        });
      } catch (e) {}
    }

    if (event is PictureUploadEvent) {
      refresh(PictureBlocUIState.Waiting);
      String result;
      try {
        result = await blocState
            .doUpload(reference: fireStoreReferenceFolder)
            .then((value) {
          if (value == '') {
            refresh(PictureBlocUIState.Fin);
            displayMessage = 'Bild wurde geladen!!';
            return value;
          } else {
            refresh(PictureBlocUIState.Fail);
            latestError = value;
            displayMessage = noConnectionError;
            return value;
          }
        });
      } catch (e) {
        print('upload ${e.toString()}');
      }
    }

    if (event is PictureDownLoadEvent) {
      refresh(PictureBlocUIState.Waiting);
      String result;
      try {
        result = await blocState.doDownloadFile(path: event.path).then((value) {
          if (value == '') {
            refresh(PictureBlocUIState.Fin);
            displayMessage = 'Bild wurde geladen!!';
            return value;
          } else {
            refresh(PictureBlocUIState.Fail);
            latestError = value;
            displayMessage = noConnectionError;
            return value;
          }
        });
      } catch (e) {
        print('download ${e.toString()}');
      }
    }
    if (event is PictureSelectWithUploadEvent) {
      refresh(PictureBlocUIState.Waiting);
      String result;
      try {
        result = await blocState
            .selected(pic: event.pictureFile)
            .then((value) async {
          if (value == '') {
            value = await blocState
                .doUpload(reference: fireStoreReferenceFolder)
                .then((iValue) {
              if (value == '') {
                displayMessage = 'Bild wurde geladen!!';
                return value;
              } else {
                latestError = value;
                displayMessage = noConnectionError;
                return value;
              }
            });
            return value;
          } else {
            latestError = value;
            displayMessage = noConnectionError;
            return value;
          }
        });
        if (result == '') {
          refresh(PictureBlocUIState.Fin);
        } else {
          refresh(PictureBlocUIState.Fail);
        }
      } catch (e) {
        print('download ${e.toString()}');
      }
    }
  }

  void dispose() {
    _StateController.close();
    _EventController.close();
  }
}

class PictureBlocState {
  PictureBlocUIState state = PictureBlocUIState.NotDet;
  File picFile;
  File resizedPicFile;
  File downloadedPicFile;
  String dbReference;

  PictureBlocState({this.dbReference});

  String getSavableDateString(DateTime t) {
    String date = t.toIso8601String().split('T')[0];
    String returnString =
        '${date.split('-')[2]}_${date.split('-')[1]}_${date.split('-')[0]}_${t.millisecondsSinceEpoch.toString()}';
    return returnString;
  }

  Future<String> selected({File pic}) async {
    String returnValue = '';
    try {
      if (pic.path.contains('.jpg') || pic.path.contains('.png')) {
        picFile = pic;
      }
    } catch (e) {
      returnValue = e.toString();
    }
    return returnValue;
  }

  Future<String> resize() async {
    String returnValue = '';
    try {
      if (picFile != null) {
        File resizedPic = await getRezisedPicByFile(picFile).then((value) {
          return value;
        });
      } else {
        returnValue = 'No picture available! Please select a picture first';
      }
    } catch (e) {
      returnValue = e.toString();
    }

    return returnValue;
  }

  Future<File> saveResizedPicToJpgByFile(
      {IMG.Image picFile, String name, String extension}) async {
    Directory appDocDir = await Paths.getExternalStorageDirectory();
    File file =
        new File(join('${appDocDir.path}/Pictures/', '$name$extension'));
    try {
      file.writeAsBytesSync(IMG.encodeJpg(picFile));
      return file;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<File> saveResizedPicToJpgByPath(
      {IMG.Image picFile, String name, String extension}) async {
    Directory appDocDir = await Paths.getExternalStorageDirectory();
    File file =
        new File(join('${appDocDir.path}/Pictures/', '$name$extension'));
    try {
      file.writeAsBytesSync(IMG.encodeJpg(picFile));
      return file;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<File> getRezisedPicByFile(
    File pic,
  ) async {
    final IMG.Image newJpg = await compute(resizedPicByFile, pic);
    Directory appDocDir = await Paths.getExternalStorageDirectory();
    File file = new File(join('${appDocDir.path}/Pictures/',
        '${getSavableDateString(DateTime.now())}.jpg'));
    file.writeAsBytesSync(IMG.encodeJpg(newJpg));
    this.resizedPicFile = file;
    return file;
  }

  Future<IMG.Image> getRezisedPicByImage(IMG.Image pic) async {
    final IMG.Image newJpg = await compute(resizedPicImage, pic);
    return newJpg;
  }

  static IMG.Image resizedPicImage(IMG.Image pic) {
    final IMG.Image resized = IMG.copyResize(pic,
        height: 700, interpolation: IMG.Interpolation.linear);
    return resized;
  }

  static IMG.Image resizedPicByFile(File pic) {
    final IMG.Image image = IMG.decodeImage(pic.readAsBytesSync());
    final IMG.Image resized = IMG.copyResize(image,
        height: 700, interpolation: IMG.Interpolation.linear);
    return resized;
  }

  String generateFileName() {
    String timeStamp = getSavableDateString(DateTime.now());
    String owner = getOwner();
    return '$owner$timeStamp';
  }

  String getOwner() {
    return 'Owner';
  }

  Future<String> doUpload({
    String reference,
  }) async {
    String returnString = '';
    try {
      if (this.picFile == null) {
        //selected?
        String returnString = 'Please select a picture first!';
        return returnString;
      } else {
        //resize
        File file =
            await getRezisedPicByFile(this.picFile).then((File value) async {
          //create name
          String filename = generateFileName();
          //create path
          String path = '$reference/$filename.jpg';
          final StorageReference storageReference =
              FirebaseStorage().ref().child(path);
          returnString =
              await uploadImg(file: value, reference: storageReference)
                  .then((answer) {
            this.dbReference = path;
            //Update DB Here
            return answer;
          });
          return value;
        });
        return returnString;
      }
    } catch (e) {
      return returnString;
    }
  }

  Future<String> uploadImg({File file, StorageReference reference}) async {
    try {
      final StorageUploadTask uploadTask = reference.putFile(file);

      await uploadTask.onComplete.then((value) {
        if (uploadTask.isComplete != true) {
          throw new Exception(', please check your connection');
        }
      }).timeout(Duration(seconds: 7));
      return '';
    } catch (e) {
      return 'Upload Failed ${e.toString()}';
    }
  }

  Future<String> doDownloadFile({String path}) async {
    String shortPath;
    try {
      if (path == null) {
        shortPath = this.dbReference;
      } else {
        shortPath = path;
      }
      await download(shortPath: shortPath).timeout(Duration(seconds: 7));
      return '';
    } catch (e) {
      return 'Download Failed ${e.toString()}';
    }
  }

  Future<void> download({String shortPath}) async {
    StorageReference storageRef = FirebaseStorage().ref().child(shortPath);
    Directory appDocDir = await Paths.getExternalStorageDirectory();
    File tempFile = File(join('${appDocDir.path}', shortPath));
    final StorageFileDownloadTask downloadTask =
        storageRef.writeToFile(tempFile);
    await downloadTask.future.then((FileDownloadTaskSnapshot snap) {});
  }
}

enum PictureBlocUIState {
  NotDet,
  Waiting,
  Fail,
  Fin,
}

abstract class PictureBlocEvent {}

class AddEvent extends PictureBlocEvent {}

class PictureSelectEvent extends PictureBlocEvent {
  File pictureFile;
  PictureSelectEvent({@required this.pictureFile});
}

class PictureSelectWithUploadEvent extends PictureBlocEvent {
  File pictureFile;
  PictureSelectWithUploadEvent({@required this.pictureFile});
}

class PictureResizeEvent extends PictureBlocEvent {}

class PictureUploadEvent extends PictureBlocEvent {}

class PictureDownLoadEvent extends PictureBlocEvent {
  String path;
  PictureDownLoadEvent({@required this.path});
}
