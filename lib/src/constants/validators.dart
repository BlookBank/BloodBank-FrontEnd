import 'package:form_field_validator/form_field_validator.dart';

/// Reglas de la contraseña: obligatoria, mínimo 8 caracteres y al menos un caracter especial.
final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'password is required'),
  MinLengthValidator(8, errorText: 'password must be at least 8 chars long'),
  PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'password  must have at least one special character')
]);

/// Reglas del correo: obligatorio y con formato válido.
final emailvalidator = MultiValidator([
  RequiredValidator(errorText: 'email is required'),
  EmailValidator(errorText: 'enter a valid email address')
]);

/// Regla del nombre: obligatorio.
final nameValidator = MultiValidator([
  RequiredValidator(errorText: "name is required")
]);

//para el registro necesitamos validar que las contraseñas
//coincidan
