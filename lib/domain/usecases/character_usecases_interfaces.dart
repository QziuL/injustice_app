import 'package:injustice_app/core/patterns/i_usecases.dart';
import 'package:injustice_app/core/typedefs/types_defs.dart';

abstract interface class IGetCharacterByIdUseCase
    implements IUseCase<CharacterResult, CharacterIdParams> {}
abstract interface class IGetAllCharactersUseCase
    implements IUseCase<ListCharacterResult, NoParams> {}
abstract interface class ISaveCharacterUseCase
    implements IUseCase<CharacterResult, CharacterParams> {}
abstract interface class IDeleteCharacterUseCase
    implements IUseCase<CharacterResult, CharacterIdParams> {}