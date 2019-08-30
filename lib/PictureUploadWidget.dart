import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class PictureUpload extends StatefulWidget {
  BorderRadius radius;
  double heigt;
  double width;
  Widget defaultImage;
  Function onTab;
  Function onLongPress;
  Function onDoubleTab;
  Decoration decoration;
  PictureUpload({@required this.radius,@required this.defaultImage,@required this.onTab,this.onLongPress,this.onDoubleTab,this.width,this.heigt,this.decoration});
  @override
  PictureUploadState createState() {
    return PictureUploadState();
  }
}
class PictureUploadState extends State<PictureUpload> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ClipRRect(
          borderRadius: widget.radius,
          child: Container(


            height: widget.heigt,
            width: widget.width,
            child: Stack(
              fit: StackFit.expand,
              children: <Widget>[

                widget.defaultImage,
                Material(
                  color: Colors.transparent,
                  child: InkWell(

                    child: Container(
                      decoration:  widget.decoration,
                      height: widget.heigt,
                      width: widget.width,
                    ),
                    onTap: widget.onTab,
                    onLongPress: widget.onLongPress,
                    onDoubleTap: widget.onDoubleTab,
                  ),
                ),

              ],
            ),
          ),
        )
      ],
    );
  }
}

