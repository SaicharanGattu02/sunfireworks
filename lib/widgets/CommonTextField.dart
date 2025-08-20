import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Components/ShakeWidget.dart';

class CommonTextField1 extends StatefulWidget {
  final String hint;
  final String lable;
  final Color color;
  final double? lableFontSize;
  final FontWeight? lableFontWeight;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?)? validator;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  const CommonTextField1({
    super.key,
    required this.hint,
    required this.color,
    required this.lable,
    this.maxLines = 1,
    this.controller,
    this.lableFontSize,
    this.lableFontWeight,
    this.keyboardType,
    this.obscureText = false,
    this.onChanged,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  });

  @override
  State<CommonTextField1> createState() => _CommonTextField1State();
}

class _CommonTextField1State extends State<CommonTextField1> {
  bool showError = false;
  String errorKey = '';
  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        Text(widget.lable),
        const SizedBox(height: 10),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          maxLines: widget.maxLines,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textCapitalization: widget.textCapitalization, // ✅ applied here
          inputFormatters: widget.inputFormatters,
          onChanged: (val) {
            if (widget.onChanged != null) widget.onChanged!(val);
          },
          validator: (value) {
            final validationMsg = widget.validator?.call(value);
            if (validationMsg != null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  showError = true;
                  errorKey = DateTime.now().millisecondsSinceEpoch.toString();
                  errorMsg = validationMsg;
                });
              });
              return '';
            } else {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                setState(() {
                  showError = false;
                  errorMsg = '';
                });
              });
              return null;
            }
          },

          decoration: InputDecoration(
            errorStyle: const TextStyle(height: -10),
            hintText: widget.hint,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 20,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey,width: 0.5),
            ),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
        ),
        if (showError)
          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: ShakeWidget(
              key: Key(errorKey),
              duration: const Duration(milliseconds: 700),
              child: Text(
                errorMsg,
                style: const TextStyle(
                  fontFamily: 'roboto',
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
