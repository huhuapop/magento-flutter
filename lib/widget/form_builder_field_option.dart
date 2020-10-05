import 'package:flutter/material.dart';

class FormBuilderFieldOption extends StatelessWidget {
  final Widget child;
  final dynamic value;

  const FormBuilderFieldOption({
    Key key,
    @required this.value,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
