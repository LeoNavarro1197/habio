import 'package:flutter_test/flutter_test.dart';
import 'package:habio/core/utils/date_time_extensions.dart';
import 'package:habio/l10n/app_localizations.dart';

class _TestLocalizations extends AppLocalizations {
  _TestLocalizations() : super('es');

  @override
  String get localeName => 'es';

  @override
  String dateFormat(Object day, Object monthName, Object weekday, Object year) {
    return '$weekday, $day de $monthName';
  }

  @override
  String get greetingMorning => 'Buenos días';
  @override
  String get greetingAfternoon => 'Buenas tardes';
  @override
  String get greetingEvening => 'Buenas noches';

  @override
  String get weekdayMonday => 'lunes';
  @override
  String get weekdayTuesday => 'martes';
  @override
  String get weekdayWednesday => 'miércoles';
  @override
  String get weekdayThursday => 'jueves';
  @override
  String get weekdayFriday => 'viernes';
  @override
  String get weekdaySaturday => 'sábado';
  @override
  String get weekdaySunday => 'domingo';
  @override
  String get weekdayMon => 'lun';
  @override
  String get weekdayTue => 'mar';
  @override
  String get weekdayWed => 'mié';
  @override
  String get weekdayThu => 'jue';
  @override
  String get weekdayFri => 'vie';
  @override
  String get weekdaySat => 'sáb';
  @override
  String get weekdaySun => 'dom';

  @override
  String get monthJanuary => 'enero';
  @override
  String get monthFebruary => 'febrero';
  @override
  String get monthMarch => 'marzo';
  @override
  String get monthApril => 'abril';
  @override
  String get monthMay => 'mayo';
  @override
  String get monthJune => 'junio';
  @override
  String get monthJuly => 'julio';
  @override
  String get monthAugust => 'agosto';
  @override
  String get monthSeptember => 'septiembre';
  @override
  String get monthOctober => 'octubre';
  @override
  String get monthNovember => 'noviembre';
  @override
  String get monthDecember => 'diciembre';

