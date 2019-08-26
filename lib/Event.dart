import 'package:meta/meta.dart';

abstract class Event{}
class BlocEvent extends Event{
  String data;
  BlocEvent({@required this.data});
}