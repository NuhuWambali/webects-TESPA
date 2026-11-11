

import 'package:form_field_validator/form_field_validator.dart';
import 'apicalcontroller.dart';

ApiController apiController = ApiController.instance;

final requiredValidator = RequiredValidator(errorText: 'This field is mandatory');
