import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/services/form_state_provider.dart';
import '../../../../core/services/sound_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_components.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../categories/presentation/providers/category_providers.dart';
import '../../domain/entities/habit_entity.dart';
import '../providers/habit_providers.dart';

Future<void> showHabitFormSheet(
  BuildContext context, {
  HabitEntity? initialHabit,
}) {
  final container = ProviderScope.containerOf(context, listen: false);
  container.read(isFormOpenProvider.notifier).state = true;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (context) => HabitFormSheet(initialHabit: initialHabit),
  ).whenComplete(() {
    container.read(isFormOpenProvider.notifier).state = false;
  });
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
  late int _timesPerDay;
  late int _reminderIntervalHours;
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
    _timesPerDay = habit?.timesPerDay ?? 1;
    _reminderIntervalHours =
        (habit?.reminderIntervalMinutes ?? 120) ~/ 60;
    _isActive = habit?.isActive ?? true;
    _selectedCategoryId = habit?.categoryId;
    _frequencyPreset = _FrequencyPreset.fromWeekdays(_selectedWeekdays);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  static const _presetDurationItems = [5, 10, 15, 20, 25, 30, 45, 60];

  Future<void> _showCustomDuration() async {
    final minutes = await showDialog<int>(
      context: context,
      builder: (ctx) => const _DurationPickerDialog(),
    );
    if (minutes != null && minutes > 0) {
      setState(() => _durationMinutes = minutes);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                              ? l10n.habitFormNewTitle
                              : l10n.habitFormEditTitle,
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
                  Text(
                    l10n.habitFormSubtitle,
                    style:
                        TextStyle(color: AppColors.textTertiary, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _nameController,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: l10n.habitFormNameLabel,
                      hintText: l10n.habitFormNameHint,
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
                                  Text(
                                    _localizedCategoryName(l10n, category),
                                    style: const TextStyle(
                                        color: AppColors.textPrimary),
                                  ),
                                ],
                              ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() => _selectedCategoryId = value);
                    },
                    decoration: InputDecoration(labelText: l10n.habitFormCategoryLabel),
                    dropdownColor: AppColors.surface,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.habitFormFrequencyHeader,
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
                        label: Text(preset.label(l10n)),
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
                          label: Text(_weekdayLabel(l10n, day)),
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
                                Expanded(
                                  child: Text(l10n.habitFormReminderLabel,
                                      style: TextStyle(
                                          color: AppColors.textPrimary,
                                          fontSize: 15)),
                                ),
                                  Text(
                                    _formatReminderLabel(l10n, _reminderMinutes),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Row(
                            children: [
                              const Icon(Icons.repeat_rounded,
                                  color: AppColors.textTertiary, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.habitFormTimesPerDayLabel,
                                  style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15),
                                ),
                              ),
                              IconButton(
                                onPressed: _timesPerDay > 1
                                    ? () => setState(() => _timesPerDay--)
                                    : null,
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.remove_circle_outline_rounded,
                                    color: AppColors.textSecondary, size: 22),
                              ),
                              SizedBox(
                                width: 28,
                                child: Text(
                                  '$_timesPerDay',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              IconButton(
                                onPressed: _timesPerDay < 50
                                    ? () => setState(() => _timesPerDay++)
                                    : null,
                                visualDensity: VisualDensity.compact,
                                icon: const Icon(Icons.add_circle_outline_rounded,
                                    color: AppColors.textSecondary, size: 22),
                              ),
                            ],
                          ),
                        ),
                        if (_timesPerDay > 1) ...[
                          Container(height: 1, color: AppColors.divider),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: [
                                const Icon(Icons.schedule_rounded,
                                    color: AppColors.textTertiary, size: 20),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    l10n.habitFormIntervalLabel,
                                    style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 15),
                                  ),
                                ),
                                Text(
                                  l10n.habitFormIntervalValue('$_reminderIntervalHours'),
                                  style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14),
                                ),
                                const SizedBox(width: 8),
                                IconButton(
                                  onPressed: _reminderIntervalHours > 1
                                      ? () => setState(
                                          () => _reminderIntervalHours--)
                                      : null,
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                      Icons.remove_circle_outline_rounded,
                                      color: AppColors.textSecondary,
                                      size: 22),
                                ),
                                SizedBox(
                                  width: 28,
                                  child: Text(
                                    '$_reminderIntervalHours',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                IconButton(
                                  onPressed: _reminderIntervalHours < 12
                                      ? () => setState(
                                          () => _reminderIntervalHours++)
                                      : null,
                                  visualDensity: VisualDensity.compact,
                                  icon: const Icon(
                                      Icons.add_circle_outline_rounded,
                                      color: AppColors.textSecondary,
                                      size: 22),
                                ),
                              ],
                            ),
                          ),
                        ],
                        Container(height: 1, color: AppColors.divider),
                        DropdownButtonFormField<int>(
                          value: _presetDurationItems
                                  .contains(_durationMinutes)
                              ? _durationMinutes
                              : -1,
                          items: [
                            ..._presetDurationItems.map(
                              (minutes) => DropdownMenuItem<int>(
                                value: minutes,
                                child: Text('$minutes ${l10n.minUnit}'),
                              ),
                            ),
                            DropdownMenuItem<int>(
                              value: -1,
                              child: Text(l10n.custom),
                            ),
                          ],
                          onChanged: (value) {
                            if (value == -1) {
                              _showCustomDuration();
                            } else {
                              setState(() => _durationMinutes = value);
                            }
                          },
                          decoration: InputDecoration(
                            labelText: _durationMinutes != null &&
                                    !_presetDurationItems
                                        .contains(_durationMinutes)
                                ? '${l10n.habitFormDurationLabel} ($_durationMinutes ${l10n.minUnit})'
                                : l10n.habitFormDurationLabel,
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
                          title: Text(l10n.habitFormActiveLabel,
                              style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 15)),
                          subtitle: Text(
                            l10n.habitFormActiveSubtitle,
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
                            ? l10n.habitFormSaving
                            : widget.initialHabit == null
                                ? l10n.habitFormSaveNew
                                : l10n.habitFormSaveEdit,
                      ),
                    ),
                  ),
                  if (categories.isEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.habitFormNoCategories,
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
            child: Text(l10n.habitFormError(error.toString()),
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
    final l10n = AppLocalizations.of(context)!;
    final selectedWeekdays = _frequencyPreset == _FrequencyPreset.custom
        ? _selectedWeekdays
        : _frequencyPreset.days;

    if (_nameController.text.trim().isEmpty) {
      _showMessage(l10n.habitFormValidateName);
      return;
    }
    if (_selectedCategoryId == null ||
        categories.every((item) => item.id != _selectedCategoryId)) {
      _showMessage(l10n.habitFormValidateCategory);
      return;
    }
    if (selectedWeekdays.isEmpty) {
      _showMessage(l10n.habitFormValidateDay);
      return;
    }

    ref.read(soundServiceProvider).playClick();

    setState(() => _isSaving = true);

    try {
      await ref.read(habitActionsProvider).saveHabit(
            existingHabit: widget.initialHabit,
            name: _nameController.text,
            categoryId: _selectedCategoryId!,
            selectedWeekdays: selectedWeekdays,
            reminderMinutes: _reminderMinutes,
            reminderIntervalMinutes:
                _timesPerDay > 1 ? _reminderIntervalHours * 60 : null,
            durationMinutes: _durationMinutes,
            timesPerDay: _timesPerDay,
            isActive: _isActive,
          );
      if (!mounted) return;
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.initialHabit == null
                ? l10n.habitFormCreatedSnackbar
                : l10n.habitFormUpdatedSnackbar,
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

  String _formatReminderLabel(AppLocalizations l10n, int? minutes) {
    if (minutes == null) return l10n.habitFormNoReminder;
    final hour = (minutes ~/ 60).toString().padLeft(2, '0');
    final minute = (minutes % 60).toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String _localizedCategoryName(AppLocalizations l10n, CategoryEntity category) {
    switch (category.id) {
      case 'study':   return l10n.categoryStudy;
      case 'work':    return l10n.categoryWork;
      case 'health':  return l10n.categoryHealth;
      case 'personal': return l10n.categoryPersonal;
      default:        return category.name;
    }
  }

  String _weekdayLabel(AppLocalizations l10n, int weekday) {
    final labels = [
      l10n.weekdayMon, l10n.weekdayTue, l10n.weekdayWed,
      l10n.weekdayThu, l10n.weekdayFri, l10n.weekdaySat, l10n.weekdaySun,
    ];
    return labels[weekday - 1];
  }
}

enum _FrequencyPreset {
  everyDay([1, 2, 3, 4, 5, 6, 7]),
  weekdays([1, 2, 3, 4, 5]),
  weekends([6, 7]),
  custom([]);

  const _FrequencyPreset(this.days);

  final List<int> days;

  String label(AppLocalizations l10n) {
    switch (this) {
      case _FrequencyPreset.everyDay: return l10n.todayAllDays;
      case _FrequencyPreset.weekdays: return l10n.habitFormWeekdays;
      case _FrequencyPreset.weekends: return l10n.habitFormWeekend;
      case _FrequencyPreset.custom:   return l10n.custom;
    }
  }

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

class _DurationPickerDialog extends StatefulWidget {
  const _DurationPickerDialog();

  @override
  State<_DurationPickerDialog> createState() => _DurationPickerDialogState();
}

class _DurationPickerDialogState extends State<_DurationPickerDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    final value = int.tryParse(_controller.text);
    if (value == null || value < 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.habitFormValidateNumber)),
      );
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      backgroundColor: AppColors.surface,
      title: Text(l10n.habitFormCustomDurationTitle),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(
          labelText: l10n.habitFormMinutesLabel,
          hintText: l10n.habitFormMinutesHint,
          border: const OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.accept),
        ),
      ],
    );
  }
}
