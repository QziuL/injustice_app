import 'package:injustice_app/domain/models/account_entity.dart';
import 'package:injustice_app/helper_dev/fakes/fakes_factory.dart';

class AccountFactory {
  /// Cria uma instância de Account com dados falsos
  static Account single() {
    return FakeFactory.account();
  }

  /// Cria uma lista de Accounts com dados falsos
  static List<Account> list([int count = 5]) {
    var list = List.generate(
      count,
      (index) => single(),
    );

    return list;
  }
}
