// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_tax_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SyncTaxEvent {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sync,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sync,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sync,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Sync value) sync,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Sync value)? sync,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Sync value)? sync,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SyncTaxEventCopyWith<$Res> {
  factory $SyncTaxEventCopyWith(
          SyncTaxEvent value, $Res Function(SyncTaxEvent) then) =
      _$SyncTaxEventCopyWithImpl<$Res, SyncTaxEvent>;
}

/// @nodoc
class _$SyncTaxEventCopyWithImpl<$Res, $Val extends SyncTaxEvent>
    implements $SyncTaxEventCopyWith<$Res> {
  _$SyncTaxEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SyncTaxEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$SyncImplCopyWith<$Res> {
  factory _$$SyncImplCopyWith(
          _$SyncImpl value, $Res Function(_$SyncImpl) then) =
      __$$SyncImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$SyncImplCopyWithImpl<$Res>
    extends _$SyncTaxEventCopyWithImpl<$Res, _$SyncImpl>
    implements _$$SyncImplCopyWith<$Res> {
  __$$SyncImplCopyWithImpl(_$SyncImpl _value, $Res Function(_$SyncImpl) _then)
      : super(_value, _then);

  /// Create a copy of SyncTaxEvent
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$SyncImpl implements _Sync {
  const _$SyncImpl();

  @override
  String toString() {
    return 'SyncTaxEvent.sync()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$SyncImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() sync,
  }) {
    return sync();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? sync,
  }) {
    return sync?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? sync,
    required TResult orElse(),
  }) {
    if (sync != null) {
      return sync();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_Sync value) sync,
  }) {
    return sync(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_Sync value)? sync,
  }) {
    return sync?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_Sync value)? sync,
    required TResult orElse(),
  }) {
    if (sync != null) {
      return sync(this);
    }
    return orElse();
  }
}

abstract class _Sync implements SyncTaxEvent {
  const factory _Sync() = _$SyncImpl;
}
