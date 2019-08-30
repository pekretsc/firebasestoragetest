import 'package:meta/meta.dart';

abstract class PictureEvent{}
class BlocEvent extends PictureEvent{
  String data;
  BlocEvent({@required this.data});
}