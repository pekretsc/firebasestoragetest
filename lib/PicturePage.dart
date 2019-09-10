import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart' as IMG;
import 'package:firebasestoragetest/PictureBloc.dart';
import 'package:firebasestoragetest/PictureUploadWidget.dart';

class PicturePage extends StatefulWidget {
  PictureBloc pictureBloc = PictureBloc();
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
        stream: widget.pictureBloc.StateController,
        initialData: widget.pictureBloc.pictureBlocState,
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
            case BlocUIState.NotDet:
              {
                // statements;
                download = defaultImage;
                upload = defaultImage;
                rezised = defaultImage;
              }
              break;

            case BlocUIState.Waiting:
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
            case BlocUIState.Fail:
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
            case BlocUIState.Fin:
              {
                if (snap.data.getLastFoundFile() != null) {
                  defaultImage = Image.file(snap.data.getLastFoundFile());
                }

                if (snap.data.getLastResizeFile() != null) {
                  rezised = Image.file(snap.data.rezisedPicFiles.last);
                }
                if (snap.data.getLastResizeFile() != null) {
                  upload = Image.file(snap.data.getLastResizeFile());
                }
                if (snap.data.downloadedPicFiles.isNotEmpty) {
                  download = Image.file(snap.data.downloadedPicFiles.last);
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
                    PictureUpload(
                        radius: BorderRadius.all(Radius.circular(15)),
                        width: double.infinity,
                        heigt: 200,
                        defaultImage: defaultImage,
                        onTab: () async {
                          File picture = await IMG.ImagePicker.pickImage(
                              source: IMG.ImageSource.gallery);
                          widget.pictureBloc.BlocEventSinc
                              .add(PictureSelectEvent(pictureFile: picture));
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
                          widget.pictureBloc.BlocEventSinc.add(TestEvent2());
                        },
                        child: Text('TestButton'),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          widget.pictureBloc.BlocEventSinc.add(
                              PictureUploadEvent(
                                  picturFilesIndex:
                                      snap.data.rezisedPicFiles.length - 1));
                        },
                        child: Text('Upload Image'),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          widget.pictureBloc.BlocEventSinc.add(
                              PictureResizeEvent(
                                  picturFilesIndex:
                                      snap.data.picFiles.length - 1));
                        },
                        child: Text('Resize Image'),
                      ),
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          widget.pictureBloc.BlocEventSinc.add(
                              PictureDownLoadEvent(
                                  path: snap.data.downloadPaths.last));
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
