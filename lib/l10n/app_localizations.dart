import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('es'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Habio'**
  String get appName;

  /// No description provided for @shellTabToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get shellTabToday;

  /// No description provided for @shellTabHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get shellTabHistory;

  /// No description provided for @shellTabTimer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get shellTabTimer;

  /// No description provided for @shellTabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get shellTabSettings;

  /// No description provided for @shellFabNewHabit.
  ///
  /// In en, this message translates to:
  /// **'New habit'**
  String get shellFabNewHabit;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @accept.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get accept;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @minUnit.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minUnit;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get noCategory;

  /// No description provided for @deletedHabit.
  ///
  /// In en, this message translates to:
  /// **'Deleted habit'**
  String get deletedHabit;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @dateFormat.
  ///
  /// In en, this message translates to:
  /// **'{weekday}, {monthName} {day}, {year}'**
  String dateFormat(Object day, Object monthName, Object weekday, Object year);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening'**
  String get greetingEvening;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @weekdayMon.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get weekdayMon;

  /// No description provided for @weekdayTue.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get weekdayTue;

  /// No description provided for @weekdayWed.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get weekdayWed;

  /// No description provided for @weekdayThu.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get weekdayThu;

  /// No description provided for @weekdayFri.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get weekdayFri;

  /// No description provided for @weekdaySat.
  ///
  /// In en, this message translates to:
  /// **'Sat'**
  String get weekdaySat;

  /// No description provided for @weekdaySun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get weekdaySun;

  /// No description provided for @monthJanuary.
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get monthJanuary;

  /// No description provided for @monthFebruary.
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get monthFebruary;

  /// No description provided for @monthMarch.
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get monthMarch;

  /// No description provided for @monthApril.
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get monthApril;

  /// No description provided for @monthMay.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get monthMay;

  /// No description provided for @monthJune.
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get monthJune;

  /// No description provided for @monthJuly.
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get monthJuly;

  /// No description provided for @monthAugust.
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get monthAugust;

  /// No description provided for @monthSeptember.
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get monthSeptember;

  /// No description provided for @monthOctober.
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get monthOctober;

  /// No description provided for @monthNovember.
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get monthNovember;

  /// No description provided for @monthDecember.
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get monthDecember;

  /// No description provided for @categoryStudy.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get categoryStudy;

  /// No description provided for @categoryWork.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get categoryWork;

  /// No description provided for @categoryHealth.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get categoryHealth;

  /// No description provided for @categoryPersonal.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get categoryPersonal;

  /// No description provided for @todayHabitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Today’s habits'**
  String get todayHabitsTitle;

  /// No description provided for @todayNoHabitsYet.
  ///
  /// In en, this message translates to:
  /// **'No habits yet'**
  String get todayNoHabitsYet;

  /// No description provided for @todayEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use the + button to create your first habit.'**
  String get todayEmptySubtitle;

  /// No description provided for @todayDailyProgress.
  ///
  /// In en, this message translates to:
  /// **'Daily progress'**
  String get todayDailyProgress;

  /// No description provided for @todayCreateFirstHabit.
  ///
  /// In en, this message translates to:
  /// **'Create your first habit to get started.'**
  String get todayCreateFirstHabit;

  /// No description provided for @todayCompleted.
  ///
  /// In en, this message translates to:
  /// **'completed'**
  String get todayCompleted;

  /// No description provided for @todayPending.
  ///
  /// In en, this message translates to:
  /// **'pending'**
  String get todayPending;

  /// No description provided for @todayAllDays.
  ///
  /// In en, this message translates to:
  /// **'Every day'**
  String get todayAllDays;

  /// No description provided for @todayNoReminder.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get todayNoReminder;

  /// No description provided for @todayDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete habit'**
  String get todayDeleteTitle;

  /// No description provided for @todayDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete \"{name}\"?'**
  String todayDeleteMessage(Object name);

  /// No description provided for @todayDeletedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Deleted \"{name}\".'**
  String todayDeletedSnackbar(Object name);

  /// No description provided for @todayLoadErrorHabits.
  ///
  /// In en, this message translates to:
  /// **'Could not load your habits'**
  String get todayLoadErrorHabits;

  /// No description provided for @todayLoadErrorProgress.
  ///
  /// In en, this message translates to:
  /// **'Could not load progress'**
  String get todayLoadErrorProgress;

  /// No description provided for @todayLoadErrorCategories.
  ///
  /// In en, this message translates to:
  /// **'Could not load categories'**
  String get todayLoadErrorCategories;

  /// No description provided for @habitFormNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New habit'**
  String get habitFormNewTitle;

  /// No description provided for @habitFormEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit habit'**
  String get habitFormEditTitle;

  /// No description provided for @habitFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set the name, frequency and reminder.'**
  String get habitFormSubtitle;

  /// No description provided for @habitFormNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Habit name'**
  String get habitFormNameLabel;

  /// No description provided for @habitFormNameHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. Study English'**
  String get habitFormNameHint;

  /// No description provided for @habitFormCategoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get habitFormCategoryLabel;

  /// No description provided for @habitFormFrequencyHeader.
  ///
  /// In en, this message translates to:
  /// **'FREQUENCY'**
  String get habitFormFrequencyHeader;

  /// No description provided for @habitFormReminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get habitFormReminderLabel;

  /// No description provided for @habitFormDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Estimated duration'**
  String get habitFormDurationLabel;

  /// No description provided for @habitFormDurationItem.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String habitFormDurationItem(Object minutes);

  /// No description provided for @habitFormTimesPerDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Times per day'**
  String get habitFormTimesPerDayLabel;

  /// No description provided for @habitFormIntervalLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder interval'**
  String get habitFormIntervalLabel;

  /// No description provided for @habitFormIntervalValue.
  ///
  /// In en, this message translates to:
  /// **'Every {hours} h'**
  String habitFormIntervalValue(Object hours);

  /// No description provided for @habitFormActiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Active habit'**
  String get habitFormActiveLabel;

  /// No description provided for @habitFormActiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If you deactivate it, the habit pauses and won’t count toward your progress.'**
  String get habitFormActiveSubtitle;

  /// No description provided for @habitFormSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving...'**
  String get habitFormSaving;

  /// No description provided for @habitFormSaveNew.
  ///
  /// In en, this message translates to:
  /// **'Save habit'**
  String get habitFormSaveNew;

  /// No description provided for @habitFormSaveEdit.
  ///
  /// In en, this message translates to:
  /// **'Update habit'**
  String get habitFormSaveEdit;

  /// No description provided for @habitFormNoCategories.
  ///
  /// In en, this message translates to:
  /// **'No categories available.'**
  String get habitFormNoCategories;

  /// No description provided for @habitFormError.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String habitFormError(Object error);

  /// No description provided for @habitFormValidateName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name for the habit.'**
  String get habitFormValidateName;

  /// No description provided for @habitFormValidateCategory.
  ///
  /// In en, this message translates to:
  /// **'Select a valid category.'**
  String get habitFormValidateCategory;

  /// No description provided for @habitFormValidateDay.
  ///
  /// In en, this message translates to:
  /// **'Select at least one day.'**
  String get habitFormValidateDay;

  /// No description provided for @habitFormCreatedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Habit created successfully.'**
  String get habitFormCreatedSnackbar;

  /// No description provided for @habitFormUpdatedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Habit updated successfully.'**
  String get habitFormUpdatedSnackbar;

  /// No description provided for @habitFormNoReminder.
  ///
  /// In en, this message translates to:
  /// **'No reminder'**
  String get habitFormNoReminder;

  /// No description provided for @habitFormWeekdays.
  ///
  /// In en, this message translates to:
  /// **'Weekdays'**
  String get habitFormWeekdays;

  /// No description provided for @habitFormWeekend.
  ///
  /// In en, this message translates to:
  /// **'Weekend'**
  String get habitFormWeekend;

  /// No description provided for @habitFormCustomDurationTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom duration'**
  String get habitFormCustomDurationTitle;

  /// No description provided for @habitFormMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get habitFormMinutesLabel;

  /// No description provided for @habitFormMinutesHint.
  ///
  /// In en, this message translates to:
  /// **'E.g. 90'**
  String get habitFormMinutesHint;

  /// No description provided for @habitFormValidateNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get habitFormValidateNumber;

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get historyTitle;

  /// No description provided for @historyLast30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get historyLast30Days;

  /// No description provided for @historyEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No history yet'**
  String get historyEmptyTitle;

  /// No description provided for @historyEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complete habits or use the timer to see your history.'**
  String get historyEmptySubtitle;

  /// No description provided for @historyLoadError.
  ///
  /// In en, this message translates to:
  /// **'Could not load history'**
  String get historyLoadError;

  /// No description provided for @historyLoadErrorTimer.
  ///
  /// In en, this message translates to:
  /// **'Could not load timer history'**
  String get historyLoadErrorTimer;

  /// No description provided for @historyLoadErrorHabits.
  ///
  /// In en, this message translates to:
  /// **'Could not load habits'**
  String get historyLoadErrorHabits;

  /// No description provided for @historyLoadErrorCategories.
  ///
  /// In en, this message translates to:
  /// **'Could not load categories'**
  String get historyLoadErrorCategories;

  /// No description provided for @historyPendingSection.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get historyPendingSection;

  /// No description provided for @historyPendingBadge.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get historyPendingBadge;

  /// No description provided for @historyTimerSection.
  ///
  /// In en, this message translates to:
  /// **'Timer sessions'**
  String get historyTimerSection;

  /// No description provided for @historyNoHabits.
  ///
  /// In en, this message translates to:
  /// **'No habits scheduled for this day'**
  String get historyNoHabits;

  /// No description provided for @historyDeactivatedHeader.
  ///
  /// In en, this message translates to:
  /// **'Paused habits'**
  String get historyDeactivatedHeader;

  /// No description provided for @timerTitle.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get timerTitle;

  /// No description provided for @timerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Focus your time on one activity.'**
  String get timerSubtitle;

  /// No description provided for @timerActivityLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity'**
  String get timerActivityLabel;

  /// No description provided for @timerActivityHint.
  ///
  /// In en, this message translates to:
  /// **'Study, work, exercise...'**
  String get timerActivityHint;

  /// No description provided for @timerDefaultActivity.
  ///
  /// In en, this message translates to:
  /// **'Focus session'**
  String get timerDefaultActivity;

  /// No description provided for @timerDurationHeader.
  ///
  /// In en, this message translates to:
  /// **'DURATION'**
  String get timerDurationHeader;

  /// No description provided for @timerStatusIdle.
  ///
  /// In en, this message translates to:
  /// **'Ready to start'**
  String get timerStatusIdle;

  /// No description provided for @timerStatusRunning.
  ///
  /// In en, this message translates to:
  /// **'Running'**
  String get timerStatusRunning;

  /// No description provided for @timerStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get timerStatusPaused;

  /// No description provided for @timerStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get timerStatusCompleted;

  /// No description provided for @timerPause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get timerPause;

  /// No description provided for @timerReset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get timerReset;

  /// No description provided for @timerCompletedSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Session completed. Great job!'**
  String get timerCompletedSnackbar;

  /// No description provided for @timerCompletedWithActivitySnackbar.
  ///
  /// In en, this message translates to:
  /// **'Session completed: {activity}'**
  String timerCompletedWithActivitySnackbar(Object activity);

  /// No description provided for @timerValidateTime.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid time'**
  String get timerValidateTime;

  /// No description provided for @timerCustomDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Custom time'**
  String get timerCustomDialogTitle;

  /// No description provided for @timerMinutesLabel.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get timerMinutesLabel;

  /// No description provided for @timerMinutesHint.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get timerMinutesHint;

  /// No description provided for @timerSecondsLabel.
  ///
  /// In en, this message translates to:
  /// **'Seconds'**
  String get timerSecondsLabel;

  /// No description provided for @timerSecondsHint.
  ///
  /// In en, this message translates to:
  /// **'0'**
  String get timerSecondsHint;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsNotificationsHeader.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get settingsNotificationsHeader;

  /// No description provided for @settingsNotificationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsLabel;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Habit and session reminders'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsAppHeader.
  ///
  /// In en, this message translates to:
  /// **'APP'**
  String get settingsAppHeader;

  /// No description provided for @settingsVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersionLabel;

  /// No description provided for @settingsPremiumHeader.
  ///
  /// In en, this message translates to:
  /// **'PREMIUM'**
  String get settingsPremiumHeader;

  /// No description provided for @settingsRestoreLabel.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get settingsRestoreLabel;

  /// No description provided for @settingsRestoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore your premium purchase on this device'**
  String get settingsRestoreSubtitle;

  /// No description provided for @settingsRestoredSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Purchase restored successfully.'**
  String get settingsRestoredSnackbar;

  /// No description provided for @settingsPrivacyLabel.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyLabel;

  /// No description provided for @settingsPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'See how we handle your data'**
  String get settingsPrivacySubtitle;

  /// No description provided for @settingsPrivacyDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyDialogTitle;

  /// No description provided for @settingsPremiumOwnedTitle.
  ///
  /// In en, this message translates to:
  /// **'Ads removed'**
  String get settingsPremiumOwnedTitle;

  /// No description provided for @settingsPremiumOwnedSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your purchase.'**
  String get settingsPremiumOwnedSubtitle;

  /// No description provided for @settingsPremiumBuyTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove ads'**
  String get settingsPremiumBuyTitle;

  /// No description provided for @settingsPremiumBuySubtitle.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase. No subscriptions.'**
  String get settingsPremiumBuySubtitle;

  /// No description provided for @settingsPremiumNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Premium not available without Google Play.'**
  String get settingsPremiumNotAvailable;

  /// No description provided for @settingsPrivacyContent.
  ///
  /// In en, this message translates to:
  /// **'Habio Privacy Policy\n\nLast updated: July 7, 2026\n\nThis Privacy Policy describes how the Habio application (\"the App\") collects, uses and protects user information.\n\nThe App is developed and published by Gas Station (\"we\", \"our\" or \"the developer\").\n\n1. Information we collect\n\nHabio is designed to help users create habits and track their daily tasks.\n\nThe App does not collect, store or transmit personal information to our servers. Habit, task and progress data is stored only on the user’s device.\n\n2. Locally stored data\n\nThe App may store the following information exclusively on the user’s device:\n\nHabits and tasks created by the user.\nApp settings and preferences.\nProgress and statistics related to habits.\n\nThis data is not sent to our servers nor shared with third parties.\n\n3. Advertising\n\nHabio displays ads through Google AdMob, an advertising service provided by Google.\n\nGoogle AdMob may collect certain device data, such as advertising identifiers and usage information, to show relevant ads and measure their performance. The processing of this data is subject to Google’s privacy policies.\n\nYou can learn more about how Google uses data from its services at:\n\nhttps://policies.google.com/privacy\n\n4. In-app purchases\n\nThe App offers an optional purchase to remove ads.\n\nIn-app purchases are processed by Google Play. We do not collect or store payment information, credit card numbers, or financial data from users.\n\n5. App permissions\n\nHabio may request the notification permission to send reminders related to habits and tasks created by the user.\n\nNotifications are used solely for the functioning of the App and do not involve the collection of personal information.\n\n6. Minors\n\nHabio is aimed at the general public and may be used by people of all ages.\n\nThe App does not deliberately collect personal information from minors.\n\n7. Information security\n\nBecause the App’s information is stored locally on the user’s device, the user is responsible for protecting access to their device through passwords, biometric methods or other available security measures.\n\n8. Changes to this Privacy Policy\n\nWe may update this Privacy Policy occasionally. Any changes will be posted on this same page and the \"Last updated\" date will be modified accordingly.\n\n9. Contact\n\nIf you have questions about this Privacy Policy, you can contact us at the following email:\n\nGas Station\nEmail: jumpjumpranking@gmail.com'**
  String get settingsPrivacyContent;

  /// No description provided for @onboardingPage1Title.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Habio'**
  String get onboardingPage1Title;

  /// No description provided for @onboardingPage1Desc.
  ///
  /// In en, this message translates to:
  /// **'The simplest way to create and maintain habits.\nOrganize your day, focus on what matters and reach your goals.'**
  String get onboardingPage1Desc;

  /// No description provided for @onboardingPage2Title.
  ///
  /// In en, this message translates to:
  /// **'Create your habits'**
  String get onboardingPage2Title;

  /// No description provided for @onboardingPage2Desc.
  ///
  /// In en, this message translates to:
  /// **'Tap the \"New habit\" button and customize each activity.\nChoose the frequency, duration and a reminder.'**
  String get onboardingPage2Desc;

  /// No description provided for @onboardingPage3Title.
  ///
  /// In en, this message translates to:
  /// **'Track your progress'**
  String get onboardingPage3Title;

  /// No description provided for @onboardingPage3Desc.
  ///
  /// In en, this message translates to:
  /// **'Mark your habits as completed each day.\nCheck your history and watch your progress.'**
  String get onboardingPage3Desc;

  /// No description provided for @onboardingPage4Title.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get onboardingPage4Title;

  /// No description provided for @onboardingPage4Desc.
  ///
  /// In en, this message translates to:
  /// **'Use the timer for focus sessions.\nPerfect for studying, working or meditating.'**
  String get onboardingPage4Desc;

  /// No description provided for @onboardingGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @timerDurationMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String timerDurationMinutes(Object minutes);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
