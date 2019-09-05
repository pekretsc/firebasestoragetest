import 'dart:async';
import 'dart:io';
import 'package:image/image.dart' as IMG;
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart' as Paths;
import 'package:firebase_storage/firebase_storage.dart';

import 'package:firebasestoragetest/Event.dart';

class PictureBloc {
  PictureBlocState pictureBlocState = PictureBlocState();
  String latestError = '';
  String displayMessage='';

  final _StateController = BehaviorSubject<PictureBlocState>();

  StreamSink<PictureBlocState> get _inBlockResource => _StateController.sink;

  // For state, exposing only a stream which outputs data
  Stream<PictureBlocState> get BlocResource => _StateController.stream;

  final _EventController = StreamController<PictureEvent>();

  // For events, exposing only a sink which is an input
  Sink<PictureEvent> get BlocEventSinc => _EventController.sink;

  PictureBloc() {
    _inBlockResource.add(pictureBlocState);

    // Whenever there is a new event, we want to map it to a new state
    _EventController.stream.listen(_mapEventToState);
  }

  void refresh(BlocUIState state) async {
    pictureBlocState.state = state;
    _inBlockResource.add(pictureBlocState);
  }

  void _mapEventToState(PictureEvent event) async {
    if (event is PictureSelectEvent) {
      refresh(BlocUIState.Waiting);
      String result = await pictureBlocState.selected(picFile: event.pictureFile);
      if (result == '') {
        refresh(BlocUIState.Fin);
        displayMessage = 'Bild wurde geladen!!';
      } else {
        refresh(BlocUIState.Fail);
        latestError = result;
        displayMessage = 'Es ist ein fehler aufgetreten';
      }
    }

    if (event is PictureUploadEvent) {
      refresh(BlocUIState.Waiting);
      String result = await pictureBlocState.upLoad(index: event.picturFilesIndex);
      if (result == '') {
        refresh(BlocUIState.Fin);
        displayMessage = 'Bild wurde geladen!!';
      } else {
        refresh(BlocUIState.Fail);
        latestError = result;
        displayMessage = 'Es ist ein fehler aufgetreten';
      }
    }

    if (event is PictureResizeEvent) {
      refresh(BlocUIState.Waiting);
      String result = await pictureBlocState.resize(index: event.picturFilesIndex);
      if (result == '') {
        refresh(BlocUIState.Fin);
        displayMessage = 'Bild wurde geladen!!';
      } else {
        refresh(BlocUIState.Fail);
        latestError = result;
        displayMessage = 'Es ist ein fehler aufgetreten';
      }
    }

    if (event is PictureDownLoadEvent) {
      refresh(BlocUIState.Waiting);
      String result = await pictureBlocState.download(path: event.path);
      if (result == '') {
        refresh(BlocUIState.Fin);
        displayMessage = 'Bild wurde geladen!!';
      } else {
        refresh(BlocUIState.Fail);
        latestError = result;
        displayMessage = 'Es ist ein fehler aufgetreten';
      }
    }
  }

  void dispose() {
    _StateController.close();
    _EventController.close();
  }
}

class PictureBlocState {
  BlocUIState state = BlocUIState.NotDet;
  List<File> picFiles = [];
  List<File> rezisedPicFiles = [];
  List<File> downloadedPicFiles = [];
  List<String> downloadPaths = [];
 /*
 Future<String> doSomeThing({String eventData}) async {
    String returnValue = null;
    try {
      stateData = 1;
    } catch (e) {
      returnValue = e.toString();
    }
    stateData = 1;
    return returnValue;
  }*/

  Future<String> selected({File picFile}) async {
    String returnValue = '';
    try {
      if(picFile.path.contains('.jpg')||picFile.path.contains('.png')){
        picFiles.add(picFile);
      }
    }
    catch (e)
    {
      picFiles.add(null);
      returnValue = e.toString();
    }
    return returnValue;
  }

  Future<String> upLoad({int index}) async {
    String returnValue = '';
    try {
      String storagePath =await uploadImg(file: rezisedPicFiles[index],extention: '.jpg',filename: getSavableDateString(DateTime.now()),reference: 'Pictures');
      downloadPaths.add(storagePath);
    } catch (e) {
      returnValue = e.toString();
    }

    return returnValue;
  }

  Future<String> resize({int index}) async {
    String returnValue = '';
    try {

   IMG.Image image =
      IMG.decodeImage(picFiles[index].readAsBytesSync());
      IMG.Image resized = IMG.copyResize(image,
          height: 700, interpolation: IMG.Interpolation.linear);
      File resizedPic = await saveResizedPicToJpg(picFile: resized,name: getSavableDateString(DateTime.now()),extension: '.jpg');
      rezisedPicFiles.add(resizedPic);
    } catch (e) {
      returnValue = e.toString();
    }

    return returnValue;
  }

  Future<String> download({String path}) async {
    String returnValue = '';
    try {
      File downloadedPic = await downloadFile(path: path);
      downloadedPicFiles.add(downloadedPic);
    } catch (e) {
      returnValue = e.toString();
    }

    return returnValue;
  }

  Future<File> saveResizedPicToJpg(
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
  String getSavableDateString(DateTime t) {
    String date = t.toIso8601String().split('T')[0];
    String returnString =
        '${date.split('-')[2]}_${date.split('-')[1]}_${date.split('-')[0]}_${t.millisecondsSinceEpoch.toString()}';
    return returnString;
  }

  Future<String> uploadImg(
      {File file, String reference, String filename, String extention}) async {
    final StorageReference storageReference =
    FirebaseStorage().ref().child('$reference/$filename$extention');

    final StorageUploadTask uploadTask = storageReference.putFile(file);
    print(storageReference.path);
    return storageReference.path;
  }

  Future<File> downloadFile({String path}) async {
    String shortPath = path;
    StorageReference storageRef = FirebaseStorage().ref().child(shortPath);
    Directory appDocDir = await Paths.getExternalStorageDirectory();
    File tempImg = File(join('${appDocDir.path}', shortPath));

    storageRef.writeToFile(tempImg);
    return tempImg;
  }
}

enum BlocUIState { Waiting, Fin, Fail, NotDet }
abstract class PictureEvent{}

class PictureSelectEvent extends PictureEvent{
  File pictureFile;
  PictureSelectEvent({@required this.pictureFile});
}

class PictureUploadEvent extends PictureEvent{
  int picturFilesIndex;
  PictureUploadEvent({@required this.picturFilesIndex});
}

class PictureResizeEvent extends PictureEvent{
  int picturFilesIndex;
  PictureResizeEvent({@required this.picturFilesIndex});
}

class PictureDownLoadEvent extends PictureEvent{
  String path;
  PictureDownLoadEvent({@required this.path});
}
