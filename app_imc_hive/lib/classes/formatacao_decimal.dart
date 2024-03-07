// Criando uma classe para formatação de dígitos decimais
import 'package:flutter/services.dart';
class DecimalTextInputFormatter extends TextInputFormatter {
  @override
  // Formatação de dígitos decimais
  TextEditingValue formatEditUpdate(
    // novo valor
    TextEditingValue oldValue,
    // valor antigo
    TextEditingValue newValue,
  ) {
    // o regEx aceita apenas números e um ponto como separador decimal
    final regEx = RegExp(r'^\d*\.?\d{0,3}');
    // se o novo valor contiver apenas números e um ponto como separador decimal...
    if (regEx.hasMatch(newValue.text)) {
      return newValue;
    }
    return oldValue;
  }
}
