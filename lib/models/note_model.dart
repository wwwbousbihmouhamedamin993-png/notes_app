
import 'package:freezed_annotation/freezed_annotation.dart';
part 'note_model.freezed.dart';
@freezed
abstract class NoteModel with _$NoteModel {
const factory NoteModel({
  required String title,
  required String description, 
  required String id,
  required String userId,
  required DateTime createdAt, 
})= _NoteModel ;
}