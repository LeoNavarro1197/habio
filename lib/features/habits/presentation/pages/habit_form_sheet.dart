import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_components.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/providers/category_providers.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habit_providers.dart';

Future<void> showHabitFormSheet(
  BuildContext context, {
  HabitEntity? initialHabit,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => HabitFormSheet(initialHabit: initialHabit),
  );
}

class HabitFormSheet extends ConsumerStatefulWidget {
  const HabitFormSheet({this.initialHabit, super.key});

  final HabitEntity? initialHabit;

  @override
  ConsumerState<HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends ConsumerState<HabitFormSheet> {
  late final TextEditingController _nameController;
  late List<int> _selectedWeekdays;
  late int? _reminderMinutes;
  late int? _durationMinutes;
  late bool _isActive;
  String? _selectedCategoryId;
  _FrequencyPreset _frequencyPreset = _FrequencyPreset.everyDay;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final habit = widget.initialHabit;
    _nameController = TextEditingController(text: habit?.name ?? '');
    _selectedWeekdays = List<int>.from(
      habit?.selectedWeekdays ?? _FrequencyPreset.everyDay.days,
    );
    _reminderMinutes = habit?.reminderMinutes;
    _durationMinutes = habit?.durationMinutes ?? 25;
    _isActive = habit?.isActive ?? true;
    _selectedCategoryId = habit?.categoryId;
    _frequencyPreset = _FrequencyPreset.fromWeekdays(_selectedWeekdays);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
        child: categoriesAsync.when(
          data: (categories) {
            if (_selectedCategoryId == null && categories.isNotEmpty) {
              _selectedCategoryId = categories.first.id;
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.initialHabit == null
                              ? 'Nuevo hábito'
                              : 'Editar hábito',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded,
                            color: AppColors.textTertiary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Configura nombre, frecuencia y recordatorio.',
                    style:
                        TextStyle(color: AppColors.textTertiary, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del hábito',
                      hintText: 'Ej. Estudiar inglés',
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    items: categories
                        .map(
                          (category) => DropdownMenuItem<String>(
                            value: category.id,
                            child: Row(
                              children: [
                                Icon(
                                  IconData(category.iconCodePoint,
                                      fontFamily: 'MaterialIcons'),
                                  color: AppColors.categoryColor(category.id),
                                  size: 20,
                                ),
                                const SizedBox(width: 10),
                                Text(category.name,
                                    style: const TextStyle(
                                        color: AppColors.textPrimary)),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategoryId = value);
                    },
                    decoration: const InputDecoration(labelText: 'Categoría'),
                    dropdownColor: AppColors.surface,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'FRECUENCIA',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _FrequencyPreset.values.map((preset) {
                      final selected = _frequencyPreset == preset;
                      return ChoiceChip(
                        label: Text(preset.label),
                        selected: selected,
                        onSelected: (_) {
                          setState(() {
                            _frequencyPreset = preset;
                            if (preset != _FrequencyPreset.custom) {
                              _selectedWeekdays =
                                  List<int>.from(preset.days);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  if (_frequencyPreset == _FrequencyPreset.custom) ...[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(7, (index) {
                        final day = index + 1;
                        final selected = _selectedWeekdays.contains(day);
                        return FilterChip(
                          label: Text(_weekdayLabel(day)),
                          selected: selected,
                          onSelected: (_) {
                            setState(() {
                              if (selected) {
                                _selectedWeekdays.remove(day);
                              } else {
                                _selectedWeekdays.add(day);
                                _selectedWeekdays.sort();
                              }
                            });
                          },
                        );
                      }),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.card,
                          ),
                          child: Column(
                          children: [
                            InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: _selectReminderTime,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                child: Row(
                                  children: [
                                    const Icon(
                                    Icons.notifications_none_rounded,
                                    color: AppColors.textTertiary,
                                    size: 20),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text('Recordatorio',
                                      style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 15)),
                                ),
                                Text(
                                  _formatReminderLabel(_reminderMinutes),
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                if (_reminderMinutes != null) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () =>
                                        setState(() => _reminderMinutes = null),
                                    child: const Icon(Icons.close_rounded,
                                        color: AppColors.textTertiary,
                                        size: 18),
                                  ),
                                ],
                                const SizedBox(width: 4),
                                const Icon(Icons.chevron_right_rounded,
                                    color: AppColors.textTertiary, size: 20),
                              ],
                            ),
                          ),
                        ),
                        Container(height: 1, color: AppColors.divider),
                        DropdownButtonFormField<int>(
                          value: _durationMinutes,
                          items: const [5, 10, 15, 20, 25, 30, 45, 60]
                              .map(
                                (minutes) => DropdownMenuItem<int>(
                                  value: minutes,
                                  child: Text('$minutes min'),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() => _durationMinutes = value);
                          },
                          decoration: const InputDecoration(
                            labelText: 'Duración estimada',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                          ),
                          dropdownColor: AppColors.surface,
                        ),
                        Container(height: 1, color: AppColors.divider),
                        SwitchListTile(
                          value: _isActive,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          onChanged: (value) {
                            setState(() => _isActive = value);
                          },
                          title: const Text('Hábito activo',
                              style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15)),
                          subtitle: const Text(
                            'Si lo desactivas, el hábito se pausa y no cuenta en tu progreso.',
                            style: TextStyle(
                                color: AppColors.textTertiary, fontSize: 12),
                          ),
                        ),
                            ],
                            ),
                          ),
                          Positioned.fill(
                            child: IgnorePointer(
                              child: CustomPaint(
                                painter: GradientBorderPainter(
                                   radius: 8,
                                  borderWidth: 1,
                                  gradient: const LinearGradient(
                                    colors: [AppColors.border, AppColors.border],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isSaving || categories.isEmpty
                          ? null
                          : () => _save(categories),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _isSaving
                            ? 'Guardando...'
                            : widget.initialHabit == null
                                ? 'Guardar hábito'
                                : 'Actualizar hábito',
                      ),
                    ),
                  ),
                  if (categories.isEmpty) ...[
                    const SizedBox(height: 12),
                    const Text(
                      'No hay categorías disponibles.',
                      style: TextStyle(
                          color: AppColors.textTertiary, fontSize: 13),
                    ),
                  ],
                ],
              ),
            );
          },
          error: (error, _) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Text('Error: $error',
                style: const TextStyle(color: AppColors.error)),
          ),
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(vertical: 48),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }

  Future<void> _selectReminderTime() async {
    final initialMinutes = _reminderMinutes ?? (8 * 60);
    final initialTime = TimeOfDay(
      hour: initialMinutes ~/ 60,
      minute: initialMinutes % 60,
    );
    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
                surface: AppColors.surface,
                onSurface: AppColors.textPrimary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked == null) return;
    setState(() {
      _reminderMinutes = picked.hour * 60 + picked.minute;
    });
  }

  Future<void> _save(List<CategoryEntity> categories) async {
    final selectedWeekdays = _frequencyPreset == _FrequencyPreset.custom
        ? _selectedWeekdays
        : _frequencyPreset.days;

    if (_nameController.text.trim().isEmpty) {
      _showMessage('Escribe un nombre para el hábito.');
      return;
    }
    if (_selectedCategoryId == null ||
        categories.every((item) => item.id != _selectedCategoryId)) {
      _showMessage('Selecciona una categoría válida.');
      return;
    }
    if (selectedWeekdays.isEmpty) {
      _showMessage('Selecciona al menos un día.');
      return;
    }

    setState(() => _isSaving = true);

    try {
      await ref.read(habitActionsProvider).saveHabit(
            existingHabit: widget.initialHabit,
            name: _nameController.text,
            categoryId: _selectedCategoryId!,
            selectedWeekdays: selectedWeekdays,
            reminderMinutes: _reminderMinutes,
            durationMinutes: _durationMinutes,
            isActive: _isActive,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialHabit == null
                ? 'Hábito creado correctamente.'
                : 'Hábito actualizado correctamente.',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  String _formatReminderLabel(int? minutes) {
    if (minutes == null) return 'Sin recordatorio';
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _weekdayLabel(int weekday) {
    const labels = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    return labels[weekday - 1];
  }
}

enum _FrequencyPreset {
  everyDay('Todos los días', [1, 2, 3, 4, 5, 6, 7]),
  weekdays('Días entre semana', [1, 2, 3, 4, 5]),
  weekends('Fin de semana', [6, 7]),
  custom('Personalizado', []);

  const _FrequencyPreset(this.label, this.days);

  final String label;
  final List<int> days;

  static _FrequencyPreset fromWeekdays(List<int> weekdays) {
    final normalized = List<int>.from(weekdays)..sort();
    for (final preset in values.where((item) => item != custom)) {
      if (_sameList(normalized, preset.days)) return preset;
    }
    return custom;
  }

  static bool _sameList(List<int> left, List<int> right) {
    if (left.length != right.length) return false;
    for (var i = 0; i < left.length; i++) {
      if (left[i] != right[i]) return false;
    }
    return true;
  }
}
