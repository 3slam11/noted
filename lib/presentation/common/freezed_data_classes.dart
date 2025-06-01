import 'package:freezed_annotation/freezed_annotation.dart';
part 'freezed_data_classes.freezed.dart';

@freezed
abstract class LoginObject
    with
        _$LoginObject {
  const factory LoginObject({
    required String email,
    required String password,
  }) =
      _LoginObject;
}

@freezed
abstract class RegisterObject
    with
        _$RegisterObject {
  const factory RegisterObject(
    final String name,
    final String email,
    final String password,
  ) =
      _RegisterObject;
}
