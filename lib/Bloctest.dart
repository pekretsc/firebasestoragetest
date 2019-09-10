import 'dart:async';
import 'package:rxdart/rxdart.dart';

class Bloc {
  BlocState blocState = BlocState();

  final _StateController = BehaviorSubject<BlocState>();
  StreamSink<BlocState> get _inBlockResource => _StateController.sink;

  Stream<BlocState> get BlocResource => _StateController.stream;

  final _EventController = StreamController<BlocEvent>();
  Sink<BlocEvent> get BlocEventSinc => _EventController.sink;

  Bloc() {
    _inBlockResource.add(blocState);
    _StateController.listen(showStateChages);
    // Whenever there is a new event, we want to map it to a new state
    _EventController.stream.listen(_mapEventToState);
  }
  void showStateChages(BlocState state) {
    print('Change happened: ${state.state}');
  }

  void refresh(UIState state) async {
    blocState.state = state;
    _inBlockResource.add(blocState);
  }

  void _mapEventToState(BlocEvent event) async {
    if (event is BlocEvent) {
      refresh(UIState.Waiting);
      await blocwait().then((_) {
        print('blocWait');
      });
      wait().then((value) {
        print('$value of you');
        refresh(UIState.Fin);
      });
    }
  }

  void dispose() {
    _StateController.close();
    _EventController.close();
  }

  Future<void> blocwait() async {
    blocState.doSomeThingFunktion(eventData: 'hallo');
  }

  Future<String> wait() async {
    String result = doSomeThingFunktion(eventData: 'Hallo Funktion');
    print(result);
    await doSomeThing(eventData: 'Hallo').then((value) {
      print('$value did something');
    });
    await Future.delayed(Duration(seconds: 3)).then((_) {
      print('waited long enough');
    });
    return 'waited long enough';
  }

  String doSomeThingFunktion({String eventData}) {
    String returnValue = null;
    try {
      for (int i = 1000; i < 300000; i++) {
        returnValue = i.toString();
      }
    } catch (e) {
      returnValue = e.toString();
    }
    return returnValue;
  }

  Future<String> doSomeThing({String eventData}) async {
    String returnValue = null;
    try {
      for (int i = 0; i < 200000; i++) {
        returnValue = i.toString();
      }
    } catch (e) {
      returnValue = e.toString();
    }
    return returnValue;
  }
}

class BlocState {
  UIState state = UIState.NotDet;

  int stateData = 0;

  Future<String> wait() async {
    String result = doSomeThingFunktion(eventData: 'Hallo Funktion');
    print(result);
    await doSomeThing(eventData: 'Hallo').then((value) {
      print('$value did something');
    });
    await Future.delayed(Duration(seconds: 3)).then((_) {
      print('waited long enough');
    });
    return 'waited long enough';
  }

  String doSomeThingFunktion({String eventData}) {
    String returnValue = null;
    try {
      for (int i = 1000; i < 300000; i++) {
        returnValue = i.toString();
      }
    } catch (e) {
      returnValue = e.toString();
    }
    return returnValue;
  }

  Future<String> doSomeThing({String eventData}) async {
    String returnValue = null;
    try {
      for (int i = 0; i < 200000; i++) {
        returnValue = i.toString();
      }
    } catch (e) {
      returnValue = e.toString();
    }
    return returnValue;
  }
}

enum UIState { Waiting, Fin, Fail, NotDet }

abstract class BlocEvent {}

class SomeEvent extends BlocEvent {}
