import 'dart:math';
import 'package:firebasestoragetest/Bloctest.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart' as IMG;
import 'package:firebasestoragetest/PictureUploadWidget.dart';

class PicturePage2 extends StatefulWidget {
  final Bloc pictureBloc = Bloc();

  @override
  State<StatefulWidget> createState() {
    return _PicturePage2State();
  }
}

class _PicturePage2State extends State<PicturePage2> {
  @override
  void initState() {
    widget.pictureBloc.BlocResource.listen(listening);
    // TODO: implement initState
    super.initState();
  }

  void listening(BlocState pictureBlocState) {
    print('I Am Listening');
    print(pictureBlocState.state.toString());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      initialData: widget.pictureBloc.blocState,
      stream: widget.pictureBloc.BlocResource,

      // ignore: missing_return
      builder: (context, AsyncSnapshot<BlocState> snap) {
        print('${snap.data.state} redraw');
        switch (snap.data.state) {
          case UIState.NotDet:
            return Column(
              children: <Widget>[
                Container(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow),
                    strokeWidth: 5,
                  ),
                ),
                RaisedButton(
                  child: Text(snap.data.stateData.toString()),
                  onPressed: () {
                    widget.pictureBloc.BlocEventSink.add(SomeEvent());
                  },
                )
              ],
            );
            break;
          case UIState.Waiting:
            return Column(
              children: <Widget>[
                Container(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.deepPurple),
                  ),
                ),
                RaisedButton(
                  child: Text(snap.data.stateData.toString()),
                  onPressed: () {
                    widget.pictureBloc.BlocEventSink.add(SomeEvent());
                  },
                )
              ],
            );
          case UIState.Fail:
            return Column(
              children: <Widget>[
                Center(
                  child: Container(
                    child: Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text(snap.data.stateData.toString()),
                  onPressed: () {
                    widget.pictureBloc.BlocEventSink.add(SomeEvent());
                  },
                )
              ],
            );
            break;
          case UIState.Fin:
            return Column(
              children: <Widget>[
                Center(
                  child: Container(
                    child: Icon(
                      Icons.fingerprint,
                      color: Colors.green,
                    ),
                  ),
                ),
                RaisedButton(
                  child: Text(snap.data.stateData.toString()),
                  onPressed: () async {
                    widget.pictureBloc.BlocEventSink.add(SomeEvent());
                  },
                )
              ],
            );
            break;
        }
      },
    );
  }
}
