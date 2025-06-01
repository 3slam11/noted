// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'freezed_data_classes.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$LoginObject {

 String get email; String get password;
/// Create a copy of LoginObject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoginObjectCopyWith<LoginObject> get copyWith => _$LoginObjectCopyWithImpl<LoginObject>(this as LoginObject, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoginObject&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'LoginObject(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $LoginObjectCopyWith<$Res>  {
  factory $LoginObjectCopyWith(LoginObject value, $Res Function(LoginObject) _then) = _$LoginObjectCopyWithImpl;
@useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class _$LoginObjectCopyWithImpl<$Res>
    implements $LoginObjectCopyWith<$Res> {
  _$LoginObjectCopyWithImpl(this._self, this._then);

  final LoginObject _self;
  final $Res Function(LoginObject) _then;

/// Create a copy of LoginObject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _LoginObject implements LoginObject {
  const _LoginObject({required this.email, required this.password});
  

@override final  String email;
@override final  String password;

/// Create a copy of LoginObject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoginObjectCopyWith<_LoginObject> get copyWith => __$LoginObjectCopyWithImpl<_LoginObject>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _LoginObject&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,email,password);

@override
String toString() {
  return 'LoginObject(email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$LoginObjectCopyWith<$Res> implements $LoginObjectCopyWith<$Res> {
  factory _$LoginObjectCopyWith(_LoginObject value, $Res Function(_LoginObject) _then) = __$LoginObjectCopyWithImpl;
@override @useResult
$Res call({
 String email, String password
});




}
/// @nodoc
class __$LoginObjectCopyWithImpl<$Res>
    implements _$LoginObjectCopyWith<$Res> {
  __$LoginObjectCopyWithImpl(this._self, this._then);

  final _LoginObject _self;
  final $Res Function(_LoginObject) _then;

/// Create a copy of LoginObject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? email = null,Object? password = null,}) {
  return _then(_LoginObject(
email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$RegisterObject {

 String get name; String get email; String get password;
/// Create a copy of RegisterObject
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegisterObjectCopyWith<RegisterObject> get copyWith => _$RegisterObjectCopyWithImpl<RegisterObject>(this as RegisterObject, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RegisterObject&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,name,email,password);

@override
String toString() {
  return 'RegisterObject(name: $name, email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class $RegisterObjectCopyWith<$Res>  {
  factory $RegisterObjectCopyWith(RegisterObject value, $Res Function(RegisterObject) _then) = _$RegisterObjectCopyWithImpl;
@useResult
$Res call({
 String name, String email, String password
});




}
/// @nodoc
class _$RegisterObjectCopyWithImpl<$Res>
    implements $RegisterObjectCopyWith<$Res> {
  _$RegisterObjectCopyWithImpl(this._self, this._then);

  final RegisterObject _self;
  final $Res Function(RegisterObject) _then;

/// Create a copy of RegisterObject
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? email = null,Object? password = null,}) {
  return _then(_self.copyWith(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,password: null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc


class _RegisterObject implements RegisterObject {
  const _RegisterObject(this.name, this.email, this.password);
  

@override final  String name;
@override final  String email;
@override final  String password;

/// Create a copy of RegisterObject
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegisterObjectCopyWith<_RegisterObject> get copyWith => __$RegisterObjectCopyWithImpl<_RegisterObject>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RegisterObject&&(identical(other.name, name) || other.name == name)&&(identical(other.email, email) || other.email == email)&&(identical(other.password, password) || other.password == password));
}


@override
int get hashCode => Object.hash(runtimeType,name,email,password);

@override
String toString() {
  return 'RegisterObject(name: $name, email: $email, password: $password)';
}


}

/// @nodoc
abstract mixin class _$RegisterObjectCopyWith<$Res> implements $RegisterObjectCopyWith<$Res> {
  factory _$RegisterObjectCopyWith(_RegisterObject value, $Res Function(_RegisterObject) _then) = __$RegisterObjectCopyWithImpl;
@override @useResult
$Res call({
 String name, String email, String password
});




}
/// @nodoc
class __$RegisterObjectCopyWithImpl<$Res>
    implements _$RegisterObjectCopyWith<$Res> {
  __$RegisterObjectCopyWithImpl(this._self, this._then);

  final _RegisterObject _self;
  final $Res Function(_RegisterObject) _then;

/// Create a copy of RegisterObject
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? email = null,Object? password = null,}) {
  return _then(_RegisterObject(
null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,null == password ? _self.password : password // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
