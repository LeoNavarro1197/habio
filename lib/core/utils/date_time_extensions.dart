import '../../l10n/app_localizations.dart';

extension HabioDateTimeX on DateTime {
  String localizedLongDate(AppLocalizations l10n) {
    final weekdayName = _localizedWeekday(l10n);
    final monthName = _localizedMonth(l10n);
    return l10n.dateFormat(
      day.toString(),
      monthName,
      weekdayName,
      year.toString(),
    );
  }

  String _localizedWeekday(AppLocalizations l10n) {
    switch (weekday) {
      case DateTime.monday:    return l10n.weekdayMonday;
      case DateTime.tuesday:   return l10n.weekdayTuesday;
      case DateTime.wednesday: return l10n.weekdayWednesday;
      case DateTime.thursday:  return l10n.weekdayThursday;
      case DateTime.friday:    return l10n.weekdayFriday;
      case DateTime.saturday:  return l10n.weekdaySaturday;
      default:                 return l10n.weekdaySunday;
    }
  }

  String _localizedMonth(AppLocalizations l10n) {
    switch (month) {
      case 1:  return l10n.monthJanuary;
      case 2:  return l10n.monthFebruary;
      case 3:  return l10n.monthMarch;
      case 4:  return l10n.monthApril;
      case 5:  return l10n.monthMay;
      case 6:  return l10n.monthJune;
      case 7:  return l10n.monthJuly;
      case 8:  return l10n.monthAugust;
      case 9:  return l10n.monthSeptember;
      case 10: return l10n.monthOctober;
      case 11: return l10n.monthNovember;
      default: return l10n.monthDecember;
    }
  }

  String localizedGreeting(AppLocalizations l10n) {
    if (hour < 12) return l10n.greetingMorning;
    if (hour < 19) return l10n.greetingAfternoon;
    return l10n.greetingEvening;
  }
}
