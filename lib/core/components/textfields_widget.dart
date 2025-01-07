import 'package:decent_chatbot/core/constants/color.dart';
import 'package:decent_chatbot/core/constants/config.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String? labelText;
  final IconData? leftIcon;
  final Color? iconColor;

  final IconData? secondIconOn;
  final IconData? secondIconOff;
  final bool? disableTextField;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;
  final bool isPassword;
  final Function(String)? onChanged;
  final VoidCallback? onSecondIconPressed;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.leftIcon,
    this.iconColor,
    this.secondIconOn,
    this.secondIconOff,
    this.disableTextField,
    this.validator,
    this.keyboardType,
    this.isPassword = false,
    this.onChanged,
    this.onSecondIconPressed,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _showPasswordField = false;
  String _errorText = '';

  bool _isValid = true;

  @override
  void initState() {
    super.initState();
  }

  void _showPassword() {
    setState(() {
      _showPasswordField = true;
    });
  }

  void _hidePassword() {
    setState(() {
      _showPasswordField = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return TextFormField(
      key: widget.key,
      onChanged: (value) {
        if (widget.onChanged != null) {
          widget.onChanged!(value);
        }

        setState(() {
          _errorText = widget.validator?.call(value) ?? '';
          _isValid = _errorText.isEmpty;
        });
      },
      keyboardType: widget.keyboardType,
      enabled: widget.disableTextField,
      controller: widget.controller,
      obscureText: widget.isPassword ? (!_showPasswordField) : false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,

        prefixIcon: widget.leftIcon != null
            ? Icon(
                widget.leftIcon,
                color: widget.iconColor ?? AppConfig().colors.txtTextFielColor,
                size: 24,
              )
            : null,
        suffixIcon: widget.secondIconOn != null
            ? IconButton(
                icon: Icon(
                  !_showPasswordField
                      ? widget.secondIconOff
                      : widget.secondIconOn,
                  color: AppConfig().colors.txtTextFielColor,
                ),
                onPressed: () {
                  if (!_showPasswordField) {
                    _showPassword();
                  } else {
                    _hidePassword();
                  }
                },
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppConfig().colors.primaryColor, width: 1.5),
          borderRadius: BorderRadius.circular(4.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: AppConfig().colors.txtBodyColor, width: 1),
          borderRadius: BorderRadius.circular(4.0),
        ),
        errorText: _isValid ? null : _errorText,
        errorMaxLines: 4,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors().txtHeaderColor, width: 1.5),
          borderRadius: BorderRadius.circular(4.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors().txtHeaderColor, width: 1.5),
          borderRadius: BorderRadius.circular(4.0),
        ),
        hintText: widget.labelText,
        // labelText: labelText,

        labelStyle: TextStyle(
          color: AppConfig().colors.txtTextFielColor,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        hintStyle: TextStyle(
          color: AppColors().txtTextFielColor,
          fontSize: 16,
        ),
      ),
      validator: widget.validator,
      style: textTheme.bodyMedium,
    );
  }
}

class CustomSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final IconData? icon;
  final IconData? secondIcon;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;
  final VoidCallback? onDoneAction;

  const CustomSearchField(
      {super.key,
      this.controller,
      this.labelText,
      this.icon,
      this.secondIcon,
      this.validator,
      this.keyboardType,
      this.onDoneAction,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: AppConfig().colors.txtHeaderColor,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        border: Border.all(
          color: AppConfig().colors.txtBodyColor,
          width: 0.5,
        ),
      ),
      child: TextFormField(
        key: super.key,
        onEditingComplete: onDoneAction,
        onChanged: onChanged,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.search,
        controller: controller,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          prefixIcon: icon != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 22.0, right: 12),
                  child: Icon(
                    icon,
                    color: AppConfig().colors.primaryColor,
                    size: 22,
                  ),
                )
              : null,
          suffixIcon: secondIcon != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 14.0, left: 8),
                  child: Icon(
                    secondIcon,
                    color: AppConfig().colors.primaryColor,
                    size: 22,
                  ),
                )
              : null,
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppColors().secondaryColor, width: 1.5),
            borderRadius: const BorderRadius.all(Radius.circular(50)),
          ),
          hintText: labelText,
          hintStyle: textStyle,
        ),
        validator: validator,
        style: textStyle,
      ),
    );
  }
}

class CustomMultiLineTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final IconData? icon;
  final Function(String)? onChanged;

  const CustomMultiLineTextField(
      {super.key, this.controller, this.labelText, this.icon, this.onChanged});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: TextField(
        controller: controller,
        maxLines: null,
        onChanged: onChanged,
        minLines: 5,
        maxLength: 1500,
        style: textTheme.bodyMedium,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          alignLabelWithHint: true,
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppConfig().colors.primaryColor, width: 1.5),
            borderRadius: BorderRadius.circular(4.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: AppConfig().colors.txtBodyColor, width: 1),
            borderRadius: BorderRadius.circular(4.0),
          ),
          border: InputBorder.none,
          hintText: labelText ?? "iher Antwort",
          labelStyle: TextStyle(
            color: AppConfig().colors.txtTextFielColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: TextStyle(
            color: AppColors().txtTextFielColor,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
