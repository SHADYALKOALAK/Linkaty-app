import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

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
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @get_started.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الأن'**
  String get get_started;

  /// No description provided for @welcome_title.
  ///
  /// In ar, this message translates to:
  /// **'لينكاتي — هويتك الرقمية في مكان واحد'**
  String get welcome_title;

  /// No description provided for @welcome_sup_title.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ هويتك الرقمية بسهولة وشارك جميع روابطك ومنصاتك الاجتماعية وصفحاتك المهمة من خلال رابط واحد بتصميم عصري وتجربة سلسة وآمنة.'**
  String get welcome_sup_title;

  /// No description provided for @log_in_to_your_account.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول إلى حسابك'**
  String get log_in_to_your_account;

  /// No description provided for @sup_title_login.
  ///
  /// In ar, this message translates to:
  /// **'قم بإدخال بريدك الإلكتروني وكلمة المرور لتسجيل الدخول إلى حسابك، أو تابع التسجيل بسهولة عبر جوجل أو فيسبوك.'**
  String get sup_title_login;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور'**
  String get password;

  /// No description provided for @login.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get login;

  /// No description provided for @create_new_account_qus.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد؟'**
  String get create_new_account_qus;

  /// No description provided for @register_now.
  ///
  /// In ar, this message translates to:
  /// **'سجل الأن'**
  String get register_now;

  /// No description provided for @or.
  ///
  /// In ar, this message translates to:
  /// **'أو من خلال'**
  String get or;

  /// No description provided for @continue_with_google.
  ///
  /// In ar, this message translates to:
  /// **'تابع باستخدام جوجل'**
  String get continue_with_google;

  /// No description provided for @continue_with_facebook.
  ///
  /// In ar, this message translates to:
  /// **'تابع باستخدام فيسبوك'**
  String get continue_with_facebook;

  /// No description provided for @create_new_account.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء حساب جديد'**
  String get create_new_account;

  /// No description provided for @sup_title_sgin_up.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بياناتك لإنشاء حساب جديد، أو تابع التسجيل بسهولة عبر جوجل أو فيسبوك.'**
  String get sup_title_sgin_up;

  /// No description provided for @full_name.
  ///
  /// In ar, this message translates to:
  /// **'الإسم كامل'**
  String get full_name;

  /// No description provided for @confirm_password.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة المرور'**
  String get confirm_password;

  /// No description provided for @have_you_had_an_account_before_qus.
  ///
  /// In ar, this message translates to:
  /// **'هل لديك حساب من قبل؟'**
  String get have_you_had_an_account_before_qus;

  /// No description provided for @home.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get home;

  /// No description provided for @my_profile.
  ///
  /// In ar, this message translates to:
  /// **'ملفي الشخصي'**
  String get my_profile;

  /// No description provided for @we_are_happy_to_have_you_with_us.
  ///
  /// In ar, this message translates to:
  /// **'سعيدين بوجودك معنا 👋'**
  String get we_are_happy_to_have_you_with_us;

  /// No description provided for @search_and_filter.
  ///
  /// In ar, this message translates to:
  /// **'البحث والتصفية'**
  String get search_and_filter;

  /// No description provided for @search_hint.
  ///
  /// In ar, this message translates to:
  /// **'بحث عن ...'**
  String get search_hint;

  /// No description provided for @all.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get all;

  /// No description provided for @please_enter_your_email.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال البريد الإلكتروني'**
  String get please_enter_your_email;

  /// No description provided for @please_enter_your_email_address_correctly.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال بريدك الإلكتروني بشكل صحيح'**
  String get please_enter_your_email_address_correctly;

  /// No description provided for @please_enter_your_password.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال كلمة المرور'**
  String get please_enter_your_password;

  /// No description provided for @the_password_is_weak_it_must_contain_at_least_6_characters.
  ///
  /// In ar, this message translates to:
  /// **'كلمة المرور ضعيفة، يجب أن تحتوي على 6 أحرف على الأقل'**
  String get the_password_is_weak_it_must_contain_at_least_6_characters;

  /// No description provided for @please_enter_your_full_name.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال الاسم الكامل'**
  String get please_enter_your_full_name;

  /// No description provided for @please_enter_the_same_password_in_both_fields.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء إدخال نفس كلمة المرور في الحقلين'**
  String get please_enter_the_same_password_in_both_fields;

  /// No description provided for @please_confirm_your_password.
  ///
  /// In ar, this message translates to:
  /// **'الرجاء تأكيد كلمة مرور'**
  String get please_confirm_your_password;

  /// No description provided for @invalid_login_credentials.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني أو كلمة المرور غير صحيحة'**
  String get invalid_login_credentials;

  /// No description provided for @email_not_confirmed.
  ///
  /// In ar, this message translates to:
  /// **'يرجى تأكيد البريد الإلكتروني أولاً'**
  String get email_not_confirmed;

  /// No description provided for @user_not_found.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد حساب بهذا البريد الإلكتروني'**
  String get user_not_found;

  /// No description provided for @network_error.
  ///
  /// In ar, this message translates to:
  /// **'تحقق من الاتصال بالإنترنت'**
  String get network_error;

  /// No description provided for @unexpected_error.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ غير متوقع'**
  String get unexpected_error;

  /// No description provided for @login_success.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدخول بنجاح'**
  String get login_success;

  /// No description provided for @signup_success.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب بنجاح'**
  String get signup_success;

  /// No description provided for @did_you_forget_your_password.
  ///
  /// In ar, this message translates to:
  /// **'هل نسيت كلمة المرور؟'**
  String get did_you_forget_your_password;

  /// No description provided for @forgot_password.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة المرور'**
  String get forgot_password;

  /// No description provided for @enter_your_email_address_and_we_will_send_you_a_link_to_reset_your_password.
  ///
  /// In ar, this message translates to:
  /// **'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور'**
  String
  get enter_your_email_address_and_we_will_send_you_a_link_to_reset_your_password;

  /// No description provided for @send_link.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرابط'**
  String get send_link;

  /// No description provided for @a_password_reset_link_has_been_sent_to_your_email_successfully.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني بنجاح'**
  String get a_password_reset_link_has_been_sent_to_your_email_successfully;
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
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
