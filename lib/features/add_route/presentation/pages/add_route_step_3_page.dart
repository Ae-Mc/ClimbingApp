import 'package:assorted_layout_widgets/assorted_layout_widgets.dart';
import 'package:auto_route/auto_route.dart';
import 'package:climbing_app/app/router/app_router.dart';
import 'package:climbing_app/app/theme/bloc/app_theme.dart';
import 'package:climbing_app/core/util/category_to_color.dart';
import 'package:climbing_app/features/add_route/presentation/widgets/category_card.dart';
import 'package:climbing_app/features/add_route/presentation/widgets/header.dart';
import 'package:climbing_app/features/routes/domain/entities/category.dart';
import 'package:flutter/material.dart';

class AddRouteStep3Page extends StatefulWidget {
  const AddRouteStep3Page({Key? key}) : super(key: key);

  @override
  State<AddRouteStep3Page> createState() => _AddRouteStep3PageState();
}

class _AddRouteStep3PageState extends State<AddRouteStep3Page> {
  Category? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final colorTheme = AppTheme.of(context).colorTheme;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const Pad(all: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Header(stepNum: 3),
                const SizedBox(height: 32),
                Text(
                  'ШАГ 3: Выбери категорию',
                  style: AppTheme.of(context).textTheme.body2Regular,
                  maxLines: 20,
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const Pad(horizontal: 8),
                child: Builder(builder: (context) {
                  final allCategories = Category.categories
                      .map((e) => Category(e))
                      .where((element) => element <= Category('8a+'));
                  final categories = [
                    allCategories
                        .where((element) =>
                            categoryToColor(element, colorTheme) ==
                            colorTheme.routeEasy)
                        .toList()
                        .reversed
                        .toList(),
                    allCategories
                        .where((element) =>
                            categoryToColor(element, colorTheme) ==
                            colorTheme.routeMedium)
                        .toList()
                        .reversed
                        .toList(),
                    allCategories
                        .where((element) =>
                            categoryToColor(element, colorTheme) ==
                            colorTheme.routeHard)
                        .toList()
                        .reversed
                        .toList(),
                  ];

                  return Row(
                    children: categories
                        .map((e) => Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: e
                                    .map((e) => Padding(
                                          padding: const Pad(all: 8),
                                          child: CategoryCard(
                                            category: e,
                                            isSelected: e == selectedCategory,
                                            onTap: () => setState(
                                              () => selectedCategory = e,
                                            ),
                                          ),
                                        ))
                                    .toList(),
                              ),
                            ))
                        .toList(),
                  );
                }),
              ),
              const SizedBox(height: 16),
              Container(
                alignment: Alignment.bottomCenter,
                padding: const Pad(bottom: 16, horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: selectedCategory == null
                        ? null
                        : () => AutoRouter.of(context)
                            .push(const AddRouteStep4Route()),
                    child: const Text('Вперёд'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