  @override
  String get appName => 'Habio';
  @override
  String get shellTabToday => 'Hoy';
  @override
  String get shellTabHistory => 'Historial';
  @override
  String get shellTabTimer => 'Temporizador';
  @override
  String get shellTabSettings => 'Ajustes';
  @override
  String get shellFabNewHabit => 'Nuevo hábito';
  @override
  String get edit => 'Editar';
  @override
  String get delete => 'Eliminar';
  @override
  String get cancel => 'Cancelar';
  @override
  String get accept => 'Aceptar';
  @override
  String get save => 'Guardar';
  @override
  String get next => 'Siguiente';
  @override
  String get skip => 'Saltar';
  @override
  String get start => 'Iniciar';
  @override
  String get close => 'Cerrar';
  @override
  String get buy => 'Comprar';
  @override
  String get minUnit => 'min';
  @override
  String get custom => 'Personalizado';
  @override
  String get noCategory => 'Sin categoría';
  @override
  String get deletedHabit => 'Hábito eliminado';
  @override
  String get inactive => 'Inactivo';
  @override
  String get today => 'Hoy';
  @override
  String get todayHabitsTitle => 'Hábitos de hoy';
  @override
  String get todayNoHabitsYet => 'Todavía no hay hábitos';
  @override
  String get todayEmptySubtitle => 'Usa el botón + para crear tu primer hábito.';
  @override
  String get todayDailyProgress => 'Progreso diario';
  @override
  String get todayCreateFirstHabit => 'Crea tu primer hábito para empezar.';
  @override
  String get todayCompleted => 'completados';
  @override
  String get todayPending => 'pendientes';
  @override
  String get todayAllDays => 'Todos los días';
  @override
  String get todayNoReminder => 'Sin hora';
  @override
  String get todayDeleteTitle => 'Eliminar hábito';
  @override
  String todayDeleteMessage(Object name) => '¿Quieres eliminar "$name"?';
  @override
  String todayDeletedSnackbar(Object name) => 'Se eliminó "$name".';
  @override
  String get todayLoadErrorHabits => 'No pudimos cargar tus hábitos';
  @override
  String get todayLoadErrorProgress => 'No pudimos cargar el progreso';
  @override
  String get todayLoadErrorCategories => 'No pudimos cargar las categorías';
  @override
  String get habitFormNewTitle => 'Nuevo hábito';
  @override
  String get habitFormEditTitle => 'Editar hábito';
  @override
  String get habitFormSubtitle => 'Configura nombre, frecuencia y recordatorio.';
  @override
  String get habitFormNameLabel => 'Nombre del hábito';
  @override
  String get habitFormNameHint => 'Ej. Estudiar inglés';
  @override
  String get habitFormCategoryLabel => 'Categoría';
  @override
  String get habitFormFrequencyHeader => 'FRECUENCIA';
  @override
  String get habitFormReminderLabel => 'Recordatorio';
  @override
  String get habitFormDurationLabel => 'Duración estimada';
  @override
  String habitFormDurationItem(Object minutes) => '$minutes min';
  @override
  String get habitFormActiveLabel => 'Hábito activo';
  @override
  String get habitFormActiveSubtitle => 'Si lo desactivas, el hábito se pausa y no cuenta en tu progreso.';
  @override
  String get habitFormSaving => 'Guardando...';
  @override
  String get habitFormSaveNew => 'Guardar hábito';
  @override
  String get habitFormSaveEdit => 'Actualizar hábito';
  @override
  String get habitFormNoCategories => 'No hay categorías disponibles.';
  @override
  String habitFormError(Object error) => 'Error: $error';
  @override
  String get habitFormValidateName => 'Escribe un nombre para el hábito.';
  @override
  String get habitFormValidateCategory => 'Selecciona una categoría válida.';
  @override
  String get habitFormValidateDay => 'Selecciona al menos un día.';
  @override
  String get habitFormCreatedSnackbar => 'Hábito creado correctamente.';
  @override
  String get habitFormUpdatedSnackbar => 'Hábito actualizado correctamente.';
  @override
  String get habitFormNoReminder => 'Sin recordatorio';
  @override
  String get habitFormWeekdays => 'Días entre semana';
  @override
  String get habitFormWeekend => 'Fin de semana';
  @override
  String get habitFormCustomDurationTitle => 'Duración personalizada';
  @override
  String get habitFormMinutesLabel => 'Minutos';
  @override
  String get habitFormMinutesHint => 'Ej: 90';
  @override
  String get habitFormValidateNumber => 'Ingresa un número válido';
  @override
  String get historyTitle => 'Historial';
  @override
  String get historyLast30Days => 'Últimos 30 días';
  @override
  String get historyEmptyTitle => 'Aún no hay historial';
  @override
  String get historyEmptySubtitle => 'Completa hábitos o usa el temporizador para ver tu historial.';
  @override
  String get historyLoadError => 'No pudimos cargar el historial';
  @override
  String get historyLoadErrorTimer => 'No pudimos cargar el historial del timer';
  @override
  String get historyLoadErrorHabits => 'No pudimos cargar los hábitos';
  @override
  String get historyLoadErrorCategories => 'No pudimos cargar las categorías';
  @override
  String get historyPendingSection => 'Pendientes';
  @override
  String get historyPendingBadge => 'Pendiente';
  @override
  String get historyTimerSection => 'Sesiones de temporizador';
  @override
  String get historyNoHabits => 'Sin hábitos programados para este día';
  @override
  String get historyDeactivatedHeader => 'Hábitos pausados';
  @override
  String get timerTitle => 'Temporizador';
  @override
  String get timerSubtitle => 'Concentra tu tiempo en una actividad.';
  @override
  String get timerActivityLabel => 'Actividad';
  @override
  String get timerActivityHint => 'Estudio, trabajo, ejercicio...';
  @override
  String get timerDurationHeader => 'DURACIÓN';
  @override
  String get timerStatusIdle => 'Listo para empezar';
  @override
  String get timerStatusRunning => 'En curso';
  @override
  String get timerStatusPaused => 'Pausado';
  @override
  String get timerStatusCompleted => 'Completado';
  @override
  String get timerPause => 'Pausar';
  @override
  String get timerReset => 'Reiniciar';
  @override
  String get timerCompletedSnackbar => 'Sesión completada. Buen trabajo.';
  @override
  String timerCompletedWithActivitySnackbar(Object activity) => 'Sesión completada: $activity';
  @override
  String get timerValidateTime => 'Ingresa un tiempo válido';
  @override
  String get timerCustomDialogTitle => 'Tiempo personalizado';
  @override
  String get timerMinutesLabel => 'Minutos';
  @override
  String get timerMinutesHint => '0';
  @override
  String get timerSecondsLabel => 'Segundos';
  @override
  String get timerSecondsHint => '0';
  @override
  String get settingsTitle => 'Ajustes';
  @override
  String get settingsNotificationsHeader => 'NOTIFICACIONES';
  @override
  String get settingsNotificationsLabel => 'Notificaciones';
  @override
  String get settingsNotificationsSubtitle => 'Recordatorios de hábitos y sesiones';
  @override
  String get settingsAppHeader => 'APP';
  @override
  String get settingsVersionLabel => 'Versión';
  @override
  String get settingsPremiumHeader => 'PREMIUM';
  @override
  String get settingsRestoreLabel => 'Restaurar compras';
  @override
  String get settingsRestoreSubtitle => 'Recupera tu compra premium en este dispositivo';
  @override
  String get settingsRestoredSnackbar => 'Compra restaurada correctamente.';
  @override
  String get settingsPrivacyLabel => 'Política de privacidad';
  @override
  String get settingsPrivacySubtitle => 'Consulta cómo manejamos tus datos';
  @override
  String get settingsPrivacyDialogTitle => 'Política de privacidad';
  @override
  String get settingsPremiumOwnedTitle => 'Anuncios removidos';
  @override
  String get settingsPremiumOwnedSubtitle => 'Gracias por tu compra.';
  @override
  String get settingsPremiumBuyTitle => 'Remover anuncios';
  @override
  String get settingsPremiumBuySubtitle => 'Compra única. Sin suscripciones.';
  @override
  String get settingsPremiumNotAvailable => 'Premium no disponible sin Google Play.';
  @override
  String get onboardingPage1Title => 'Bienvenido a Habio';
  @override
  String get onboardingPage1Desc => 'La forma más simple de crear y mantener hábitos.\nOrganiza tu día, enfócate en lo importante y alcanza tus metas.';
  @override
  String get onboardingPage2Title => 'Crea tus hábitos';
  @override
  String get onboardingPage2Desc => 'Toca el botón "Nuevo hábito" y personaliza cada actividad.\nElige la frecuencia, duración y un recordatorio.';
  @override
  String get onboardingPage3Title => 'Sigue tu progreso';
  @override
  String get onboardingPage3Desc => 'Marca tus hábitos como completados cada día.\nRevisa tu historial y observa cómo avanzas.';
  @override
  String get onboardingPage4Title => 'Temporizador';
  @override
  String get onboardingPage4Desc => 'Usa el temporizador para sesiones de enfoque.\nPerfecto para trabajar, estudiar o meditar.';
  @override
  String get onboardingGetStarted => 'Comenzar';
  @override
  String get onboardingSkip => 'Saltar';
  @override
  String get onboardingNext => 'Siguiente';
  @override
  String get categoryStudy => 'Estudio';
  @override
  String get categoryWork => 'Trabajo';
  @override
  String get categoryHealth => 'Salud';
  @override
  String get categoryPersonal => 'Personal';
  @override
  String get timerDefaultActivity => 'Sesión de enfoque';
  @override
  String get settingsPrivacyContent => 'Política de Privacidad';
  @override
  String get habitFormTimesPerDayLabel => 'Veces por día';
  @override
  String get habitFormIntervalLabel => 'Intervalo entre recordatorios';
  @override
  String habitFormIntervalValue(Object hours) => 'Cada $hours h';
  @override
  String timerDurationMinutes(Object minutes) => '$minutes min';
}

