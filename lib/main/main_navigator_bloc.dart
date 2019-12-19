import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_green_app/pages/add_device/device_done/bloc/device_done_bloc.dart';
import 'package:super_green_app/pages/add_device/device_done/ui/device_done_page.dart';
import 'package:super_green_app/pages/add_device/device_name/bloc/device_name_bloc.dart';
import 'package:super_green_app/pages/add_device/device_name/ui/device_name_page.dart';
import 'package:super_green_app/pages/add_device/device_setup/bloc/device_setup_bloc.dart';
import 'package:super_green_app/pages/add_device/device_setup/ui/device_setup_page.dart';
import 'package:super_green_app/pages/add_device/existing_device/bloc/existing_device_bloc.dart';
import 'package:super_green_app/pages/add_device/existing_device/ui/existing_device_page.dart';
import 'package:super_green_app/pages/add_device/new_device/bloc/new_device_bloc.dart';
import 'package:super_green_app/pages/add_device/new_device/ui/new_device_page.dart';
import 'package:super_green_app/pages/home/home_page/bloc/home_bloc.dart';
import 'package:super_green_app/pages/home/home_page/ui/home_page.dart';
import 'package:super_green_app/storage/models/devices.dart';

abstract class MainNavigatorEvent extends Equatable {}

class MainNavigateToHomeEvent extends MainNavigatorEvent {
  @override
  List<Object> get props => [];
}

class MainNavigateToNewDeviceEvent extends MainNavigatorEvent {
  @override
  List<Object> get props => [];
}

class MainNavigateToExistingDeviceEvent extends MainNavigatorEvent {
  @override
  List<Object> get props => [];
}

class MainNavigateToDeviceSetupEvent extends MainNavigatorEvent {
  final ip;
  MainNavigateToDeviceSetupEvent(this.ip);

  @override
  List<Object> get props => [];
}

class MainNavigateToDeviceNameEvent extends MainNavigatorEvent {
  final Device device;
  MainNavigateToDeviceNameEvent(this.device);

  @override
  List<Object> get props => [];
}

class MainNavigateToDeviceDoneEvent extends MainNavigatorEvent {
  final Device device;
  MainNavigateToDeviceDoneEvent(this.device);

  @override
  List<Object> get props => [];
}

class MainNavigatorActionPop extends MainNavigatorEvent {
  @override
  List<Object> get props => [];
}

class MainNavigatorBloc extends Bloc<MainNavigatorEvent, dynamic> {
  final GlobalKey<NavigatorState> navigatorKey;
  MainNavigatorBloc({this.navigatorKey});

  @override
  dynamic get initialState => 0;

  @override
  Stream<dynamic> mapEventToState(MainNavigatorEvent event) async* {
    if (event is MainNavigatorActionPop) {
      navigatorKey.currentState.pop();
    } else if (event is MainNavigateToHomeEvent) {
      navigatorKey.currentState.pushReplacement(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => MainBloc(),
                child: HomePage(),
              )));
    } else if (event is MainNavigateToNewDeviceEvent) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => NewDeviceBloc(),
                child: NewDevicePage(),
              )));
    } else if (event is MainNavigateToExistingDeviceEvent) {
      navigatorKey.currentState.push(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => ExistingDeviceBloc(),
                child: ExistingDevicePage(),
              )));
    } else if (event is MainNavigateToDeviceSetupEvent) {
      navigatorKey.currentState.pushReplacement(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => DeviceSetupBloc(event.ip),
                child: DeviceSetupPage(),
              )));
    } else if (event is MainNavigateToDeviceNameEvent) {
      navigatorKey.currentState.pushReplacement(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => DeviceNameBloc(event.device),
                child: DeviceNamePage(),
              )));
    } else if (event is MainNavigateToDeviceDoneEvent) {
      navigatorKey.currentState.pushReplacement(MaterialPageRoute(
          builder: (context) => BlocProvider(
                create: (context) => DeviceDoneBloc(event.device),
                child: DeviceDonePage(),
              )));
    }
  }
}