import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:super_green_app/apis/device/kv_device.dart';
import 'package:super_green_app/storage/models/devices.dart';

abstract class DeviceNameBlocEvent extends Equatable {}

class DeviceNameBlocEventSetName extends DeviceNameBlocEvent {
  final String name;
  DeviceNameBlocEventSetName(this.name);

  @override
  List<Object> get props => [];
}

class DeviceNameBlocEventReset extends DeviceNameBlocEvent {
  @override
  List<Object> get props => [];
}

abstract class DeviceNameBlocState extends Equatable {}

class DeviceNameBlocStateIdle extends DeviceNameBlocState {
  @override
  List<Object> get props => [];
}

class DeviceNameBlocStateDone extends DeviceNameBlocState {
  final Device device;
  DeviceNameBlocStateDone(this.device);

  @override
  List<Object> get props => [];
}

class DeviceNameBloc extends Bloc<DeviceNameBlocEvent, DeviceNameBlocState> {
  Device _device;

  @override
  DeviceNameBlocState get initialState => DeviceNameBlocStateIdle();

  DeviceNameBloc(this._device);

  @override
  Stream<DeviceNameBlocState> mapEventToState(DeviceNameBlocEvent event) async* {
    if (event is DeviceNameBlocEventSetName) {
      await KVDevice.setStringParam(_device.ip, 'DEVICE_NAME', event.name);
      yield DeviceNameBlocStateDone(this._device);
    }
  }
}