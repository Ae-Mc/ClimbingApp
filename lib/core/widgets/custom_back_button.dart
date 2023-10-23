import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:climbing_app/app/theme/bloc/app_theme.dart';
import 'package:flutter/material.dart';

class CustomBackButton extends StatelessWidget {
  final void Function(BuildContext context) onPressed;
  static const double iconSize = 48;

  const CustomBackButton({
    super.key,
    this.onPressed = defaultOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppTheme.of(context).colorTheme;

    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(colorTheme.secondary),
        foregroundColor: MaterialStateProperty.all(colorTheme.background),
        padding: MaterialStateProperty.all(Pad.zero),
        shape: MaterialStateProperty.all(const CircleBorder()),
      ),
      onPressed: () => onPressed(context),
      child: Icon(Icons.chevron_left,
          color: colorTheme.background, size: iconSize),
    );
  }

  static void defaultOnPressed(BuildContext context) =>
      // ignore: avoid-ignoring-return-values
      AutoRouter.of(context).pop();
}
