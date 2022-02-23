import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:climbing_app/app/router/app_router.dart';
import 'package:climbing_app/app/theme/app_theme_provider.dart';
import 'package:climbing_app/app/theme/bloc/app_theme.dart';
import 'package:climbing_app/app/theme/bloc/app_theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final router = GetIt.I<AppRouter>();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return BlocProvider(
      create: (context) => AppThemeBloc(),
      child: BlocBuilder<AppThemeBloc, AppTheme>(
        builder: (context, state) {
          return AppThemeProvider(
            theme: state,
            child: MaterialApp.router(
              title: "Скалолазание ИТМО",
              routeInformationParser: router.defaultRouteParser(),
              routerDelegate: router.delegate(),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                colorScheme: const ColorScheme.light().copyWith(
                  background: state.colorTheme.background,
                  brightness: state.colorTheme.brightness,
                  onPrimary: state.colorTheme.onPrimary,
                  primary: state.colorTheme.primary,
                ),
                iconTheme: IconThemeData(color: state.colorTheme.primary),
                textTheme: TextTheme(
                  bodyText1: state.textTheme.body1Regular,
                  subtitle1: state.textTheme.subtitle1,
                  subtitle2: state.textTheme.subtitle2,
                ),
                fontFamily: state.textTheme.fontFamily,
                cardTheme: const CardTheme(elevation: 8),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(8),
                    padding: MaterialStateProperty.all(const Pad(all: 16)),
                    shape: MaterialStateProperty.all(
                      const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    textStyle:
                        MaterialStateProperty.all(state.textTheme.button),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    minimumSize: MaterialStateProperty.all(Size.zero),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