final _l10n = _TestLocalizations();

void main() {
  group('HabioDateTimeX', () {
    group('localizedLongDate', () {
      test('formats correctly', () {
        final date = DateTime(2026, 7, 8);
        expect(date.localizedLongDate(_l10n), 'miércoles, 8 de julio');
      });

      test('returns correct weekday for Monday', () {
        final date = DateTime(2026, 7, 6);
        expect(date.localizedLongDate(_l10n), 'lunes, 6 de julio');
      });

      test('uses correct month name', () {
        final date = DateTime(2026, 1, 1);
        expect(date.localizedLongDate(_l10n), 'jueves, 1 de enero');
      });
    });

    group('localizedGreeting', () {
      test('returns Buenos días before noon', () {
        final morning = DateTime(2026, 7, 8, 9, 0);
        expect(morning.localizedGreeting(_l10n), 'Buenos días');
      });

      test('returns Buenas tardes in afternoon', () {
        final afternoon = DateTime(2026, 7, 8, 15, 0);
        expect(afternoon.localizedGreeting(_l10n), 'Buenas tardes');
      });

      test('returns Buenas noches after 19', () {
        final night = DateTime(2026, 7, 8, 22, 0);
        expect(night.localizedGreeting(_l10n), 'Buenas noches');
      });

      test('boundary at 12', () {
        final noon = DateTime(2026, 7, 8, 12, 0);
        expect(noon.localizedGreeting(_l10n), 'Buenas tardes');
      });

      test('boundary at 19', () {
        final evening = DateTime(2026, 7, 8, 19, 0);
        expect(evening.localizedGreeting(_l10n), 'Buenas noches');
      });
    });
  });
}
