import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:path/path.dart';
import 'package:image/image.dart' as IMG;
import 'package:path_provider/path_provider.dart' as Paths;

class PictureBloc {
  PictureBlocState blocState = PictureBlocState();
  String latestError = '';
  String displayMessage = '';

  final _StateController = BehaviorSubject<PictureBlocState>();

  StreamSink<PictureBlocState> get _stateSink => _StateController.sink;

  Stream<PictureBlocState> get StateStream => _StateController.stream;

  final _EventController = StreamController<PictureBlocEvent>();

  Sink<PictureBlocEvent> get EventSink => _EventController.sink;

  PictureBloc() {
    _stateSink.add(blocState);
    _EventController.stream.listen(_mapEventToState);
  }

  void refresh(PictureBlocUIState state) async {
    blocState.state = state;
    _stateSink.add(blocState);
  }

  void _mapEventToState(PictureBlocEvent event) async {
    if (event is PictureSelectEvent) {
      refresh(PictureBlocUIState.Waiting);
      await blocState.selected(picFile: event.pictureFile).then((value) {
        if (value == '') {
          refresh(PictureBlocUIState.Fin);
          displayMessage = 'Bild wurde geladen!!';
        } else {
          refresh(PictureBlocUIState.Fail);
          latestError = value;
          displayMessage = 'Es ist ein fehler aufgetreten';
        }
        return value;
      });
    }

    if (event is PictureResizeEvent) {
      refresh(PictureBlocUIState.Waiting);
      String result;
      try {
        result = await blocState.resize().then((value) {
          if (value != null) {
            return '';
          } else {
            return 'fail';
          }
        });
      } catch (e) {}

      if (result == '') {
        refresh(PictureBlocUIState.Fin);
      } else {
        refresh(PictureBlocUIState.Fail);
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
  File rezisedPicFile;
  File downloadedPicFiles;
  String downloadPaths;

  String getSavableDateString(DateTime t) {
    String date = t.toIso8601String().split('T')[0];
    String returnString =
        '${date.split('-')[2]}_${date.split('-')[1]}_${date.split('-')[0]}_${t.millisecondsSinceEpoch.toString()}';
    return returnString;
  }


  Future<String> selected({File pic}) async {
    String returnValue = '';
    try {
      if (picFile.path.contains('.jpg') || picFile.path.contains('.png')) {
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
      //Rezise Pic
      //upload Pic to net
      // return path

    if(picFile != null){
      File resizedPic = await getRezisedPicByFile(picFile);
    }else{
      returnValue = 'No pcture available! Please select a picture first';
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

  Future<File> getRezisedPicByFile(File pic,) async {
    final IMG.Image image = IMG.decodeImage(pic.readAsBytesSync());
    final IMG.Image  newJpg = await compute(rezisedPicFile,pic);
    final File returnFile = File().writeAsBytesSync(IMG.encodeJpg(newJpg));
    return returnFile;
  }
  Future<IMG.Image> getRezisedPicByImage(IMG.Image pic) async {
    final IMG.Image  newJpg = await compute(rezisedPicImage,pic);
    return newJpg;
  }
  static IMG.Image rezisedPicImage(IMG.Image pic) {
    final IMG.Image resized = IMG.copyResize(pic,
        height: 700, interpolation: IMG.Interpolation.linear);
    return resized;
  }
  static IMG.Image rezisedPicFile(File pic) {
     final IMG.Image image = IMG.decodeImage(pic.readAsBytesSync());
     final IMG.Image resized = IMG.copyResize(image,
         height: 700, interpolation: IMG.Interpolation.linear);
     return resized;
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

class PictureUploadEvent extends PictureBlocEvent {
  int picturFilesIndex;
  PictureUploadEvent({@required this.picturFilesIndex});
}

class PictureResizeEvent extends PictureBlocEvent {}

class PictureDownLoadEvent extends PictureBlocEvent {
  String path;
  PictureDownLoadEvent({@required this.path});
}