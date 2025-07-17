import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/utils/theme_manager.dart';

part 'theme_event.dart';
part 'theme_state.dart';
part 'theme_bloc.freezed.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState.initial()) {
    on<ThemeEvent>((event, emit) async {
      await event.map(
        started: (e) async => await _onStarted(e, emit),
        themeChanged: (e) async => await _onThemeChanged(e, emit),
        systemThemeChanged: (e) async => await _onSystemThemeChanged(e, emit),
      );
    });
  }

  Future<void> _onStarted(_Started event, Emitter<ThemeState> emit) async {
    emit(const ThemeState.loading());
    
    try {
      final themeMode = await ThemeManager.getThemeMode();
      final resolvedTheme = await ThemeManager.getResolvedThemeMode();
      
      emit(ThemeState.loaded(
        selectedTheme: themeMode,
        currentTheme: resolvedTheme,
      ));
    } catch (e) {
      emit(ThemeState.error(e.toString()));
    }
  }

  Future<void> _onThemeChanged(_ThemeChanged event, Emitter<ThemeState> emit) async {
    try {
      await ThemeManager.setThemeMode(event.themeMode);
      final resolvedTheme = await ThemeManager.getResolvedThemeMode();
      
      emit(ThemeState.loaded(
        selectedTheme: event.themeMode,
        currentTheme: resolvedTheme,
      ));
    } catch (e) {
      emit(ThemeState.error(e.toString()));
    }
  }

  Future<void> _onSystemThemeChanged(_SystemThemeChanged event, Emitter<ThemeState> emit) async {
    try {
      final currentState = state;
      if (currentState is _Loaded) {
        final resolvedTheme = await ThemeManager.getResolvedThemeMode();
        
        emit(ThemeState.loaded(
          selectedTheme: currentState.selectedTheme,
          currentTheme: resolvedTheme,
        ));
      }
    } catch (e) {
      emit(ThemeState.error(e.toString()));
    }
  }
} 