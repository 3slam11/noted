import 'package:noted/app/constants.dart';
import 'package:noted/domain/model/models.dart';

extension NonNullString on String? {
  String orEmpty() {
    if (this == null) {
      return Constants.empty;
    } else {
      return this!;
    }
  }
}

extension NonNullInt on int? {
  int orZero() {
    if (this == null) {
      return Constants.zero;
    } else {
      return this!;
    }
  }
}

extension CategoryExtension on Category? {
  Category orDefault() {
    if (this == null) {
      return Category.movies;
    } else {
      return this!;
    }
  }
}
