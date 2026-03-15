import 'package:injustice_app/core/typedefs/types_defs.dart';
import 'package:injustice_app/domain/models/character_entity.dart';

abstract interface class ICharacterRepository {
  Future<CharacterResult> getCharacterById(String id);
  Future<ListCharacterResult> getAllCharacters();
  Future<CharacterResult> saveCharacter(Character character);
  Future<CharacterResult> deleteCharacter(String id);
}