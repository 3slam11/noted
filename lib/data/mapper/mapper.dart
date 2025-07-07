import 'package:noted/app/extensions.dart';
import 'package:noted/app/constants.dart';
import 'package:noted/data/responses/responses.dart';
import 'package:noted/domain/model/models.dart';

extension ItemToResponseMapper on Item {
  ItemResponse toResponse() {
    return ItemResponse(
      id,
      title,
      category,
      posterUrl,
      releaseDate,
      personalRating: personalRating,
      personalNotes: personalNotes,
    );
  }
}

extension ItemResponseMapper on ItemResponse? {
  Item toDomain() {
    return Item(
      this?.id.orEmpty() ?? Constants.empty,
      this?.title.orEmpty() ?? Constants.empty,
      this?.category.orDefault() ?? Category.all,
      this?.posterUrl.orEmpty() ?? Constants.empty,
      this?.releaseDate.orEmpty() ?? Constants.empty,
      personalRating: this?.personalRating,
      personalNotes: this?.personalNotes,
    );
  }
}

extension HomeResponseMapper on MainResponse? {
  MainObject toDomain() {
    List<Item> todos = (this?.data?.todos?.map((todo) => todo.toDomain()) ?? [])
        .toList();
    List<Item> finished =
        (this?.data?.finished?.map((finish) => finish.toDomain()) ?? [])
            .toList();

    var data = TaskData(todos, finished);

    return MainObject(data);
  }
}
