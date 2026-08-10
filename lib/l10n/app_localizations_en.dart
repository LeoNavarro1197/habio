// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Habio';

  @override
  String get shellTabToday => 'Today';

  @override
  String get shellTabHistory => 'History';

  @override
  String get shellTabTimer => 'Timer';

  @override
  String get shellTabSettings => 'Settings';

  @override
  String get shellFabNewHabit => 'New habit';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get accept => 'Accept';

  @override
  String get save => 'Save';

  @override
  String get next => 'Next';

  @override
  String get skip => 'Skip';

  @override
  String get start => 'Start';

  @override
  String get close => 'Close';

  @override
  String get buy => 'Buy';

  @override
  String get minUnit => 'min';

  @override
  String get custom => 'Custom';

  @override
  String get noCategory => 'No category';

  @override
  String get deletedHabit => 'Deleted habit';

  @override
  String get inactive => 'Inactive';

  @override
  String dateFormat(Object day, Object monthName, Object weekday, Object year) {
    return '$weekday, $monthName $day, $year';
  }

  @override
  String get today => 'Today';

  @override
  String get greetingMorning => 'Good morning';

  @override
  String get greetingAfternoon => 'Good afternoon';

  @override
  String get greetingEvening => 'Good evening';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get weekdayMon => 'Mon';

  @override
  String get weekdayTue => 'Tue';

  @override
  String get weekdayWed => 'Wed';

  @override
  String get weekdayThu => 'Thu';

  @override
  String get weekdayFri => 'Fri';

  @override
  String get weekdaySat => 'Sat';

  @override
  String get weekdaySun => 'Sun';

  @override
  String get monthJanuary => 'January';

  @override
  String get monthFebruary => 'February';

  @override
  String get monthMarch => 'March';

  @override
  String get monthApril => 'April';

  @override
  String get monthMay => 'May';

  @override
  String get monthJune => 'June';

  @override
  String get monthJuly => 'July';

  @override
  String get monthAugust => 'August';

  @override
  String get monthSeptember => 'September';

  @override
  String get monthOctober => 'October';

  @override
  String get monthNovember => 'November';

  @override
  String get monthDecember => 'December';

  @override
  String get categoryStudy => 'Study';

  @override
  String get categoryWork => 'Work';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryPersonal => 'Personal';

  @override
  String get todayHabitsTitle => 'Today’s habits';

  @override
  String get todayNoHabitsYet => 'No habits yet';

  @override
  String get todayEmptySubtitle =>
      'Use the + button to create your first habit.';

  @override
  String get todayDailyProgress => 'Daily progress';

  @override
  String get todayCreateFirstHabit => 'Create your first habit to get started.';

  @override
  String get todayCompleted => 'completed';

  @override
  String get todayPending => 'pending';

  @override
  String get todayAllDays => 'Every day';

  @override
  String get todayNoReminder => 'No reminder';

  @override
  String get todayDeleteTitle => 'Delete habit';

  @override
  String todayDeleteMessage(Object name) {
    return 'Are you sure you want to delete \"$name\"?';
  }

  @override
  String todayDeletedSnackbar(Object name) {
    return 'Deleted \"$name\".';
  }

  @override
  String get todayLoadErrorHabits => 'Could not load your habits';

  @override
  String get todayLoadErrorProgress => 'Could not load progress';

  @override
  String get todayLoadErrorCategories => 'Could not load categories';

  @override
  String get habitFormNewTitle => 'New habit';

  @override
  String get habitFormEditTitle => 'Edit habit';

  @override
  String get habitFormSubtitle => 'Set the name, frequency and reminder.';

  @override
  String get habitFormNameLabel => 'Habit name';

  @override
  String get habitFormNameHint => 'E.g. Study English';

  @override
  String get habitFormCategoryLabel => 'Category';

  @override
  String get habitFormFrequencyHeader => 'FREQUENCY';

  @override
  String get habitFormReminderLabel => 'Reminder';

  @override
  String get habitFormDurationLabel => 'Estimated duration';

  @override
  String habitFormDurationItem(Object minutes) {
    return '$minutes min';
  }

  @override
  String get habitFormTimesPerDayLabel => 'Times per day';

  @override
  String get habitFormIntervalLabel => 'Reminder interval';

  @override
  String habitFormIntervalValue(Object hours) {
    return 'Every $hours h';
  }

  @override
  String get habitFormActiveLabel => 'Active habit';

  @override
  String get habitFormActiveSubtitle =>
      'If you deactivate it, the habit pauses and won’t count toward your progress.';

  @override
  String get habitFormSaving => 'Saving...';

  @override
  String get habitFormSaveNew => 'Save habit';

  @override
  String get habitFormSaveEdit => 'Update habit';

  @override
  String get habitFormNoCategories => 'No categories available.';

  @override
  String habitFormError(Object error) {
    return 'Error: $error';
  }

  @override
  String get habitFormValidateName => 'Enter a name for the habit.';

  @override
  String get habitFormValidateCategory => 'Select a valid category.';

  @override
  String get habitFormValidateDay => 'Select at least one day.';

  @override
  String get habitFormCreatedSnackbar => 'Habit created successfully.';

  @override
  String get habitFormUpdatedSnackbar => 'Habit updated successfully.';

  @override
  String get habitFormNoReminder => 'No reminder';

  @override
  String get habitFormWeekdays => 'Weekdays';

  @override
  String get habitFormWeekend => 'Weekend';

  @override
  String get habitFormCustomDurationTitle => 'Custom duration';

  @override
  String get habitFormMinutesLabel => 'Minutes';

  @override
  String get habitFormMinutesHint => 'E.g. 90';

  @override
  String get habitFormValidateNumber => 'Enter a valid number';

  @override
  String get historyTitle => 'History';

  @override
  String get historyLast30Days => 'Last 30 days';

  @override
  String get historyEmptyTitle => 'No history yet';

  @override
  String get historyEmptySubtitle =>
      'Complete habits or use the timer to see your history.';

  @override
  String get historyLoadError => 'Could not load history';

  @override
  String get historyLoadErrorTimer => 'Could not load timer history';

  @override
  String get historyLoadErrorHabits => 'Could not load habits';

  @override
  String get historyLoadErrorCategories => 'Could not load categories';

  @override
  String get historyPendingSection => 'Pending';

  @override
  String get historyPendingBadge => 'Pending';

  @override
  String get historyTimerSection => 'Timer sessions';

  @override
  String get historyNoHabits => 'No habits scheduled for this day';

  @override
  String get historyDeactivatedHeader => 'Paused habits';

  @override
  String get timerTitle => 'Timer';

  @override
  String get timerSubtitle => 'Focus your time on one activity.';

  @override
  String get timerActivityLabel => 'Activity';

  @override
  String get timerActivityHint => 'Study, work, exercise...';

  @override
  String get timerDefaultActivity => 'Focus session';

  @override
  String get timerDurationHeader => 'DURATION';

  @override
  String get timerStatusIdle => 'Ready to start';

  @override
  String get timerStatusRunning => 'Running';

  @override
  String get timerStatusPaused => 'Paused';

  @override
  String get timerStatusCompleted => 'Completed';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerReset => 'Reset';

  @override
  String get timerCompletedSnackbar => 'Session completed. Great job!';

  @override
  String timerCompletedWithActivitySnackbar(Object activity) {
    return 'Session completed: $activity';
  }

  @override
  String get timerValidateTime => 'Enter a valid time';

  @override
  String get timerCustomDialogTitle => 'Custom time';

  @override
  String get timerMinutesLabel => 'Minutes';

  @override
  String get timerMinutesHint => '0';

  @override
  String get timerSecondsLabel => 'Seconds';

  @override
  String get timerSecondsHint => '0';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsNotificationsHeader => 'NOTIFICATIONS';

  @override
  String get settingsNotificationsLabel => 'Notifications';

  @override
  String get settingsNotificationsSubtitle => 'Habit and session reminders';

  @override
  String get settingsAppHeader => 'APP';

  @override
  String get settingsVersionLabel => 'Version';

  @override
  String get settingsPremiumHeader => 'PREMIUM';

  @override
  String get settingsRestoreLabel => 'Restore purchases';

  @override
  String get settingsRestoreSubtitle =>
      'Restore your premium purchase on this device';

  @override
  String get settingsRestoredSnackbar => 'Purchase restored successfully.';

  @override
  String get settingsPrivacyLabel => 'Privacy policy';

  @override
  String get settingsPrivacySubtitle => 'See how we handle your data';

  @override
  String get settingsPrivacyDialogTitle => 'Privacy policy';

  @override
  String get settingsPremiumOwnedTitle => 'Ads removed';

  @override
  String get settingsPremiumOwnedSubtitle => 'Thank you for your purchase.';

  @override
  String get settingsPremiumBuyTitle => 'Remove ads';

  @override
  String get settingsPremiumBuySubtitle =>
      'One-time purchase. No subscriptions.';

  @override
  String get settingsPremiumNotAvailable =>
      'Premium not available without Google Play.';

  @override
  String get settingsPrivacyContent =>
      'Habio Privacy Policy\n\nLast updated: July 7, 2026\n\nThis Privacy Policy describes how the Habio application (\"the App\") collects, uses and protects user information.\n\nThe App is developed and published by Gas Station (\"we\", \"our\" or \"the developer\").\n\n1. Information we collect\n\nHabio is designed to help users create habits and track their daily tasks.\n\nThe App does not collect, store or transmit personal information to our servers. Habit, task and progress data is stored only on the user’s device.\n\n2. Locally stored data\n\nThe App may store the following information exclusively on the user’s device:\n\nHabits and tasks created by the user.\nApp settings and preferences.\nProgress and statistics related to habits.\n\nThis data is not sent to our servers nor shared with third parties.\n\n3. Advertising\n\nHabio displays ads through Google AdMob, an advertising service provided by Google.\n\nGoogle AdMob may collect certain device data, such as advertising identifiers and usage information, to show relevant ads and measure their performance. The processing of this data is subject to Google’s privacy policies.\n\nYou can learn more about how Google uses data from its services at:\n\nhttps://policies.google.com/privacy\n\n4. In-app purchases\n\nThe App offers an optional purchase to remove ads.\n\nIn-app purchases are processed by Google Play. We do not collect or store payment information, credit card numbers, or financial data from users.\n\n5. App permissions\n\nHabio may request the notification permission to send reminders related to habits and tasks created by the user.\n\nNotifications are used solely for the functioning of the App and do not involve the collection of personal information.\n\n6. Minors\n\nHabio is aimed at the general public and may be used by people of all ages.\n\nThe App does not deliberately collect personal information from minors.\n\n7. Information security\n\nBecause the App’s information is stored locally on the user’s device, the user is responsible for protecting access to their device through passwords, biometric methods or other available security measures.\n\n8. Changes to this Privacy Policy\n\nWe may update this Privacy Policy occasionally. Any changes will be posted on this same page and the \"Last updated\" date will be modified accordingly.\n\n9. Contact\n\nIf you have questions about this Privacy Policy, you can contact us at the following email:\n\nGas Station\nEmail: jumpjumpranking@gmail.com';

  @override
  String get onboardingPage1Title => 'Welcome to Habio';

  @override
  String get onboardingPage1Desc =>
      'The simplest way to create and maintain habits.\nOrganize your day, focus on what matters and reach your goals.';

  @override
  String get onboardingPage2Title => 'Create your habits';

  @override
  String get onboardingPage2Desc =>
      'Tap the \"New habit\" button and customize each activity.\nChoose the frequency, duration and a reminder.';

  @override
  String get onboardingPage3Title => 'Track your progress';

  @override
  String get onboardingPage3Desc =>
      'Mark your habits as completed each day.\nCheck your history and watch your progress.';

  @override
  String get onboardingPage4Title => 'Timer';

  @override
  String get onboardingPage4Desc =>
      'Use the timer for focus sessions.\nPerfect for studying, working or meditating.';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingSkip => 'Skip';

  @override
  String get onboardingNext => 'Next';

  @override
  String timerDurationMinutes(Object minutes) {
    return '$minutes min';
  }
}
