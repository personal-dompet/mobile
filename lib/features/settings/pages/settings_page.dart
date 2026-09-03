import 'package:auto_route/auto_route.dart';
import 'package:dompet_app/core/models/app_configuration.dart';
import 'package:dompet_app/features/app_configurations/cubits/app_configuration_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: BlocBuilder<AppConfigurationCubit, AppConfiguration?>(
        builder: (context, config) {
          if (config == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Text(
                  'Tampilan',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.brightness_auto_rounded),
                title: const Text('Tema'),
                subtitle: Text(_labelFor(config.themeMode)),
              ),
              RadioGroup<AppThemeMode>(
                groupValue: config.themeMode,
                onChanged: (value) {
                  if (value == null) return;
                  context.read<AppConfigurationCubit>().update(
                    config.copyWith(themeMode: value),
                  );
                },
                child: Column(
                  children: [
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.system,
                      title: const Text('Ikuti Sistem'),
                      subtitle: const Text('Mengikuti tema perangkat'),
                      secondary: const Icon(Icons.smartphone_rounded),
                    ),
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.light,
                      title: const Text('Terang'),
                      secondary: const Icon(Icons.light_mode_rounded),
                    ),
                    RadioListTile<AppThemeMode>(
                      value: AppThemeMode.dark,
                      title: const Text('Gelap'),
                      secondary: const Icon(Icons.dark_mode_rounded),
                    ),
                  ],
                ),
              ),
              const Divider(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Preferensi tema akan disimpan dan digunakan saat aplikasi dibuka kembali.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  String _labelFor(AppThemeMode mode) {
    return switch (mode) {
      AppThemeMode.system => 'Ikuti Sistem',
      AppThemeMode.light => 'Terang',
      AppThemeMode.dark => 'Gelap',
    };
  }
}
