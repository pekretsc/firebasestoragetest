import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as IMG;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' ;
import 'dart:io' as IO;
import 'package:path_provider/path_provider.dart'as Paths;
import 'package:path/path.dart';

class HomePage extends StatefulWidget {
  double scrollpos = 0;
  final List<double> picChangeValues = [100, 200];
  int picIndex = 0;
  List<Widget> images = [
    Container(
      key: ValueKey(1),
      height: 175,
      width: double.infinity,
      child: Image(
        image: AssetImage('dart-1943313_640.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    Container(
      key: ValueKey(2),
      height: 175,
      width: double.infinity,
      child: Image(
        image: AssetImage('camp-4363073_640.png'),
        fit: BoxFit.cover,
      ),
    ),
    Container(
      key: ValueKey(3),
      height: 175,
      width: double.infinity,
      child: Image(
        image: AssetImage('plane-4301615_640.png'),
        fit: BoxFit.cover,
      ),
    ),
  ];

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  double maxScrollpercentage;
  ScrollController scrollController;

  @override
  void initState() {
    super.initState();

    scrollController =
        ScrollController(initialScrollOffset: 0, keepScrollOffset: true)
          ..addListener(() {
            int oldIndex = widget.picIndex;
            widget.scrollpos = scrollController.offset;
            print(scrollController.offset.toString());
            if (widget.picChangeValues.length == 0) {
              widget.picIndex = 0;
            } else {
              widget.picIndex = 0;
              widget.picChangeValues.forEach((value) {
                if (widget.scrollpos > value) {
                  widget.picIndex++;
                }
              });
              if (widget.picIndex > widget.images.length) {
                widget.picIndex = widget.images.length;
              }
              if (oldIndex != widget.picIndex) {
                setState(() {});
              }
            }
          });
    // TODO: implement initState
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      child: Column(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(seconds: 1),
            child: widget.images[widget.picIndex],
          ),
          Row(
            children: <Widget>[
              RaisedButton(
                  child: Text('AddPic'),
                  onPressed: () async{
                   IO.File picFile = await ImagePicker.pickImage(source: ImageSource.gallery).then((value){
                     print(value.path);

                     return value;
                   });
                   IMG.Image image = IMG.decodeImage(picFile.readAsBytesSync());
                   IMG.Image resized =IMG.copyResize(image,height:700,interpolation: IMG.Interpolation.linear );
                   IO.File file = await saveResizedPicToJpg(picFile:resized,name: 'testPic',extension: '.jpg');



                   widget.images.add(Container(
                       key: ValueKey(ValueKey(widget.images.length+2)),
                       height: 175,
                       width: double.infinity,
                       child: Image.file(file,fit: BoxFit.cover,)
                   ),);
                   widget.picChangeValues.add(300);


                  }),
              RaisedButton(child: Text('save to internal'), onPressed: () {}),
              RaisedButton(child: Text('Upload'), onPressed: () {}),
            ],
          ),
          Expanded(
              child: Container(
                  width: double.infinity,
                  child: Material(
                      child: ListView(
                    controller: scrollController,
                    children: <Widget>[
                      Text(
                          'Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo Hallo ')
                    ],
                  )))),
        ],
      ),
    );
  }
  Future<IO.File> saveResizedPicToJpg({IMG.Image picFile, String name,String extension})async{
    Directory appDocDir = await Paths.getExternalStorageDirectory();
    File file = new File(
        join('${appDocDir.path}/Pictures/','$name$extension')
    );
    try{
      file.writeAsBytesSync(IMG.encodeJpg(picFile));
      return file;
    }catch(e)
    {
      print(e.toString());
      return null;
    }
  }
  

  Future<IO.File> saveFileToJpg({IO.File picFile, String name,String extention})async{
    Directory appDocDir = await Paths.getExternalStorageDirectory();
    File file = new File(
        join('${appDocDir.path}/Pictures/',name,extention)
    );
    try{
      file.writeAsBytesSync(picFile.readAsBytesSync());
      return file;
    }catch(e)
    {
      print(e.toString());
      return null;
    }
  }
}
