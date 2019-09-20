import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart' as IMG;
import 'package:firebasestoragetest/PictureBloc.dart';
import 'package:firebasestoragetest/PictureUploadWidget.dart';

class PicturePage extends StatefulWidget {
  PictureBloc pictureBloc = PictureBloc(fireStoreReferenceFolder: 'Pictures');
  @override
  _PicturePageState createState() => _PicturePageState();
}

class _PicturePageState extends State<PicturePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback(callSnackbar(widget.pictureBloc.displayMessage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'PictureViewer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 40,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      body: StreamBuilder(
        stream: widget.pictureBloc.StateStream,
        initialData: widget.pictureBloc.blocState,
        builder: (context, AsyncSnapshot<PictureBlocState> snap) {
          print('redraw');
          Widget defaultImage = Center(
            child: Icon(
              Icons.cloud_upload,
              color: Colors.white,
            ),
          );

          Widget download = Center(
            child: Icon(
              Icons.cloud_download,
              color: Colors.white,
            ),
          );

          Widget rezised = Center(
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
          );

          Widget upload = Center(
            child: Icon(
              Icons.image,
              color: Colors.white,
            ),
          );

          switch (snap.data.state) {
            case PictureBlocUIState.NotDet:
              {
                // statements;
                download = defaultImage;
                upload = defaultImage;
                rezised = defaultImage;
              }
              break;

            case PictureBlocUIState.Waiting:
              {
                //statements;
                download = Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
                upload = Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
                rezised = Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
                download = Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
              }
              break;
            case PictureBlocUIState.Fail:
              {
                download = Center(
                  child: Icon(Icons.error, color: Colors.white),
                );
                upload = Center(
                  child: Icon(Icons.error, color: Colors.white),
                );
                rezised = Center(
                  child: Icon(Icons.error, color: Colors.white),
                );
              }
              break;
            case PictureBlocUIState.Fin:
              {
                if (snap.data.picFile != null) {
                  defaultImage = Image.file(snap.data.picFile);
                }
                if (snap.data.resizedPicFile != null) {
                  upload = Icon(
                    Icons.thumb_up,
                    color: Colors.white,
                  );
                }
                if (snap.data.downloadedPicFile != null) {
                  download = Image.file(snap.data.downloadedPicFile);
                }
              }
              break;
            /*default: {
            //statements;
          }
          break;*/
          }

          return Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  children: <Widget>[
                    Text(
                      snap.data.state.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      widget.pictureBloc.displayMessage,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    PictureUpload(
                        radius: BorderRadius.all(Radius.circular(15)),
                        width: double.infinity,
                        heigt: 200,
                        defaultImage: defaultImage,
                        onTab: () async {
                          File picture = await IMG.ImagePicker.pickImage(
                              source: IMG.ImageSource.gallery);
                          widget.pictureBloc.EventSink.add(
                              PictureSelectWithUploadEvent(
                                  pictureFile: picture));
                        },
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 5),
                        )),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          widget.pictureBloc.EventSink
                              .add(PictureResizeEvent());
                        },
                        child: Text('Resize Image'),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          widget.pictureBloc.EventSink
                              .add(PictureUploadEvent());
                        },
                        child: Text('Upload Image'),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          widget.pictureBloc.EventSink.add(PictureDownLoadEvent(
                              path: snap.data.dbReference));
                        },
                        child: Text('Download Image'),
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: rezised,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: upload,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(seconds: 1),
                      child: download,
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  callSnackbar(String displayMessage) {
    final snackBar = SnackBar(content: Text('Yay! A SnackBar!'));

// Find the Scaffold in the widget tree and use it to show a SnackBar.
    Scaffold.of(context).showSnackBar(snackBar);
  }
}
