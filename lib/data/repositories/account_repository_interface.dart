import 'package:injustice_app/core/typedefs/types_defs.dart';
import 'package:injustice_app/domain/models/account_entity.dart';

abstract interface class IAccountRepository {
  Future<AccountResult> getAccount();
  Future<VoidResult> saveAccount(Account account);
  Future<VoidResult> updateAccount(Account account);
  Future<VoidResult> deleteAccount();
}