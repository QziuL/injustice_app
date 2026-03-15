import 'package:injustice_app/core/failure/failure.dart';
import 'package:injustice_app/core/messages/app_messages.dart';
import 'package:injustice_app/core/validators/base_validator.dart';

final class PasswordConfirmationStrValidator extends BaseValidator<String?> {
  
  final String password;

  PasswordConfirmationStrValidator(this.password);

  @override
  bool validate(String? validation) {
    return switch (validation) {
      null => throw InputFailure(AppMessages.error.nullStringError),
      String v when v.trim().isEmpty => throw InputFailure(
          AppMessages.error.nullStringError,
        ),
      String v when v.compareTo(password) !=0 => throw PasswordNotConfirmed(
          AppMessages.error.passwordMismatchError,
        ),
      _ => nextValidator?.validate(validation) ?? true,
    };
  }
}
