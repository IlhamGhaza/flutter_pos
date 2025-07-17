import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/theme_manager.dart';
import '../../../l10n/app_localizations.dart';
import '../bloc/theme/theme_bloc.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const SizedBox.shrink(),
          loading: (_) => const Center(child: CircularProgressIndicator()),
          loaded: (loadedState) => _buildThemeSelector(context, loadedState),
          error: (errorState) => Center(
            child: Text('Error: ${errorState.message}'),
          ),
        );
      },
    );
  }

  Widget _buildThemeSelector(BuildContext context, dynamic loadedState) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)!.theme,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildThemeOption(
              context,
              title: AppLocalizations.of(context)!.light,
              subtitle: AppLocalizations.of(context)!.useLightTheme,
              icon: Icons.light_mode,
              isSelected: loadedState.selectedTheme == AppThemeMode.light,
              onTap: () => _changeTheme(context, AppThemeMode.light),
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              title: AppLocalizations.of(context)!.dark,
              subtitle: AppLocalizations.of(context)!.useDarkTheme,
              icon: Icons.dark_mode,
              isSelected: loadedState.selectedTheme == AppThemeMode.dark,
              onTap: () => _changeTheme(context, AppThemeMode.dark),
            ),
            const SizedBox(height: 8),
            _buildThemeOption(
              context,
              title: AppLocalizations.of(context)!.system,
              subtitle: AppLocalizations.of(context)!.followSystemTheme,
              icon: Icons.settings_suggest,
              isSelected: loadedState.selectedTheme == AppThemeMode.system,
              onTap: () => _changeTheme(context, AppThemeMode.system),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).dividerColor,
            width: isSelected ? 2 : 1,
          ),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).iconTheme.color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.color
                              ?.withValues(alpha: 0.7),
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _changeTheme(BuildContext context, AppThemeMode themeMode) {
    context.read<ThemeBloc>().add(ThemeEvent.themeChanged(themeMode));
  }
}
