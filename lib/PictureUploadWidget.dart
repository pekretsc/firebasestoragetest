import 'package:flutter/material.dart';
class PictureUpload extends StatefulWidget {
  BorderRadius radius;
  double heigt;
  double width;
  Image img;
  Future onTab;
  Future onHold;
  PictureUpload({@required this.radius,@required this.img,@required this.onTab,@required this.onHold,this.width,this.heigt});
  @override
  PictureUpload_State createState() => PictureUpload_State();
}

class PictureUpload_State extends State<PictureUpload> {
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

                widget.img,
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    child: Container(
                      height: widget.heigt,
                      width: widget.width,
                    ),
                    onTap: (){},
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

