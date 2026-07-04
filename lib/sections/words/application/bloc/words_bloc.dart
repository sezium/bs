import 'package:bs/sections/words/application/bloc/words_event.dart';
import 'package:bs/sections/words/application/bloc/words_state.dart';
import 'package:bs/sections/words/dependency/words_dependencies_mixin.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class WordsBloc extends Bloc<WordsEvent, WordsState> with WordsDependenciesMixin {
  WordsBloc() : super(const WordsStateInit()) {
    on<WordsEventInit>(_onInit);
  }

  void _onInit(WordsEventInit event, Emitter<WordsState> emit) {
    emit(const WordsStateInit());
  }
}
