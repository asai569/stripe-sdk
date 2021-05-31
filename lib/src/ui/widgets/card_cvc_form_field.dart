import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Form field to edit a credit card CVC code, with validation
class CardCvcFormField extends StatefulWidget {
  CardCvcFormField(
      {Key? key,
      this.initialValue,
      required this.onSaved,
      required this.validator,
      required this.onChanged,
      this.decoration = defaultDecoration,
      this.textStyle = defaultTextStyle})
      : super(key: key);

  final String? initialValue;
  final InputDecoration decoration;
  final TextStyle textStyle;
  final void Function(String?) onSaved;
  final void Function(String) onChanged;
  final String? Function(String?) validator;

  static const defaultErrorText = 'Invalid CVV';
  static const defaultDecoration = InputDecoration(
      border: OutlineInputBorder(), labelText: 'CVV', hintText: 'XXX');
  static const defaultTextStyle = TextStyle(color: Colors.black);

  @override
  _CardCvcFormFieldState createState() => _CardCvcFormFieldState();
}

class _CardCvcFormFieldState extends State<CardCvcFormField> {
  //androidで不具合を確認
  //final maskFormatter = MaskTextInputFormatter(mask: '####');

  final maskFormatter = [
    FilteringTextInputFormatter.digitsOnly,
    CardCVCFormInputFormatter(),
  ];

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      autofillHints: [AutofillHints.creditCardSecurityCode],
      inputFormatters: maskFormatter,
      onChanged: widget.onChanged,
      validator: widget.validator,
      onSaved: widget.onSaved,
      style: widget.textStyle,
      decoration: widget.decoration,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.next,
    );
  }
}

/// Formata o valor do campo com a mascara `0000`
class CardCVCFormInputFormatter extends TextInputFormatter {
  /// Define o tamanho máximo do campo.
  final int maxLength = 4;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue valorAntigo, TextEditingValue valorNovo) {
    final novoTextLength = valorNovo.text.length;
    var selectionIndex = valorNovo.selection.end;

    if (novoTextLength > maxLength) {
      return valorAntigo;
    }

    var usedSubstringIndex = 0;
    final newText = StringBuffer();

    if (novoTextLength >= 4) {
      newText.write(valorNovo.text.substring(0, usedSubstringIndex = 4) + ' ');
      if (valorNovo.selection.end >= 5) selectionIndex++;
    }

    if (novoTextLength >= usedSubstringIndex) {
      newText.write(valorNovo.text.substring(usedSubstringIndex));
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
