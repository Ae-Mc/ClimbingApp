import 'package:climbing_app/arch/single_result_bloc/single_result_bloc.dart';
import 'package:climbing_app/features/add_route/domain/entities/route_create.dart';
import 'package:climbing_app/features/add_route/domain/repositories/add_route_repository.dart';
import 'package:climbing_app/features/add_route/presentation/bloc/add_route_single_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import 'add_route_event.dart';
import 'add_route_state.dart';

@injectable
class AddRouteBloc extends SingleResultBloc<AddRouteEvent, AddRouteState,
    AddRouteSingleResult> {
  final AddRouteRepository repository;

  AddRouteBloc(this.repository) : super(const AddRouteState.data()) {
    on<AddRouteEvent>((event, emit) {
      state.map<void>(
        data: (state) => event.when<void>(
          setName: (name) => emit(state.copyWith(name: name)),
          setMarksColor: (color) => emit(state.copyWith(color: color)),
          setDate: (date) => emit(state.copyWith(date: date)),
          setDescription: (description) =>
              emit(state.copyWith(description: description)),
          setAuthor: (author) => emit(state.copyWith(author: author)),
          setCategory: (category) => emit(state.copyWith(category: category)),
          setImages: (images) => emit(state.copyWith(images: images)),
          uploadRoute: () => upload(state, emit),
        ),
        loading: (_) => throw UnimplementedError('Impossible state'),
      );
    });
  }

  void upload(AddRouteStateData dataState, Emitter<AddRouteState> emit) {
    emit(const AddRouteState.loading());
    final route = RouteCreate(
      // ignore: avoid-non-null-assertion
      author: '${dataState.author!.firstName} ${dataState.author!.lastName}',
      // ignore: avoid-non-null-assertion
      category: dataState.category!,
      // ignore: avoid-non-null-assertion
      creationDate: DateFormat.yMd().format(dataState.date!),
      // ignore: avoid-non-null-assertion
      description: dataState.description!,
      // ignore: avoid-non-null-assertion
      images: dataState.images!,
      // ignore: avoid-non-null-assertion
      markColor: dataState.color!,
      // ignore: avoid-non-null-assertion
      name: dataState.name!,
    );
    GetIt.I<Logger>().d('Upload route: $route');
  }
}
