import 'package:injustice_app/core/failure/failure.dart';
import 'package:injustice_app/core/messages/app_messages.dart';

import 'base_validator.dart';
final class MinDoubleFromStrValidator extends BaseValidator<String?> {
  final double minValue;

  MinDoubleFromStrValidator({this.minValue = 0});

  @override
  bool validate(String? validation) {
    switch (validation) {
      case null:
        return throw InputFailure(AppMessages.error.nullStringError);
      case String _:
        {
          var value = double.tryParse(validation);
          if (value == null) {
            return throw InputFailure(AppMessages.error.nullStringError);
          }
          if (value < minValue) {
            return throw InputFailure(
                '${AppMessages.error.minDoubleError} - (${minValue.toStringAsFixed(2)})');
          }

          return nextValidator?.validate(validation) ?? true;
        }
    }
  }
}
