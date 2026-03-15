import 'package:injustice_app/core/typedefs/types_defs.dart';
import 'package:injustice_app/domain/models/account_entity.dart';

abstract interface class IAccountLocalStorage {
  Future<VoidResult> saveAccount(Account account);
  Future<VoidResult> updateAccount(Account account);
  Future<AccountResult> getAccount();
  Future<VoidResult> deleteAccount();
}