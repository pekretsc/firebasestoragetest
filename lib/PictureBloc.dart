import 'dart:async';
import 'package:rxdart/rxdart.dart';

import 'package:firebasestoragetest/Event.dart';

class Bloc {
  BlocState blocState = BlocState();

  final _StateController = BehaviorSubject<BlocState>();

  StreamSink<BlocState> get _inBlockResource => _StateController.sink;

  // For state, exposing only a stream which outputs data
  Stream<BlocState> get BlocResource => _StateController.stream;

  final _EventController = StreamController<Event>();

  // For events, exposing only a sink which is an input
  Sink<Event> get BlocEventSinc => _EventController.sink;

  Bloc() {
    _inBlockResource.add(blocState);

    // Whenever there is a new event, we want to map it to a new state
    _EventController.stream.listen(_mapEventToState);
  }

  void refresh(BlocUIState state) async {
    blocState.state = state;
    _inBlockResource.add(blocState);
  }

  void _mapEventToState(Event event) async {
    if (event is BlocEvent) {
      refresh(BlocUIState.Fin);
      String result = await blocState.doSomeThing(eventData: event.data);
      if (result = null) {
      } else {
        print(result);
      }
    }
  }

  void dispose() {
    _StateController.close();
    _EventController.close();
  }
}

class BlocState {
  BlocUIState state = BlocUIState.NotDet;

  int stateData = 0;

  Future<String> doSomeThing({String eventData}) async {
    String returnValue = null;
    try {
      stateData = 1;
    } catch (e) {
      returnValue = e.toString();
    }
    stateData = 1;
    return returnValue;
  }
}

enum BlocUIState { Waiting, Fin, Fail, NotDet }
