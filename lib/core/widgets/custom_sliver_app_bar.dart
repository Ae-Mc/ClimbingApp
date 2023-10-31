import 'package:climbing_app/app/theme/bloc/app_theme.dart';
import 'package:flutter/material.dart';

class CustomSliverAppBar extends StatelessWidget {
  final String text;
  final Widget Function(BuildContext context) leadingBuilder;
  final List<Widget>? actions;

  const CustomSliverAppBar({
    super.key,
    required this.text,
    this.leadingBuilder = defaultLeadingBuilder,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppTheme.of(context).colorTheme.background,
      forceElevated: true,
      foregroundColor: AppTheme.of(context).colorTheme.secondary,
      floating: true,
      leading: Center(child: leadingBuilder(context)),
      title: Text(text),
      actions: actions,
    );
  }

  static Widget defaultLeadingBuilder(BuildContext context) => IconButton(
        onPressed: () => openDrawer(context),
        icon: const Icon(Icons.menu_rounded, size: 24),
      );

  static void openDrawer(BuildContext context) {
    final scaffold = Scaffold.maybeOf(context);
    if (scaffold != null) {
      if (!scaffold.hasDrawer) {
        openDrawer(scaffold.context);
      } else {
        scaffold.openDrawer();
      }
    }
  }
}
