import 'package:flutter/material.dart';
import 'package:firebasestoragetest/PictureBloc.dart';
import 'package:firebasestoragetest/PictureUploadWidget.dart';
class PicturePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return PictureUpload(radius: BorderRadius.all(Radius.circular(15)),
      width: double.infinity,
      heigt: 200,
      img: Image.asset('camp-4363073_640.png',fit: BoxFit.cover,),
      onHold: null ,
      onTab: null,);
  }
}
