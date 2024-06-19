// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transport_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TransportStore on _TransportStore, Store {
  late final _$_currentPeopleAtom =
      Atom(name: '_TransportStore._currentPeople', context: context);

  @override
  String get _currentPeople {
    _$_currentPeopleAtom.reportRead();
    return super._currentPeople;
  }

  @override
  set _currentPeople(String value) {
    _$_currentPeopleAtom.reportWrite(value, super._currentPeople, () {
      super._currentPeople = value;
    });
  }

  late final _$carInfoAtom =
      Atom(name: '_TransportStore.carInfo', context: context);

  @override
  InformarionAboutPeople? get carInfo {
    _$carInfoAtom.reportRead();
    return super.carInfo;
  }

  @override
  set carInfo(InformarionAboutPeople? value) {
    _$carInfoAtom.reportWrite(value, super.carInfo, () {
      super.carInfo = value;
    });
  }

  late final _$driverInfoAtom =
      Atom(name: '_TransportStore.driverInfo', context: context);

  @override
  InformarionAboutPeople? get driverInfo {
    _$driverInfoAtom.reportRead();
    return super.driverInfo;
  }

  @override
  set driverInfo(InformarionAboutPeople? value) {
    _$driverInfoAtom.reportWrite(value, super.driverInfo, () {
      super.driverInfo = value;
    });
  }

  late final _$peopleInfoAtom =
      Atom(name: '_TransportStore.peopleInfo', context: context);

  @override
  ObservableList<InformarionAboutPeople?> get peopleInfo {
    _$peopleInfoAtom.reportRead();
    return super.peopleInfo;
  }

  @override
  set peopleInfo(ObservableList<InformarionAboutPeople?> value) {
    _$peopleInfoAtom.reportWrite(value, super.peopleInfo, () {
      super.peopleInfo = value;
    });
  }

  late final _$_TransportStoreActionController =
      ActionController(name: '_TransportStore', context: context);

  @override
  dynamic deleteDriver() {
    final _$actionInfo = _$_TransportStoreActionController.startAction(
        name: '_TransportStore.deleteDriver');
    try {
      return super.deleteDriver();
    } finally {
      _$_TransportStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic addPeople() {
    final _$actionInfo = _$_TransportStoreActionController.startAction(
        name: '_TransportStore.addPeople');
    try {
      return super.addPeople();
    } finally {
      _$_TransportStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic updatePeople(InformarionAboutPeople fullInfo) {
    final _$actionInfo = _$_TransportStoreActionController.startAction(
        name: '_TransportStore.updatePeople');
    try {
      return super.updatePeople(fullInfo);
    } finally {
      _$_TransportStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
carInfo: ${carInfo},
driverInfo: ${driverInfo},
peopleInfo: ${peopleInfo}
    ''';
  }
}
