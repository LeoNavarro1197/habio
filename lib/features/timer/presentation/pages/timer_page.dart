import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/duration_format_utils.dart';
import '../../../../core/widgets/banner_ad_widget.dart';
import '../../domain/entities/timer_session_entity.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../providers/timer_providers.dart';

class TimerPage extends ConsumerStatefulWidget {
  const TimerPage({super.key});

  @override
  ConsumerState<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends ConsumerState<TimerPage> {
  late final TextEditingController _activityNameController;

  @override
  void initState() {
    super.initState();
    final initialName = ref.read(timerControllerProvider).activityName;
    _activityNameController = TextEditingController(text: initialName);
  }

  @override
  void dispose() {
    _activityNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerState = ref.watch(timerControllerProvider);
    final timerController = ref.read(timerControllerProvider.notifier);
    final settings = ref.watch(settingsControllerProvider);
    final showAds = settings.adsRemoved == false;

    ref.listen<TimerSessionState>(timerControllerProvider, (previous, next) {
      if (previous?.status != TimerStatus.completed &&
          next.status == TimerStatus.completed) {
        final activityName = next.activityName.trim();
        final message = activityName.isEmpty
            ? 'Sesión completada. Buen trabajo.'
            : 'Sesión completada: $activityName';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    });

    if (_activityNameController.text != timerState.activityName &&
        !timerState.isRunning) {
      _activityNameController.text = timerState.activityName;
    }

    return Column(
      children: [
        if (showAds) const Center(child: BannerAdWidget()),
        Expanded(
          child: ListView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 120),
      children: [
        Text('Temporizador', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 4),
        const Text(
          'Concentra tu tiempo en una actividad.',
          style: TextStyle(color: AppColors.textTertiary, fontSize: 14),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _activityNameController,
          enabled: !timerState.isRunning,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            labelText: 'Actividad',
            hintText: 'Estudio, trabajo, ejercicio...',
          ),
          onChanged: timerController.setActivityName,
        ),
        const SizedBox(height: 20),
        const Text(
          'DURACIÓN',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: TimerSessionState.durationPresets.map((minutes) {
            final isSelected = timerState.durationMinutes == minutes;
            return ChoiceChip(
              label: Text('$minutes min'),
              selected: isSelected,
              onSelected: timerState.canEditDuration
                  ? (_) => timerController.setDurationMinutes(minutes)
                  : null,
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
        Center(
          child: SizedBox(
            width: 240,
            height: 240,
            child: _TimerRing(
              progress: timerState.isCompleted ? 1 : timerState.progress,
              isCompleted: timerState.isCompleted,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DurationFormatUtils.formatCountdown(
                      timerState.remainingSeconds,
                    ),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 42,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _statusLabel(timerState.status),
                    style: TextStyle(
                      color: timerState.isCompleted
                          ? AppColors.success
                          : AppColors.textTertiary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed:
                    timerState.isRunning ? null : timerController.start,
                icon: const Icon(Icons.play_arrow_rounded, size: 20),
                label: const Text('Iniciar'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    timerState.isRunning ? timerController.pause : null,
                icon: const Icon(Icons.pause_rounded, size: 20),
                label: const Text('Pausar'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: const BorderSide(color: AppColors.border),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: timerState.status == TimerStatus.idle
                ? null
                : timerController.reset,
            icon: const Icon(Icons.restart_alt_rounded, size: 20),
            label: const Text('Reiniciar'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
        ],
          ),
        ),
      ],
    );
  }

  String _statusLabel(TimerStatus status) {
    return switch (status) {
      TimerStatus.idle => 'Listo para empezar',
      TimerStatus.running => 'En curso',
      TimerStatus.paused => 'Pausado',
      TimerStatus.completed => 'Completado',
    };
  }
}

class _TimerRing extends StatelessWidget {
  const _TimerRing({
    required this.progress,
    required this.isCompleted,
    required this.child,
  });

  final double progress;
  final bool isCompleted;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: progress),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      builder: (context, value, child) => CustomPaint(
        painter: _TimerRingPainter(
          progress: value,
          isCompleted: isCompleted,
        ),
        child: Center(child: child),
      ),
      child: child,
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  _TimerRingPainter({
    required this.progress,
    required this.isCompleted,
  });

  final double progress;
  final bool isCompleted;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 12) / 2;

    final bgPaint = Paint()
      ..color = AppColors.surfaceElevated
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    if (progress > 0) {
      final arcRect = Rect.fromCircle(center: center, radius: radius);
      final sweepAngle = math.pi * 2 * progress;

      if (progress > 0) {
        final glowPaint = Paint()
          ..shader = LinearGradient(
            colors: isCompleted
                ? [AppColors.success, AppColors.success]
                : [AppColors.primary, AppColors.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ).createShader(Rect.fromCircle(center: center, radius: radius + 6))
          ..style = PaintingStyle.stroke
          ..strokeWidth = 13
          ..strokeCap = StrokeCap.round
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);

        canvas.drawArc(arcRect, -math.pi / 2, sweepAngle, false, glowPaint);
      }

      final fgPaint = Paint()
        ..shader = LinearGradient(
          colors: isCompleted
              ? [AppColors.success, AppColors.success]
              : [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromCircle(center: center, radius: radius + 6))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 10
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        math.pi * 2 * progress,
        false,
        fgPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_TimerRingPainter old) =>
      old.progress != progress || old.isCompleted != isCompleted;
}
