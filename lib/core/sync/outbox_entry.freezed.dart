// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'outbox_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OutboxEntry {

 String get id; String get entityType; String get entityId; OutboxOperation get operation; Map<String, dynamic> get payload; SyncStatus get status; int get retryCount; String? get lastError; DateTime get createdAt;
/// Create a copy of OutboxEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OutboxEntryCopyWith<OutboxEntry> get copyWith => _$OutboxEntryCopyWithImpl<OutboxEntry>(this as OutboxEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OutboxEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.operation, operation) || other.operation == operation)&&const DeepCollectionEquality().equals(other.payload, payload)&&(identical(other.status, status) || other.status == status)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,entityType,entityId,operation,const DeepCollectionEquality().hash(payload),status,retryCount,lastError,createdAt);

@override
String toString() {
  return 'OutboxEntry(id: $id, entityType: $entityType, entityId: $entityId, operation: $operation, payload: $payload, status: $status, retryCount: $retryCount, lastError: $lastError, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $OutboxEntryCopyWith<$Res>  {
  factory $OutboxEntryCopyWith(OutboxEntry value, $Res Function(OutboxEntry) _then) = _$OutboxEntryCopyWithImpl;
@useResult
$Res call({
 String id, String entityType, String entityId, OutboxOperation operation, Map<String, dynamic> payload, SyncStatus status, int retryCount, String? lastError, DateTime createdAt
});




}
/// @nodoc
class _$OutboxEntryCopyWithImpl<$Res>
    implements $OutboxEntryCopyWith<$Res> {
  _$OutboxEntryCopyWithImpl(this._self, this._then);

  final OutboxEntry _self;
  final $Res Function(OutboxEntry) _then;

/// Create a copy of OutboxEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? entityType = null,Object? entityId = null,Object? operation = null,Object? payload = null,Object? status = null,Object? retryCount = null,Object? lastError = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as OutboxOperation,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [OutboxEntry].
extension OutboxEntryPatterns on OutboxEntry {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OutboxEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OutboxEntry() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OutboxEntry value)  $default,){
final _that = this;
switch (_that) {
case _OutboxEntry():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OutboxEntry value)?  $default,){
final _that = this;
switch (_that) {
case _OutboxEntry() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String entityType,  String entityId,  OutboxOperation operation,  Map<String, dynamic> payload,  SyncStatus status,  int retryCount,  String? lastError,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OutboxEntry() when $default != null:
return $default(_that.id,_that.entityType,_that.entityId,_that.operation,_that.payload,_that.status,_that.retryCount,_that.lastError,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String entityType,  String entityId,  OutboxOperation operation,  Map<String, dynamic> payload,  SyncStatus status,  int retryCount,  String? lastError,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _OutboxEntry():
return $default(_that.id,_that.entityType,_that.entityId,_that.operation,_that.payload,_that.status,_that.retryCount,_that.lastError,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String entityType,  String entityId,  OutboxOperation operation,  Map<String, dynamic> payload,  SyncStatus status,  int retryCount,  String? lastError,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _OutboxEntry() when $default != null:
return $default(_that.id,_that.entityType,_that.entityId,_that.operation,_that.payload,_that.status,_that.retryCount,_that.lastError,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _OutboxEntry extends OutboxEntry {
  const _OutboxEntry({required this.id, required this.entityType, required this.entityId, required this.operation, required final  Map<String, dynamic> payload, this.status = SyncStatus.pending, this.retryCount = 0, this.lastError, required this.createdAt}): _payload = payload,super._();
  

@override final  String id;
@override final  String entityType;
@override final  String entityId;
@override final  OutboxOperation operation;
 final  Map<String, dynamic> _payload;
@override Map<String, dynamic> get payload {
  if (_payload is EqualUnmodifiableMapView) return _payload;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_payload);
}

@override@JsonKey() final  SyncStatus status;
@override@JsonKey() final  int retryCount;
@override final  String? lastError;
@override final  DateTime createdAt;

/// Create a copy of OutboxEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OutboxEntryCopyWith<_OutboxEntry> get copyWith => __$OutboxEntryCopyWithImpl<_OutboxEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OutboxEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.entityType, entityType) || other.entityType == entityType)&&(identical(other.entityId, entityId) || other.entityId == entityId)&&(identical(other.operation, operation) || other.operation == operation)&&const DeepCollectionEquality().equals(other._payload, _payload)&&(identical(other.status, status) || other.status == status)&&(identical(other.retryCount, retryCount) || other.retryCount == retryCount)&&(identical(other.lastError, lastError) || other.lastError == lastError)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,entityType,entityId,operation,const DeepCollectionEquality().hash(_payload),status,retryCount,lastError,createdAt);

@override
String toString() {
  return 'OutboxEntry(id: $id, entityType: $entityType, entityId: $entityId, operation: $operation, payload: $payload, status: $status, retryCount: $retryCount, lastError: $lastError, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$OutboxEntryCopyWith<$Res> implements $OutboxEntryCopyWith<$Res> {
  factory _$OutboxEntryCopyWith(_OutboxEntry value, $Res Function(_OutboxEntry) _then) = __$OutboxEntryCopyWithImpl;
@override @useResult
$Res call({
 String id, String entityType, String entityId, OutboxOperation operation, Map<String, dynamic> payload, SyncStatus status, int retryCount, String? lastError, DateTime createdAt
});




}
/// @nodoc
class __$OutboxEntryCopyWithImpl<$Res>
    implements _$OutboxEntryCopyWith<$Res> {
  __$OutboxEntryCopyWithImpl(this._self, this._then);

  final _OutboxEntry _self;
  final $Res Function(_OutboxEntry) _then;

/// Create a copy of OutboxEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? entityType = null,Object? entityId = null,Object? operation = null,Object? payload = null,Object? status = null,Object? retryCount = null,Object? lastError = freezed,Object? createdAt = null,}) {
  return _then(_OutboxEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,entityType: null == entityType ? _self.entityType : entityType // ignore: cast_nullable_to_non_nullable
as String,entityId: null == entityId ? _self.entityId : entityId // ignore: cast_nullable_to_non_nullable
as String,operation: null == operation ? _self.operation : operation // ignore: cast_nullable_to_non_nullable
as OutboxOperation,payload: null == payload ? _self._payload : payload // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SyncStatus,retryCount: null == retryCount ? _self.retryCount : retryCount // ignore: cast_nullable_to_non_nullable
as int,lastError: freezed == lastError ? _self.lastError : lastError // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
