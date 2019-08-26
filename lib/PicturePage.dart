import 'package:flutter/material.dart';
import 'package:firebasestoragetest/PictureBloc.dart';
class PicturePage extends StatelessWidget {
  Bloc bloc = Bloc();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      builder: (context, AsyncSnapshot<BlocState> snap){
        return Container();
      },
    );
  }
}
