import 'package:bs/core/extentions/build_context_extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class BaseScreen extends StatelessWidget {
  const BaseScreen({super.key});


  List<BlocProvider> get providers;

  @protected
  Widget mobile(BuildContext context);
  @protected
  Widget tablet(BuildContext context);
  @protected
  Widget desktop(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: providers,
      child: context.responsiveValue(
        mobile: mobile(context),
        tablet: tablet(context),
        desktop: desktop(context),
      ),
    );
  }
}

abstract class SingleBlocScreen<T extends Bloc> extends BaseScreen {
  final T bloc;
  const SingleBlocScreen({super.key, required this.bloc});

  @override
  List<BlocProvider> get providers => [BlocProvider<T>(create: (_) => bloc)];
}

abstract class MultiBlocScreen extends BaseScreen {
  final List<BlocProvider> _providers;

  MultiBlocScreen({super.key, required List<BlocBase<dynamic>> blocs})
      : _providers = blocs.map((bloc) => BlocProvider.value(value: bloc)).toList();

  @override
  List<BlocProvider> get providers => _providers;
}
