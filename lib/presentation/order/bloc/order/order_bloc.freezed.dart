// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_bloc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$OrderEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderEventCopyWith<$Res> {
  factory $OrderEventCopyWith(
          OrderEvent value, $Res Function(OrderEvent) then) =
      _$OrderEventCopyWithImpl<$Res, OrderEvent>;
}

/// @nodoc
class _$OrderEventCopyWithImpl<$Res, $Val extends OrderEvent>
    implements $OrderEventCopyWith<$Res> {
  _$OrderEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StartedImplCopyWith<$Res> {
  factory _$$StartedImplCopyWith(
          _$StartedImpl value, $Res Function(_$StartedImpl) then) =
      __$$StartedImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StartedImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$StartedImpl>
    implements _$$StartedImplCopyWith<$Res> {
  __$$StartedImplCopyWithImpl(
      _$StartedImpl _value, $Res Function(_$StartedImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StartedImpl with DiagnosticableTreeMixin implements _Started {
  const _$StartedImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderEvent.started()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'OrderEvent.started'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StartedImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) {
    return started();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) {
    return started?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) {
    return started(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) {
    return started?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (started != null) {
      return started(this);
    }
    return orElse();
  }
}

abstract class _Started implements OrderEvent {
  const factory _Started() = _$StartedImpl;
}

/// @nodoc
abstract class _$$AddPaymentMethodImplCopyWith<$Res> {
  factory _$$AddPaymentMethodImplCopyWith(_$AddPaymentMethodImpl value,
          $Res Function(_$AddPaymentMethodImpl) then) =
      __$$AddPaymentMethodImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {String paymentMethod, List<OrderItem> orders, String customerName});
}

/// @nodoc
class __$$AddPaymentMethodImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$AddPaymentMethodImpl>
    implements _$$AddPaymentMethodImplCopyWith<$Res> {
  __$$AddPaymentMethodImplCopyWithImpl(_$AddPaymentMethodImpl _value,
      $Res Function(_$AddPaymentMethodImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? paymentMethod = null,
    Object? orders = null,
    Object? customerName = null,
  }) {
    return _then(_$AddPaymentMethodImpl(
      null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      null == orders
          ? _value._orders
          : orders // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AddPaymentMethodImpl
    with DiagnosticableTreeMixin
    implements _AddPaymentMethod {
  const _$AddPaymentMethodImpl(
      this.paymentMethod, final List<OrderItem> orders, this.customerName)
      : _orders = orders;

  @override
  final String paymentMethod;
  final List<OrderItem> _orders;
  @override
  List<OrderItem> get orders {
    if (_orders is EqualUnmodifiableListView) return _orders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_orders);
  }

  @override
  final String customerName;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderEvent.addPaymentMethod(paymentMethod: $paymentMethod, orders: $orders, customerName: $customerName)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderEvent.addPaymentMethod'))
      ..add(DiagnosticsProperty('paymentMethod', paymentMethod))
      ..add(DiagnosticsProperty('orders', orders))
      ..add(DiagnosticsProperty('customerName', customerName));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddPaymentMethodImpl &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            const DeepCollectionEquality().equals(other._orders, _orders) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, paymentMethod,
      const DeepCollectionEquality().hash(_orders), customerName);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddPaymentMethodImplCopyWith<_$AddPaymentMethodImpl> get copyWith =>
      __$$AddPaymentMethodImplCopyWithImpl<_$AddPaymentMethodImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) {
    return addPaymentMethod(paymentMethod, orders, customerName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) {
    return addPaymentMethod?.call(paymentMethod, orders, customerName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (addPaymentMethod != null) {
      return addPaymentMethod(paymentMethod, orders, customerName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) {
    return addPaymentMethod(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) {
    return addPaymentMethod?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (addPaymentMethod != null) {
      return addPaymentMethod(this);
    }
    return orElse();
  }
}

abstract class _AddPaymentMethod implements OrderEvent {
  const factory _AddPaymentMethod(
      final String paymentMethod,
      final List<OrderItem> orders,
      final String customerName) = _$AddPaymentMethodImpl;

  String get paymentMethod;
  List<OrderItem> get orders;
  String get customerName;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddPaymentMethodImplCopyWith<_$AddPaymentMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AddNominalBayarImplCopyWith<$Res> {
  factory _$$AddNominalBayarImplCopyWith(_$AddNominalBayarImpl value,
          $Res Function(_$AddNominalBayarImpl) then) =
      __$$AddNominalBayarImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int nominal});
}

/// @nodoc
class __$$AddNominalBayarImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$AddNominalBayarImpl>
    implements _$$AddNominalBayarImplCopyWith<$Res> {
  __$$AddNominalBayarImplCopyWithImpl(
      _$AddNominalBayarImpl _value, $Res Function(_$AddNominalBayarImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? nominal = null,
  }) {
    return _then(_$AddNominalBayarImpl(
      null == nominal
          ? _value.nominal
          : nominal // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$AddNominalBayarImpl
    with DiagnosticableTreeMixin
    implements _AddNominalBayar {
  const _$AddNominalBayarImpl(this.nominal);

  @override
  final int nominal;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderEvent.addNominalBayar(nominal: $nominal)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderEvent.addNominalBayar'))
      ..add(DiagnosticsProperty('nominal', nominal));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AddNominalBayarImpl &&
            (identical(other.nominal, nominal) || other.nominal == nominal));
  }

  @override
  int get hashCode => Object.hash(runtimeType, nominal);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AddNominalBayarImplCopyWith<_$AddNominalBayarImpl> get copyWith =>
      __$$AddNominalBayarImplCopyWithImpl<_$AddNominalBayarImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) {
    return addNominalBayar(nominal);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) {
    return addNominalBayar?.call(nominal);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (addNominalBayar != null) {
      return addNominalBayar(nominal);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) {
    return addNominalBayar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) {
    return addNominalBayar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (addNominalBayar != null) {
      return addNominalBayar(this);
    }
    return orElse();
  }
}

abstract class _AddNominalBayar implements OrderEvent {
  const factory _AddNominalBayar(final int nominal) = _$AddNominalBayarImpl;

  int get nominal;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AddNominalBayarImplCopyWith<_$AddNominalBayarImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncOfflineOrdersImplCopyWith<$Res> {
  factory _$$SyncOfflineOrdersImplCopyWith(_$SyncOfflineOrdersImpl value,
          $Res Function(_$SyncOfflineOrdersImpl) then) =
      __$$SyncOfflineOrdersImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncOfflineOrdersImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$SyncOfflineOrdersImpl>
    implements _$$SyncOfflineOrdersImplCopyWith<$Res> {
  __$$SyncOfflineOrdersImplCopyWithImpl(_$SyncOfflineOrdersImpl _value,
      $Res Function(_$SyncOfflineOrdersImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncOfflineOrdersImpl
    with DiagnosticableTreeMixin
    implements _SyncOfflineOrders {
  const _$SyncOfflineOrdersImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderEvent.syncOfflineOrders()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderEvent.syncOfflineOrders'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncOfflineOrdersImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) {
    return syncOfflineOrders();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) {
    return syncOfflineOrders?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (syncOfflineOrders != null) {
      return syncOfflineOrders();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) {
    return syncOfflineOrders(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) {
    return syncOfflineOrders?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (syncOfflineOrders != null) {
      return syncOfflineOrders(this);
    }
    return orElse();
  }
}

abstract class _SyncOfflineOrders implements OrderEvent {
  const factory _SyncOfflineOrders() = _$SyncOfflineOrdersImpl;
}

/// @nodoc
abstract class _$$ApplyAutoDiscountImplCopyWith<$Res> {
  factory _$$ApplyAutoDiscountImplCopyWith(_$ApplyAutoDiscountImpl value,
          $Res Function(_$ApplyAutoDiscountImpl) then) =
      __$$ApplyAutoDiscountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<int> validDays, int percentage});
}

/// @nodoc
class __$$ApplyAutoDiscountImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$ApplyAutoDiscountImpl>
    implements _$$ApplyAutoDiscountImplCopyWith<$Res> {
  __$$ApplyAutoDiscountImplCopyWithImpl(_$ApplyAutoDiscountImpl _value,
      $Res Function(_$ApplyAutoDiscountImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? validDays = null,
    Object? percentage = null,
  }) {
    return _then(_$ApplyAutoDiscountImpl(
      null == validDays
          ? _value._validDays
          : validDays // ignore: cast_nullable_to_non_nullable
              as List<int>,
      null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ApplyAutoDiscountImpl
    with DiagnosticableTreeMixin
    implements _ApplyAutoDiscount {
  const _$ApplyAutoDiscountImpl(final List<int> validDays, this.percentage)
      : _validDays = validDays;

  final List<int> _validDays;
  @override
  List<int> get validDays {
    if (_validDays is EqualUnmodifiableListView) return _validDays;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_validDays);
  }

  @override
  final int percentage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderEvent.applyAutoDiscount(validDays: $validDays, percentage: $percentage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderEvent.applyAutoDiscount'))
      ..add(DiagnosticsProperty('validDays', validDays))
      ..add(DiagnosticsProperty('percentage', percentage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyAutoDiscountImpl &&
            const DeepCollectionEquality()
                .equals(other._validDays, _validDays) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_validDays), percentage);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyAutoDiscountImplCopyWith<_$ApplyAutoDiscountImpl> get copyWith =>
      __$$ApplyAutoDiscountImplCopyWithImpl<_$ApplyAutoDiscountImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) {
    return applyAutoDiscount(validDays, percentage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) {
    return applyAutoDiscount?.call(validDays, percentage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (applyAutoDiscount != null) {
      return applyAutoDiscount(validDays, percentage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) {
    return applyAutoDiscount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) {
    return applyAutoDiscount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (applyAutoDiscount != null) {
      return applyAutoDiscount(this);
    }
    return orElse();
  }
}

abstract class _ApplyAutoDiscount implements OrderEvent {
  const factory _ApplyAutoDiscount(
          final List<int> validDays, final int percentage) =
      _$ApplyAutoDiscountImpl;

  List<int> get validDays;
  int get percentage;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyAutoDiscountImplCopyWith<_$ApplyAutoDiscountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ApplyManualDiscountImplCopyWith<$Res> {
  factory _$$ApplyManualDiscountImplCopyWith(_$ApplyManualDiscountImpl value,
          $Res Function(_$ApplyManualDiscountImpl) then) =
      __$$ApplyManualDiscountImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int percentage});
}

/// @nodoc
class __$$ApplyManualDiscountImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$ApplyManualDiscountImpl>
    implements _$$ApplyManualDiscountImplCopyWith<$Res> {
  __$$ApplyManualDiscountImplCopyWithImpl(_$ApplyManualDiscountImpl _value,
      $Res Function(_$ApplyManualDiscountImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? percentage = null,
  }) {
    return _then(_$ApplyManualDiscountImpl(
      null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ApplyManualDiscountImpl
    with DiagnosticableTreeMixin
    implements _ApplyManualDiscount {
  const _$ApplyManualDiscountImpl(this.percentage);

  @override
  final int percentage;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderEvent.applyManualDiscount(percentage: $percentage)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderEvent.applyManualDiscount'))
      ..add(DiagnosticsProperty('percentage', percentage));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyManualDiscountImpl &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @override
  int get hashCode => Object.hash(runtimeType, percentage);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyManualDiscountImplCopyWith<_$ApplyManualDiscountImpl> get copyWith =>
      __$$ApplyManualDiscountImplCopyWithImpl<_$ApplyManualDiscountImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) {
    return applyManualDiscount(percentage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) {
    return applyManualDiscount?.call(percentage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (applyManualDiscount != null) {
      return applyManualDiscount(percentage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) {
    return applyManualDiscount(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) {
    return applyManualDiscount?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (applyManualDiscount != null) {
      return applyManualDiscount(this);
    }
    return orElse();
  }
}

abstract class _ApplyManualDiscount implements OrderEvent {
  const factory _ApplyManualDiscount(final int percentage) =
      _$ApplyManualDiscountImpl;

  int get percentage;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyManualDiscountImplCopyWith<_$ApplyManualDiscountImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ApplyTaxImplCopyWith<$Res> {
  factory _$$ApplyTaxImplCopyWith(
          _$ApplyTaxImpl value, $Res Function(_$ApplyTaxImpl) then) =
      __$$ApplyTaxImplCopyWithImpl<$Res>;
  @useResult
  $Res call({TaxResponseModel tax});
}

/// @nodoc
class __$$ApplyTaxImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$ApplyTaxImpl>
    implements _$$ApplyTaxImplCopyWith<$Res> {
  __$$ApplyTaxImplCopyWithImpl(
      _$ApplyTaxImpl _value, $Res Function(_$ApplyTaxImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tax = null,
  }) {
    return _then(_$ApplyTaxImpl(
      null == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as TaxResponseModel,
    ));
  }
}

/// @nodoc

class _$ApplyTaxImpl with DiagnosticableTreeMixin implements _ApplyTax {
  const _$ApplyTaxImpl(this.tax);

  @override
  final TaxResponseModel tax;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderEvent.applyTax(tax: $tax)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderEvent.applyTax'))
      ..add(DiagnosticsProperty('tax', tax));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyTaxImpl &&
            (identical(other.tax, tax) || other.tax == tax));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tax);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyTaxImplCopyWith<_$ApplyTaxImpl> get copyWith =>
      __$$ApplyTaxImplCopyWithImpl<_$ApplyTaxImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) {
    return applyTax(tax);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) {
    return applyTax?.call(tax);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (applyTax != null) {
      return applyTax(tax);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) {
    return applyTax(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) {
    return applyTax?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (applyTax != null) {
      return applyTax(this);
    }
    return orElse();
  }
}

abstract class _ApplyTax implements OrderEvent {
  const factory _ApplyTax(final TaxResponseModel tax) = _$ApplyTaxImpl;

  TaxResponseModel get tax;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyTaxImplCopyWith<_$ApplyTaxImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ApplyServiceChargeImplCopyWith<$Res> {
  factory _$$ApplyServiceChargeImplCopyWith(_$ApplyServiceChargeImpl value,
          $Res Function(_$ApplyServiceChargeImpl) then) =
      __$$ApplyServiceChargeImplCopyWithImpl<$Res>;
  @useResult
  $Res call({ServiceChargeResponseModel serviceCharge});
}

/// @nodoc
class __$$ApplyServiceChargeImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$ApplyServiceChargeImpl>
    implements _$$ApplyServiceChargeImplCopyWith<$Res> {
  __$$ApplyServiceChargeImplCopyWithImpl(_$ApplyServiceChargeImpl _value,
      $Res Function(_$ApplyServiceChargeImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? serviceCharge = null,
  }) {
    return _then(_$ApplyServiceChargeImpl(
      null == serviceCharge
          ? _value.serviceCharge
          : serviceCharge // ignore: cast_nullable_to_non_nullable
              as ServiceChargeResponseModel,
    ));
  }
}

/// @nodoc

class _$ApplyServiceChargeImpl
    with DiagnosticableTreeMixin
    implements _ApplyServiceCharge {
  const _$ApplyServiceChargeImpl(this.serviceCharge);

  @override
  final ServiceChargeResponseModel serviceCharge;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderEvent.applyServiceCharge(serviceCharge: $serviceCharge)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderEvent.applyServiceCharge'))
      ..add(DiagnosticsProperty('serviceCharge', serviceCharge));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplyServiceChargeImpl &&
            (identical(other.serviceCharge, serviceCharge) ||
                other.serviceCharge == serviceCharge));
  }

  @override
  int get hashCode => Object.hash(runtimeType, serviceCharge);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplyServiceChargeImplCopyWith<_$ApplyServiceChargeImpl> get copyWith =>
      __$$ApplyServiceChargeImplCopyWithImpl<_$ApplyServiceChargeImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) {
    return applyServiceCharge(serviceCharge);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) {
    return applyServiceCharge?.call(serviceCharge);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (applyServiceCharge != null) {
      return applyServiceCharge(serviceCharge);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) {
    return applyServiceCharge(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) {
    return applyServiceCharge?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (applyServiceCharge != null) {
      return applyServiceCharge(this);
    }
    return orElse();
  }
}

abstract class _ApplyServiceCharge implements OrderEvent {
  const factory _ApplyServiceCharge(
          final ServiceChargeResponseModel serviceCharge) =
      _$ApplyServiceChargeImpl;

  ServiceChargeResponseModel get serviceCharge;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ApplyServiceChargeImplCopyWith<_$ApplyServiceChargeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UpdateSyncStatusImplCopyWith<$Res> {
  factory _$$UpdateSyncStatusImplCopyWith(_$UpdateSyncStatusImpl value,
          $Res Function(_$UpdateSyncStatusImpl) then) =
      __$$UpdateSyncStatusImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int orderId, bool isSynced});
}

/// @nodoc
class __$$UpdateSyncStatusImplCopyWithImpl<$Res>
    extends _$OrderEventCopyWithImpl<$Res, _$UpdateSyncStatusImpl>
    implements _$$UpdateSyncStatusImplCopyWith<$Res> {
  __$$UpdateSyncStatusImplCopyWithImpl(_$UpdateSyncStatusImpl _value,
      $Res Function(_$UpdateSyncStatusImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? isSynced = null,
  }) {
    return _then(_$UpdateSyncStatusImpl(
      null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$UpdateSyncStatusImpl
    with DiagnosticableTreeMixin
    implements _UpdateSyncStatus {
  const _$UpdateSyncStatusImpl(this.orderId, this.isSynced);

  @override
  final int orderId;
  @override
  final bool isSynced;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderEvent.updateSyncStatus(orderId: $orderId, isSynced: $isSynced)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderEvent.updateSyncStatus'))
      ..add(DiagnosticsProperty('orderId', orderId))
      ..add(DiagnosticsProperty('isSynced', isSynced));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UpdateSyncStatusImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderId, isSynced);

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UpdateSyncStatusImplCopyWith<_$UpdateSyncStatusImpl> get copyWith =>
      __$$UpdateSyncStatusImplCopyWithImpl<_$UpdateSyncStatusImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() started,
    required TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)
        addPaymentMethod,
    required TResult Function(int nominal) addNominalBayar,
    required TResult Function() syncOfflineOrders,
    required TResult Function(List<int> validDays, int percentage)
        applyAutoDiscount,
    required TResult Function(int percentage) applyManualDiscount,
    required TResult Function(TaxResponseModel tax) applyTax,
    required TResult Function(ServiceChargeResponseModel serviceCharge)
        applyServiceCharge,
    required TResult Function(int orderId, bool isSynced) updateSyncStatus,
  }) {
    return updateSyncStatus(orderId, isSynced);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? started,
    TResult? Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult? Function(int nominal)? addNominalBayar,
    TResult? Function()? syncOfflineOrders,
    TResult? Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult? Function(int percentage)? applyManualDiscount,
    TResult? Function(TaxResponseModel tax)? applyTax,
    TResult? Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult? Function(int orderId, bool isSynced)? updateSyncStatus,
  }) {
    return updateSyncStatus?.call(orderId, isSynced);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? started,
    TResult Function(
            String paymentMethod, List<OrderItem> orders, String customerName)?
        addPaymentMethod,
    TResult Function(int nominal)? addNominalBayar,
    TResult Function()? syncOfflineOrders,
    TResult Function(List<int> validDays, int percentage)? applyAutoDiscount,
    TResult Function(int percentage)? applyManualDiscount,
    TResult Function(TaxResponseModel tax)? applyTax,
    TResult Function(ServiceChargeResponseModel serviceCharge)?
        applyServiceCharge,
    TResult Function(int orderId, bool isSynced)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (updateSyncStatus != null) {
      return updateSyncStatus(orderId, isSynced);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Started value) started,
    required TResult Function(_AddPaymentMethod value) addPaymentMethod,
    required TResult Function(_AddNominalBayar value) addNominalBayar,
    required TResult Function(_SyncOfflineOrders value) syncOfflineOrders,
    required TResult Function(_ApplyAutoDiscount value) applyAutoDiscount,
    required TResult Function(_ApplyManualDiscount value) applyManualDiscount,
    required TResult Function(_ApplyTax value) applyTax,
    required TResult Function(_ApplyServiceCharge value) applyServiceCharge,
    required TResult Function(_UpdateSyncStatus value) updateSyncStatus,
  }) {
    return updateSyncStatus(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Started value)? started,
    TResult? Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult? Function(_AddNominalBayar value)? addNominalBayar,
    TResult? Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult? Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult? Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult? Function(_ApplyTax value)? applyTax,
    TResult? Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult? Function(_UpdateSyncStatus value)? updateSyncStatus,
  }) {
    return updateSyncStatus?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Started value)? started,
    TResult Function(_AddPaymentMethod value)? addPaymentMethod,
    TResult Function(_AddNominalBayar value)? addNominalBayar,
    TResult Function(_SyncOfflineOrders value)? syncOfflineOrders,
    TResult Function(_ApplyAutoDiscount value)? applyAutoDiscount,
    TResult Function(_ApplyManualDiscount value)? applyManualDiscount,
    TResult Function(_ApplyTax value)? applyTax,
    TResult Function(_ApplyServiceCharge value)? applyServiceCharge,
    TResult Function(_UpdateSyncStatus value)? updateSyncStatus,
    required TResult orElse(),
  }) {
    if (updateSyncStatus != null) {
      return updateSyncStatus(this);
    }
    return orElse();
  }
}

abstract class _UpdateSyncStatus implements OrderEvent {
  const factory _UpdateSyncStatus(final int orderId, final bool isSynced) =
      _$UpdateSyncStatusImpl;

  int get orderId;
  bool get isSynced;

  /// Create a copy of OrderEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UpdateSyncStatusImplCopyWith<_$UpdateSyncStatusImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$OrderState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)
        success,
    required TResult Function(String message) error,
    required TResult Function() syncing,
    required TResult Function(double discountPercentage, int totalAfterDiscount)
        discountApplied,
    required TResult Function(int orderId, bool isSynced) syncStatusUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult? Function(String message)? error,
    TResult? Function()? syncing,
    TResult? Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult? Function(int orderId, bool isSynced)? syncStatusUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult Function(String message)? error,
    TResult Function()? syncing,
    TResult Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult Function(int orderId, bool isSynced)? syncStatusUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_DiscountApplied value) discountApplied,
    required TResult Function(_SyncStatusUpdated value) syncStatusUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_DiscountApplied value)? discountApplied,
    TResult? Function(_SyncStatusUpdated value)? syncStatusUpdated,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_DiscountApplied value)? discountApplied,
    TResult Function(_SyncStatusUpdated value)? syncStatusUpdated,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderStateCopyWith<$Res> {
  factory $OrderStateCopyWith(
          OrderState value, $Res Function(OrderState) then) =
      _$OrderStateCopyWithImpl<$Res, OrderState>;
}

/// @nodoc
class _$OrderStateCopyWithImpl<$Res, $Val extends OrderState>
    implements $OrderStateCopyWith<$Res> {
  _$OrderStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$InitialImplCopyWith<$Res> {
  factory _$$InitialImplCopyWith(
          _$InitialImpl value, $Res Function(_$InitialImpl) then) =
      __$$InitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$InitialImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$InitialImpl>
    implements _$$InitialImplCopyWith<$Res> {
  __$$InitialImplCopyWithImpl(
      _$InitialImpl _value, $Res Function(_$InitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$InitialImpl with DiagnosticableTreeMixin implements _Initial {
  const _$InitialImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderState.initial()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'OrderState.initial'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$InitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)
        success,
    required TResult Function(String message) error,
    required TResult Function() syncing,
    required TResult Function(double discountPercentage, int totalAfterDiscount)
        discountApplied,
    required TResult Function(int orderId, bool isSynced) syncStatusUpdated,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult? Function(String message)? error,
    TResult? Function()? syncing,
    TResult? Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult? Function(int orderId, bool isSynced)? syncStatusUpdated,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult Function(String message)? error,
    TResult Function()? syncing,
    TResult Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult Function(int orderId, bool isSynced)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_DiscountApplied value) discountApplied,
    required TResult Function(_SyncStatusUpdated value) syncStatusUpdated,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_DiscountApplied value)? discountApplied,
    TResult? Function(_SyncStatusUpdated value)? syncStatusUpdated,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_DiscountApplied value)? discountApplied,
    TResult Function(_SyncStatusUpdated value)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _Initial implements OrderState {
  const factory _Initial() = _$InitialImpl;
}

/// @nodoc
abstract class _$$LoadingImplCopyWith<$Res> {
  factory _$$LoadingImplCopyWith(
          _$LoadingImpl value, $Res Function(_$LoadingImpl) then) =
      __$$LoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$LoadingImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$LoadingImpl>
    implements _$$LoadingImplCopyWith<$Res> {
  __$$LoadingImplCopyWithImpl(
      _$LoadingImpl _value, $Res Function(_$LoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$LoadingImpl with DiagnosticableTreeMixin implements _Loading {
  const _$LoadingImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderState.loading()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'OrderState.loading'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$LoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)
        success,
    required TResult Function(String message) error,
    required TResult Function() syncing,
    required TResult Function(double discountPercentage, int totalAfterDiscount)
        discountApplied,
    required TResult Function(int orderId, bool isSynced) syncStatusUpdated,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult? Function(String message)? error,
    TResult? Function()? syncing,
    TResult? Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult? Function(int orderId, bool isSynced)? syncStatusUpdated,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult Function(String message)? error,
    TResult Function()? syncing,
    TResult Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult Function(int orderId, bool isSynced)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_DiscountApplied value) discountApplied,
    required TResult Function(_SyncStatusUpdated value) syncStatusUpdated,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_DiscountApplied value)? discountApplied,
    TResult? Function(_SyncStatusUpdated value)? syncStatusUpdated,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_DiscountApplied value)? discountApplied,
    TResult Function(_SyncStatusUpdated value)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _Loading implements OrderState {
  const factory _Loading() = _$LoadingImpl;
}

/// @nodoc
abstract class _$$SuccessImplCopyWith<$Res> {
  factory _$$SuccessImplCopyWith(
          _$SuccessImpl value, $Res Function(_$SuccessImpl) then) =
      __$$SuccessImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {List<OrderItem> products,
      int totalQuantity,
      int totalPrice,
      int subTotal,
      double discountPercentage,
      DiscountResponseModel? appliedDiscount,
      String paymentMethod,
      int nominalBayar,
      int idKasir,
      String namaKasir,
      String customerName,
      int? tax,
      double? taxRate,
      int? serviceCharge,
      double? serviceChargeRate});
}

/// @nodoc
class __$$SuccessImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$SuccessImpl>
    implements _$$SuccessImplCopyWith<$Res> {
  __$$SuccessImplCopyWithImpl(
      _$SuccessImpl _value, $Res Function(_$SuccessImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? products = null,
    Object? totalQuantity = null,
    Object? totalPrice = null,
    Object? subTotal = null,
    Object? discountPercentage = null,
    Object? appliedDiscount = freezed,
    Object? paymentMethod = null,
    Object? nominalBayar = null,
    Object? idKasir = null,
    Object? namaKasir = null,
    Object? customerName = null,
    Object? tax = freezed,
    Object? taxRate = freezed,
    Object? serviceCharge = freezed,
    Object? serviceChargeRate = freezed,
  }) {
    return _then(_$SuccessImpl(
      null == products
          ? _value._products
          : products // ignore: cast_nullable_to_non_nullable
              as List<OrderItem>,
      null == totalQuantity
          ? _value.totalQuantity
          : totalQuantity // ignore: cast_nullable_to_non_nullable
              as int,
      null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as int,
      subTotal: null == subTotal
          ? _value.subTotal
          : subTotal // ignore: cast_nullable_to_non_nullable
              as int,
      discountPercentage: null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      appliedDiscount: freezed == appliedDiscount
          ? _value.appliedDiscount
          : appliedDiscount // ignore: cast_nullable_to_non_nullable
              as DiscountResponseModel?,
      paymentMethod: null == paymentMethod
          ? _value.paymentMethod
          : paymentMethod // ignore: cast_nullable_to_non_nullable
              as String,
      nominalBayar: null == nominalBayar
          ? _value.nominalBayar
          : nominalBayar // ignore: cast_nullable_to_non_nullable
              as int,
      idKasir: null == idKasir
          ? _value.idKasir
          : idKasir // ignore: cast_nullable_to_non_nullable
              as int,
      namaKasir: null == namaKasir
          ? _value.namaKasir
          : namaKasir // ignore: cast_nullable_to_non_nullable
              as String,
      customerName: null == customerName
          ? _value.customerName
          : customerName // ignore: cast_nullable_to_non_nullable
              as String,
      tax: freezed == tax
          ? _value.tax
          : tax // ignore: cast_nullable_to_non_nullable
              as int?,
      taxRate: freezed == taxRate
          ? _value.taxRate
          : taxRate // ignore: cast_nullable_to_non_nullable
              as double?,
      serviceCharge: freezed == serviceCharge
          ? _value.serviceCharge
          : serviceCharge // ignore: cast_nullable_to_non_nullable
              as int?,
      serviceChargeRate: freezed == serviceChargeRate
          ? _value.serviceChargeRate
          : serviceChargeRate // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc

class _$SuccessImpl with DiagnosticableTreeMixin implements _Success {
  const _$SuccessImpl(
      final List<OrderItem> products, this.totalQuantity, this.totalPrice,
      {required this.subTotal,
      required this.discountPercentage,
      required this.appliedDiscount,
      required this.paymentMethod,
      required this.nominalBayar,
      required this.idKasir,
      required this.namaKasir,
      required this.customerName,
      this.tax,
      this.taxRate,
      this.serviceCharge,
      this.serviceChargeRate})
      : _products = products;

  final List<OrderItem> _products;
  @override
  List<OrderItem> get products {
    if (_products is EqualUnmodifiableListView) return _products;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_products);
  }

  @override
  final int totalQuantity;
  @override
  final int totalPrice;
  @override
  final int subTotal;
  @override
  final double discountPercentage;
  @override
  final DiscountResponseModel? appliedDiscount;
  @override
  final String paymentMethod;
  @override
  final int nominalBayar;
  @override
  final int idKasir;
  @override
  final String namaKasir;
  @override
  final String customerName;
  @override
  final int? tax;
  @override
  final double? taxRate;
  @override
  final int? serviceCharge;
  @override
  final double? serviceChargeRate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderState.success(products: $products, totalQuantity: $totalQuantity, totalPrice: $totalPrice, subTotal: $subTotal, discountPercentage: $discountPercentage, appliedDiscount: $appliedDiscount, paymentMethod: $paymentMethod, nominalBayar: $nominalBayar, idKasir: $idKasir, namaKasir: $namaKasir, customerName: $customerName, tax: $tax, taxRate: $taxRate, serviceCharge: $serviceCharge, serviceChargeRate: $serviceChargeRate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderState.success'))
      ..add(DiagnosticsProperty('products', products))
      ..add(DiagnosticsProperty('totalQuantity', totalQuantity))
      ..add(DiagnosticsProperty('totalPrice', totalPrice))
      ..add(DiagnosticsProperty('subTotal', subTotal))
      ..add(DiagnosticsProperty('discountPercentage', discountPercentage))
      ..add(DiagnosticsProperty('appliedDiscount', appliedDiscount))
      ..add(DiagnosticsProperty('paymentMethod', paymentMethod))
      ..add(DiagnosticsProperty('nominalBayar', nominalBayar))
      ..add(DiagnosticsProperty('idKasir', idKasir))
      ..add(DiagnosticsProperty('namaKasir', namaKasir))
      ..add(DiagnosticsProperty('customerName', customerName))
      ..add(DiagnosticsProperty('tax', tax))
      ..add(DiagnosticsProperty('taxRate', taxRate))
      ..add(DiagnosticsProperty('serviceCharge', serviceCharge))
      ..add(DiagnosticsProperty('serviceChargeRate', serviceChargeRate));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SuccessImpl &&
            const DeepCollectionEquality().equals(other._products, _products) &&
            (identical(other.totalQuantity, totalQuantity) ||
                other.totalQuantity == totalQuantity) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.subTotal, subTotal) ||
                other.subTotal == subTotal) &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            (identical(other.appliedDiscount, appliedDiscount) ||
                other.appliedDiscount == appliedDiscount) &&
            (identical(other.paymentMethod, paymentMethod) ||
                other.paymentMethod == paymentMethod) &&
            (identical(other.nominalBayar, nominalBayar) ||
                other.nominalBayar == nominalBayar) &&
            (identical(other.idKasir, idKasir) || other.idKasir == idKasir) &&
            (identical(other.namaKasir, namaKasir) ||
                other.namaKasir == namaKasir) &&
            (identical(other.customerName, customerName) ||
                other.customerName == customerName) &&
            (identical(other.tax, tax) || other.tax == tax) &&
            (identical(other.taxRate, taxRate) || other.taxRate == taxRate) &&
            (identical(other.serviceCharge, serviceCharge) ||
                other.serviceCharge == serviceCharge) &&
            (identical(other.serviceChargeRate, serviceChargeRate) ||
                other.serviceChargeRate == serviceChargeRate));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_products),
      totalQuantity,
      totalPrice,
      subTotal,
      discountPercentage,
      appliedDiscount,
      paymentMethod,
      nominalBayar,
      idKasir,
      namaKasir,
      customerName,
      tax,
      taxRate,
      serviceCharge,
      serviceChargeRate);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      __$$SuccessImplCopyWithImpl<_$SuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)
        success,
    required TResult Function(String message) error,
    required TResult Function() syncing,
    required TResult Function(double discountPercentage, int totalAfterDiscount)
        discountApplied,
    required TResult Function(int orderId, bool isSynced) syncStatusUpdated,
  }) {
    return success(
        products,
        totalQuantity,
        totalPrice,
        subTotal,
        discountPercentage,
        appliedDiscount,
        paymentMethod,
        nominalBayar,
        idKasir,
        namaKasir,
        customerName,
        tax,
        taxRate,
        serviceCharge,
        serviceChargeRate);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult? Function(String message)? error,
    TResult? Function()? syncing,
    TResult? Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult? Function(int orderId, bool isSynced)? syncStatusUpdated,
  }) {
    return success?.call(
        products,
        totalQuantity,
        totalPrice,
        subTotal,
        discountPercentage,
        appliedDiscount,
        paymentMethod,
        nominalBayar,
        idKasir,
        namaKasir,
        customerName,
        tax,
        taxRate,
        serviceCharge,
        serviceChargeRate);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult Function(String message)? error,
    TResult Function()? syncing,
    TResult Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult Function(int orderId, bool isSynced)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(
          products,
          totalQuantity,
          totalPrice,
          subTotal,
          discountPercentage,
          appliedDiscount,
          paymentMethod,
          nominalBayar,
          idKasir,
          namaKasir,
          customerName,
          tax,
          taxRate,
          serviceCharge,
          serviceChargeRate);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_DiscountApplied value) discountApplied,
    required TResult Function(_SyncStatusUpdated value) syncStatusUpdated,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_DiscountApplied value)? discountApplied,
    TResult? Function(_SyncStatusUpdated value)? syncStatusUpdated,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_DiscountApplied value)? discountApplied,
    TResult Function(_SyncStatusUpdated value)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }
}

abstract class _Success implements OrderState {
  const factory _Success(final List<OrderItem> products,
      final int totalQuantity, final int totalPrice,
      {required final int subTotal,
      required final double discountPercentage,
      required final DiscountResponseModel? appliedDiscount,
      required final String paymentMethod,
      required final int nominalBayar,
      required final int idKasir,
      required final String namaKasir,
      required final String customerName,
      final int? tax,
      final double? taxRate,
      final int? serviceCharge,
      final double? serviceChargeRate}) = _$SuccessImpl;

  List<OrderItem> get products;
  int get totalQuantity;
  int get totalPrice;
  int get subTotal;
  double get discountPercentage;
  DiscountResponseModel? get appliedDiscount;
  String get paymentMethod;
  int get nominalBayar;
  int get idKasir;
  String get namaKasir;
  String get customerName;
  int? get tax;
  double? get taxRate;
  int? get serviceCharge;
  double? get serviceChargeRate;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SuccessImplCopyWith<_$SuccessImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ErrorImplCopyWith<$Res> {
  factory _$$ErrorImplCopyWith(
          _$ErrorImpl value, $Res Function(_$ErrorImpl) then) =
      __$$ErrorImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class __$$ErrorImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$ErrorImpl>
    implements _$$ErrorImplCopyWith<$Res> {
  __$$ErrorImplCopyWithImpl(
      _$ErrorImpl _value, $Res Function(_$ErrorImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_$ErrorImpl(
      null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$ErrorImpl with DiagnosticableTreeMixin implements _Error {
  const _$ErrorImpl(this.message);

  @override
  final String message;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderState.error(message: $message)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderState.error'))
      ..add(DiagnosticsProperty('message', message));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ErrorImpl &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      __$$ErrorImplCopyWithImpl<_$ErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)
        success,
    required TResult Function(String message) error,
    required TResult Function() syncing,
    required TResult Function(double discountPercentage, int totalAfterDiscount)
        discountApplied,
    required TResult Function(int orderId, bool isSynced) syncStatusUpdated,
  }) {
    return error(message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult? Function(String message)? error,
    TResult? Function()? syncing,
    TResult? Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult? Function(int orderId, bool isSynced)? syncStatusUpdated,
  }) {
    return error?.call(message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult Function(String message)? error,
    TResult Function()? syncing,
    TResult Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult Function(int orderId, bool isSynced)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_DiscountApplied value) discountApplied,
    required TResult Function(_SyncStatusUpdated value) syncStatusUpdated,
  }) {
    return error(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_DiscountApplied value)? discountApplied,
    TResult? Function(_SyncStatusUpdated value)? syncStatusUpdated,
  }) {
    return error?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_DiscountApplied value)? discountApplied,
    TResult Function(_SyncStatusUpdated value)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (error != null) {
      return error(this);
    }
    return orElse();
  }
}

abstract class _Error implements OrderState {
  const factory _Error(final String message) = _$ErrorImpl;

  String get message;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ErrorImplCopyWith<_$ErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncingImplCopyWith<$Res> {
  factory _$$SyncingImplCopyWith(
          _$SyncingImpl value, $Res Function(_$SyncingImpl) then) =
      __$$SyncingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncingImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$SyncingImpl>
    implements _$$SyncingImplCopyWith<$Res> {
  __$$SyncingImplCopyWithImpl(
      _$SyncingImpl _value, $Res Function(_$SyncingImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncingImpl with DiagnosticableTreeMixin implements _Syncing {
  const _$SyncingImpl();

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderState.syncing()';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('type', 'OrderState.syncing'));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)
        success,
    required TResult Function(String message) error,
    required TResult Function() syncing,
    required TResult Function(double discountPercentage, int totalAfterDiscount)
        discountApplied,
    required TResult Function(int orderId, bool isSynced) syncStatusUpdated,
  }) {
    return syncing();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult? Function(String message)? error,
    TResult? Function()? syncing,
    TResult? Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult? Function(int orderId, bool isSynced)? syncStatusUpdated,
  }) {
    return syncing?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult Function(String message)? error,
    TResult Function()? syncing,
    TResult Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult Function(int orderId, bool isSynced)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_DiscountApplied value) discountApplied,
    required TResult Function(_SyncStatusUpdated value) syncStatusUpdated,
  }) {
    return syncing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_DiscountApplied value)? discountApplied,
    TResult? Function(_SyncStatusUpdated value)? syncStatusUpdated,
  }) {
    return syncing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_DiscountApplied value)? discountApplied,
    TResult Function(_SyncStatusUpdated value)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (syncing != null) {
      return syncing(this);
    }
    return orElse();
  }
}

abstract class _Syncing implements OrderState {
  const factory _Syncing() = _$SyncingImpl;
}

/// @nodoc
abstract class _$$DiscountAppliedImplCopyWith<$Res> {
  factory _$$DiscountAppliedImplCopyWith(_$DiscountAppliedImpl value,
          $Res Function(_$DiscountAppliedImpl) then) =
      __$$DiscountAppliedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({double discountPercentage, int totalAfterDiscount});
}

/// @nodoc
class __$$DiscountAppliedImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$DiscountAppliedImpl>
    implements _$$DiscountAppliedImplCopyWith<$Res> {
  __$$DiscountAppliedImplCopyWithImpl(
      _$DiscountAppliedImpl _value, $Res Function(_$DiscountAppliedImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? discountPercentage = null,
    Object? totalAfterDiscount = null,
  }) {
    return _then(_$DiscountAppliedImpl(
      null == discountPercentage
          ? _value.discountPercentage
          : discountPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      null == totalAfterDiscount
          ? _value.totalAfterDiscount
          : totalAfterDiscount // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$DiscountAppliedImpl
    with DiagnosticableTreeMixin
    implements _DiscountApplied {
  const _$DiscountAppliedImpl(this.discountPercentage, this.totalAfterDiscount);

  @override
  final double discountPercentage;
  @override
  final int totalAfterDiscount;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderState.discountApplied(discountPercentage: $discountPercentage, totalAfterDiscount: $totalAfterDiscount)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderState.discountApplied'))
      ..add(DiagnosticsProperty('discountPercentage', discountPercentage))
      ..add(DiagnosticsProperty('totalAfterDiscount', totalAfterDiscount));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DiscountAppliedImpl &&
            (identical(other.discountPercentage, discountPercentage) ||
                other.discountPercentage == discountPercentage) &&
            (identical(other.totalAfterDiscount, totalAfterDiscount) ||
                other.totalAfterDiscount == totalAfterDiscount));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, discountPercentage, totalAfterDiscount);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DiscountAppliedImplCopyWith<_$DiscountAppliedImpl> get copyWith =>
      __$$DiscountAppliedImplCopyWithImpl<_$DiscountAppliedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)
        success,
    required TResult Function(String message) error,
    required TResult Function() syncing,
    required TResult Function(double discountPercentage, int totalAfterDiscount)
        discountApplied,
    required TResult Function(int orderId, bool isSynced) syncStatusUpdated,
  }) {
    return discountApplied(discountPercentage, totalAfterDiscount);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult? Function(String message)? error,
    TResult? Function()? syncing,
    TResult? Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult? Function(int orderId, bool isSynced)? syncStatusUpdated,
  }) {
    return discountApplied?.call(discountPercentage, totalAfterDiscount);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult Function(String message)? error,
    TResult Function()? syncing,
    TResult Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult Function(int orderId, bool isSynced)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (discountApplied != null) {
      return discountApplied(discountPercentage, totalAfterDiscount);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_DiscountApplied value) discountApplied,
    required TResult Function(_SyncStatusUpdated value) syncStatusUpdated,
  }) {
    return discountApplied(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_DiscountApplied value)? discountApplied,
    TResult? Function(_SyncStatusUpdated value)? syncStatusUpdated,
  }) {
    return discountApplied?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_DiscountApplied value)? discountApplied,
    TResult Function(_SyncStatusUpdated value)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (discountApplied != null) {
      return discountApplied(this);
    }
    return orElse();
  }
}

abstract class _DiscountApplied implements OrderState {
  const factory _DiscountApplied(
          final double discountPercentage, final int totalAfterDiscount) =
      _$DiscountAppliedImpl;

  double get discountPercentage;
  int get totalAfterDiscount;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DiscountAppliedImplCopyWith<_$DiscountAppliedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$SyncStatusUpdatedImplCopyWith<$Res> {
  factory _$$SyncStatusUpdatedImplCopyWith(_$SyncStatusUpdatedImpl value,
          $Res Function(_$SyncStatusUpdatedImpl) then) =
      __$$SyncStatusUpdatedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int orderId, bool isSynced});
}

/// @nodoc
class __$$SyncStatusUpdatedImplCopyWithImpl<$Res>
    extends _$OrderStateCopyWithImpl<$Res, _$SyncStatusUpdatedImpl>
    implements _$$SyncStatusUpdatedImplCopyWith<$Res> {
  __$$SyncStatusUpdatedImplCopyWithImpl(_$SyncStatusUpdatedImpl _value,
      $Res Function(_$SyncStatusUpdatedImpl) _then)
      : super(_value, _then);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? orderId = null,
    Object? isSynced = null,
  }) {
    return _then(_$SyncStatusUpdatedImpl(
      null == orderId
          ? _value.orderId
          : orderId // ignore: cast_nullable_to_non_nullable
              as int,
      null == isSynced
          ? _value.isSynced
          : isSynced // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$SyncStatusUpdatedImpl
    with DiagnosticableTreeMixin
    implements _SyncStatusUpdated {
  const _$SyncStatusUpdatedImpl(this.orderId, this.isSynced);

  @override
  final int orderId;
  @override
  final bool isSynced;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OrderState.syncStatusUpdated(orderId: $orderId, isSynced: $isSynced)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OrderState.syncStatusUpdated'))
      ..add(DiagnosticsProperty('orderId', orderId))
      ..add(DiagnosticsProperty('isSynced', isSynced));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SyncStatusUpdatedImpl &&
            (identical(other.orderId, orderId) || other.orderId == orderId) &&
            (identical(other.isSynced, isSynced) ||
                other.isSynced == isSynced));
  }

  @override
  int get hashCode => Object.hash(runtimeType, orderId, isSynced);

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SyncStatusUpdatedImplCopyWith<_$SyncStatusUpdatedImpl> get copyWith =>
      __$$SyncStatusUpdatedImplCopyWithImpl<_$SyncStatusUpdatedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)
        success,
    required TResult Function(String message) error,
    required TResult Function() syncing,
    required TResult Function(double discountPercentage, int totalAfterDiscount)
        discountApplied,
    required TResult Function(int orderId, bool isSynced) syncStatusUpdated,
  }) {
    return syncStatusUpdated(orderId, isSynced);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult? Function(String message)? error,
    TResult? Function()? syncing,
    TResult? Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult? Function(int orderId, bool isSynced)? syncStatusUpdated,
  }) {
    return syncStatusUpdated?.call(orderId, isSynced);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(
            List<OrderItem> products,
            int totalQuantity,
            int totalPrice,
            int subTotal,
            double discountPercentage,
            DiscountResponseModel? appliedDiscount,
            String paymentMethod,
            int nominalBayar,
            int idKasir,
            String namaKasir,
            String customerName,
            int? tax,
            double? taxRate,
            int? serviceCharge,
            double? serviceChargeRate)?
        success,
    TResult Function(String message)? error,
    TResult Function()? syncing,
    TResult Function(double discountPercentage, int totalAfterDiscount)?
        discountApplied,
    TResult Function(int orderId, bool isSynced)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (syncStatusUpdated != null) {
      return syncStatusUpdated(orderId, isSynced);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Initial value) initial,
    required TResult Function(_Loading value) loading,
    required TResult Function(_Success value) success,
    required TResult Function(_Error value) error,
    required TResult Function(_Syncing value) syncing,
    required TResult Function(_DiscountApplied value) discountApplied,
    required TResult Function(_SyncStatusUpdated value) syncStatusUpdated,
  }) {
    return syncStatusUpdated(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Initial value)? initial,
    TResult? Function(_Loading value)? loading,
    TResult? Function(_Success value)? success,
    TResult? Function(_Error value)? error,
    TResult? Function(_Syncing value)? syncing,
    TResult? Function(_DiscountApplied value)? discountApplied,
    TResult? Function(_SyncStatusUpdated value)? syncStatusUpdated,
  }) {
    return syncStatusUpdated?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Initial value)? initial,
    TResult Function(_Loading value)? loading,
    TResult Function(_Success value)? success,
    TResult Function(_Error value)? error,
    TResult Function(_Syncing value)? syncing,
    TResult Function(_DiscountApplied value)? discountApplied,
    TResult Function(_SyncStatusUpdated value)? syncStatusUpdated,
    required TResult orElse(),
  }) {
    if (syncStatusUpdated != null) {
      return syncStatusUpdated(this);
    }
    return orElse();
  }
}

abstract class _SyncStatusUpdated implements OrderState {
  const factory _SyncStatusUpdated(final int orderId, final bool isSynced) =
      _$SyncStatusUpdatedImpl;

  int get orderId;
  bool get isSynced;

  /// Create a copy of OrderState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SyncStatusUpdatedImplCopyWith<_$SyncStatusUpdatedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
