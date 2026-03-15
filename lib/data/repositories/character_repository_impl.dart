import 'package:injustice_app/core/typedefs/types_defs.dart';
import 'package:injustice_app/data/repositories/character_repository_interface.dart';
import 'package:injustice_app/data/services/character_local_storage_interface.dart';
import 'package:injustice_app/domain/models/character_entity.dart';

/// implementacao do repositorio de character

final class CharacterRepositoryImpl implements ICharacterRepository {
  final ICharacterLocalStorage _localStorage;

  CharacterRepositoryImpl({required ICharacterLocalStorage localStorage})
    : _localStorage = localStorage;

  @override
  Future<CharacterResult> deleteCharacter(String id) {
    return _localStorage.deleteCharacter(id);
  }

  @override
  Future<CharacterResult> getCharacterById(String id) {
    return _localStorage.getCharacterById(id);
  }

  @override
  Future<ListCharacterResult> getAllCharacters() {
    return _localStorage.getAllCharacters();
  }

  @override
  Future<CharacterResult> saveCharacter(Character character) {
    return _localStorage.saveCharacter(character);
  }
}
