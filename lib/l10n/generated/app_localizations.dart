import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'LigueyPro 2.0'**
  String get appTitle;

  /// No description provided for @splashHeadline.
  ///
  /// In fr, this message translates to:
  /// **'VOS SERVICES,'**
  String get splashHeadline;

  /// No description provided for @splashTagline.
  ///
  /// In fr, this message translates to:
  /// **'PLUS PROCHES · PLUS SIMPLES'**
  String get splashTagline;

  /// No description provided for @splashCopyright.
  ///
  /// In fr, this message translates to:
  /// **'© 2026 LigueyPro 2.0. Tous droits réservés.'**
  String get splashCopyright;

  /// No description provided for @profileTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon profil'**
  String get profileTitle;

  /// No description provided for @profileAccountTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mon compte'**
  String get profileAccountTitle;

  /// No description provided for @profileAccountSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérez vos demandes, vos préférences et votre espace pro.'**
  String get profileAccountSubtitle;

  /// No description provided for @profileSectionRequests.
  ///
  /// In fr, this message translates to:
  /// **'DEMANDES'**
  String get profileSectionRequests;

  /// No description provided for @profileNewRequest.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande'**
  String get profileNewRequest;

  /// No description provided for @profileMyRequests.
  ///
  /// In fr, this message translates to:
  /// **'Mes demandes'**
  String get profileMyRequests;

  /// No description provided for @profileSectionProNetwork.
  ///
  /// In fr, this message translates to:
  /// **'RÉSEAU PRO'**
  String get profileSectionProNetwork;

  /// No description provided for @profileAddProfessional.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un professionnel'**
  String get profileAddProfessional;

  /// No description provided for @profileAllProfessionals.
  ///
  /// In fr, this message translates to:
  /// **'Tous les professionnels'**
  String get profileAllProfessionals;

  /// No description provided for @profileSectionApplication.
  ///
  /// In fr, this message translates to:
  /// **'APPLICATION'**
  String get profileSectionApplication;

  /// No description provided for @profilePresentation.
  ///
  /// In fr, this message translates to:
  /// **'Présentation de l’application'**
  String get profilePresentation;

  /// No description provided for @profileSectionSupport.
  ///
  /// In fr, this message translates to:
  /// **'SUPPORT'**
  String get profileSectionSupport;

  /// No description provided for @profileHelpSupport.
  ///
  /// In fr, this message translates to:
  /// **'Aide et support'**
  String get profileHelpSupport;

  /// No description provided for @profileTerms.
  ///
  /// In fr, this message translates to:
  /// **'CGU'**
  String get profileTerms;

  /// No description provided for @profileSettingsShort.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres'**
  String get profileSettingsShort;

  /// No description provided for @commonNotifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get commonNotifications;

  /// No description provided for @commonLocation.
  ///
  /// In fr, this message translates to:
  /// **'Localisation'**
  String get commonLocation;

  /// No description provided for @commonLanguage.
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get commonLanguage;

  /// No description provided for @commonVersion.
  ///
  /// In fr, this message translates to:
  /// **'Version'**
  String get commonVersion;

  /// No description provided for @commonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get commonCancel;

  /// No description provided for @commonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get commonSave;

  /// No description provided for @commonLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get commonLoading;

  /// No description provided for @settingsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paramètres de l’application'**
  String get settingsTitle;

  /// No description provided for @settingsPreferences.
  ///
  /// In fr, this message translates to:
  /// **'Préférences'**
  String get settingsPreferences;

  /// No description provided for @settingsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Gérez les réglages principaux de LigueyPro.'**
  String get settingsSubtitle;

  /// No description provided for @settingsNotificationsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir les alertes sur les nouvelles demandes.'**
  String get settingsNotificationsSubtitle;

  /// No description provided for @settingsLocationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser votre position pour faciliter les demandes.'**
  String get settingsLocationSubtitle;

  /// No description provided for @settingsVideoAutoplay.
  ///
  /// In fr, this message translates to:
  /// **'Lecture automatique des vidéos'**
  String get settingsVideoAutoplay;

  /// No description provided for @settingsVideoAutoplaySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Lancer automatiquement la vidéo de présentation.'**
  String get settingsVideoAutoplaySubtitle;

  /// No description provided for @settingsNotificationsDenied.
  ///
  /// In fr, this message translates to:
  /// **'Les notifications sont refusées. Autorisez-les dans les réglages système.'**
  String get settingsNotificationsDenied;

  /// No description provided for @settingsNotificationsDisableInSystem.
  ///
  /// In fr, this message translates to:
  /// **'Désactivez les notifications dans les réglages système si nécessaire.'**
  String get settingsNotificationsDisableInSystem;

  /// No description provided for @settingsLocationDenied.
  ///
  /// In fr, this message translates to:
  /// **'La localisation est refusée. Autorisez-la dans les réglages système.'**
  String get settingsLocationDenied;

  /// No description provided for @settingsLocationDisableInSystem.
  ///
  /// In fr, this message translates to:
  /// **'Désactivez la localisation dans les réglages système si nécessaire.'**
  String get settingsLocationDisableInSystem;

  /// No description provided for @settingsLanguageUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Langue de l’application mise à jour.'**
  String get settingsLanguageUpdated;

  /// No description provided for @settingsLanguageFrenchInterface.
  ///
  /// In fr, this message translates to:
  /// **'Interface en français'**
  String get settingsLanguageFrenchInterface;

  /// No description provided for @settingsLanguageEnglishInterface.
  ///
  /// In fr, this message translates to:
  /// **'Interface en anglais'**
  String get settingsLanguageEnglishInterface;

  /// No description provided for @settingsBackOfficeHintUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Code BO indisponible. Vérifiez la clé Firebase security/backoffice/access_code.'**
  String get settingsBackOfficeHintUnavailable;

  /// No description provided for @settingsBackOfficeHintActive.
  ///
  /// In fr, this message translates to:
  /// **'Code BO actif dans Firebase : {prefix}- *** (6 chiffres)'**
  String settingsBackOfficeHintActive(Object prefix);

  /// No description provided for @settingsBackOfficeSecurity.
  ///
  /// In fr, this message translates to:
  /// **'Sécurité du back-office'**
  String get settingsBackOfficeSecurity;

  /// No description provided for @settingsBackOfficeStatusOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouvert'**
  String get settingsBackOfficeStatusOpen;

  /// No description provided for @settingsBackOfficeStatusLocked.
  ///
  /// In fr, this message translates to:
  /// **'Verrouillé'**
  String get settingsBackOfficeStatusLocked;

  /// No description provided for @settingsBackOfficeChangeCode.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le code BO'**
  String get settingsBackOfficeChangeCode;

  /// No description provided for @settingsBackOfficeCodeUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Code BO Firebase non chargé'**
  String get settingsBackOfficeCodeUnavailable;

  /// No description provided for @settingsBackOfficeCodeActive.
  ///
  /// In fr, this message translates to:
  /// **'Code actif : {code}'**
  String settingsBackOfficeCodeActive(Object code);

  /// No description provided for @settingsBackOfficeLockTitle.
  ///
  /// In fr, this message translates to:
  /// **'Verrouiller le back-office'**
  String get settingsBackOfficeLockTitle;

  /// No description provided for @settingsBackOfficeLockSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Couper immédiatement la session BO en cours'**
  String get settingsBackOfficeLockSubtitle;

  /// No description provided for @settingsBackOfficeLockedNow.
  ///
  /// In fr, this message translates to:
  /// **'Back-office verrouillé immédiatement.'**
  String get settingsBackOfficeLockedNow;

  /// No description provided for @settingsBackOfficeDialogTitle.
  ///
  /// In fr, this message translates to:
  /// **'Code du back-office'**
  String get settingsBackOfficeDialogTitle;

  /// No description provided for @settingsBackOfficeDialogDescription.
  ///
  /// In fr, this message translates to:
  /// **'Définissez un code à 6 chiffres pour protéger l’accès au BO.'**
  String get settingsBackOfficeDialogDescription;

  /// No description provided for @settingsBackOfficeNewCode.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau code'**
  String get settingsBackOfficeNewCode;

  /// No description provided for @settingsSixDigits.
  ///
  /// In fr, this message translates to:
  /// **'6 chiffres'**
  String get settingsSixDigits;

  /// No description provided for @settingsBackOfficeCodeInvalid.
  ///
  /// In fr, this message translates to:
  /// **'Le code BO doit contenir exactement 6 chiffres.'**
  String get settingsBackOfficeCodeInvalid;

  /// No description provided for @settingsBackOfficeCodeSaved.
  ///
  /// In fr, this message translates to:
  /// **'Code BO Firebase enregistré. La session a été reverrouillée.'**
  String get settingsBackOfficeCodeSaved;

  /// No description provided for @notificationsHeaderCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucune alerte pour le moment.} =1{1 notification disponible.} other{{count} notifications disponibles.}}'**
  String notificationsHeaderCount(int count);

  /// No description provided for @notificationsManagePermissions.
  ///
  /// In fr, this message translates to:
  /// **'Régler les autorisations'**
  String get notificationsManagePermissions;

  /// No description provided for @notificationsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification à afficher'**
  String get notificationsEmptyTitle;

  /// No description provided for @notificationsEmptyDescription.
  ///
  /// In fr, this message translates to:
  /// **'Les nouvelles demandes et alertes importantes apparaîtront ici en temps réel.'**
  String get notificationsEmptyDescription;

  /// No description provided for @notificationsFirebaseUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Les notifications ne sont pas disponibles tant que Firebase n’est pas initialisé.'**
  String get notificationsFirebaseUnavailable;

  /// No description provided for @notificationsLoadError.
  ///
  /// In fr, this message translates to:
  /// **'Impossible de charger les notifications pour le moment.'**
  String get notificationsLoadError;

  /// No description provided for @notificationsDefaultRequestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande'**
  String get notificationsDefaultRequestTitle;

  /// No description provided for @notificationsDefaultRequestBody.
  ///
  /// In fr, this message translates to:
  /// **'Une demande a été soumise.'**
  String get notificationsDefaultRequestBody;

  /// No description provided for @notificationsDefaultCategory.
  ///
  /// In fr, this message translates to:
  /// **'Non classée'**
  String get notificationsDefaultCategory;

  /// No description provided for @helpSupportHowItWorks.
  ///
  /// In fr, this message translates to:
  /// **'Comment ça marche'**
  String get helpSupportHowItWorks;

  /// No description provided for @helpSupportFindServiceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Trouver un service'**
  String get helpSupportFindServiceTitle;

  /// No description provided for @helpSupportFindServiceDescription.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une catégorie ou utilisez la recherche pour trouver le bon professionnel près de chez vous.'**
  String get helpSupportFindServiceDescription;

  /// No description provided for @helpSupportCreateRequestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Créer une demande'**
  String get helpSupportCreateRequestTitle;

  /// No description provided for @helpSupportCreateRequestDescription.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez votre besoin, choisissez la catégorie et précisez l’urgence, votre localisation et votre numéro de téléphone.'**
  String get helpSupportCreateRequestDescription;

  /// No description provided for @helpSupportTrackRequestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Suivre votre demande'**
  String get helpSupportTrackRequestTitle;

  /// No description provided for @helpSupportTrackRequestDescription.
  ///
  /// In fr, this message translates to:
  /// **'Consultez les demandes dans “Mes demandes” pour voir l’état et l’ordre d’urgence des interventions.'**
  String get helpSupportTrackRequestDescription;

  /// No description provided for @helpSupportFaqTitle.
  ///
  /// In fr, this message translates to:
  /// **'Questions fréquentes'**
  String get helpSupportFaqTitle;

  /// No description provided for @helpSupportFaqEditQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Comment puis-je modifier une demande ?'**
  String get helpSupportFaqEditQuestion;

  /// No description provided for @helpSupportFaqEditAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Rendez-vous dans la liste de vos demandes et sélectionnez la demande concernée pour vérifier ou corriger les informations.'**
  String get helpSupportFaqEditAnswer;

  /// No description provided for @helpSupportFaqNoReplyQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Que faire si je ne reçois pas de réponse ?'**
  String get helpSupportFaqNoReplyQuestion;

  /// No description provided for @helpSupportFaqNoReplyAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez relancer votre demande, vérifier l’urgence sélectionnée et confirmer votre numéro de téléphone pour être recontacté.'**
  String get helpSupportFaqNoReplyAnswer;

  /// No description provided for @helpSupportFaqContactQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Comment contacter l’assistance ?'**
  String get helpSupportFaqContactQuestion;

  /// No description provided for @helpSupportFaqContactAnswer.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez nous écrire via le support de l’application ou appeler le centre d’assistance disponible dans votre région.'**
  String get helpSupportFaqContactAnswer;

  /// No description provided for @helpSupportNeedHelpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Besoin d’accompagnement ?'**
  String get helpSupportNeedHelpTitle;

  /// No description provided for @helpSupportNeedHelpDescription.
  ///
  /// In fr, this message translates to:
  /// **'Notre équipe peut vous aider pour la création d’une demande, le suivi ou la résolution d’un problème technique.'**
  String get helpSupportNeedHelpDescription;

  /// No description provided for @cguTitle.
  ///
  /// In fr, this message translates to:
  /// **'Conditions générales d’utilisation'**
  String get cguTitle;

  /// No description provided for @cguIntro.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur LigueyPro. En utilisant cette application, vous acceptez les présentes conditions générales.'**
  String get cguIntro;

  /// No description provided for @cguSection1Title.
  ///
  /// In fr, this message translates to:
  /// **'1. Objet'**
  String get cguSection1Title;

  /// No description provided for @cguSection1Body.
  ///
  /// In fr, this message translates to:
  /// **'L’application a pour objectif de mettre en relation les utilisateurs avec des professionnels de services disponibles dans leur zone géographique.'**
  String get cguSection1Body;

  /// No description provided for @cguSection2Title.
  ///
  /// In fr, this message translates to:
  /// **'2. Utilisation du service'**
  String get cguSection2Title;

  /// No description provided for @cguSection2Body.
  ///
  /// In fr, this message translates to:
  /// **'Vous vous engagez à fournir des informations exactes, notamment votre localisation, votre numéro de téléphone et votre description de besoin. Vous devez utiliser l’application de manière responsable et conforme à la loi.'**
  String get cguSection2Body;

  /// No description provided for @cguSection3Title.
  ///
  /// In fr, this message translates to:
  /// **'3. Demandes et professionnels'**
  String get cguSection3Title;

  /// No description provided for @cguSection3Body.
  ///
  /// In fr, this message translates to:
  /// **'Les demandes soumises sont transmises aux professionnels disponibles. La disponibilité, le prix et les délais peuvent varier selon les conditions réelles du prestataire et de la demande.'**
  String get cguSection3Body;

  /// No description provided for @cguSection4Title.
  ///
  /// In fr, this message translates to:
  /// **'4. Responsabilités'**
  String get cguSection4Title;

  /// No description provided for @cguSection4Body.
  ///
  /// In fr, this message translates to:
  /// **'L’application sert uniquement de plateforme de mise en relation. LigueyPro n’est pas responsable directe des prestations réalisées par les professionnels, des résultats obtenus ou des éventuels litiges entre utilisateurs et prestataires.'**
  String get cguSection4Body;

  /// No description provided for @cguSection5Title.
  ///
  /// In fr, this message translates to:
  /// **'5. Données personnelles'**
  String get cguSection5Title;

  /// No description provided for @cguSection5Body.
  ///
  /// In fr, this message translates to:
  /// **'Les données collectées, notamment le numéro de téléphone et la localisation, sont utilisées pour faciliter la mise en relation et le suivi des demandes. Elles doivent être traitées conformément à la réglementation sur la protection des données.'**
  String get cguSection5Body;

  /// No description provided for @cguSection6Title.
  ///
  /// In fr, this message translates to:
  /// **'6. Modifications'**
  String get cguSection6Title;

  /// No description provided for @cguSection6Body.
  ///
  /// In fr, this message translates to:
  /// **'Nous pouvons modifier ces conditions à tout moment. Les changements importants seront signalés dans l’application ou via les moyens disponibles.'**
  String get cguSection6Body;

  /// No description provided for @cguConclusion.
  ///
  /// In fr, this message translates to:
  /// **'En continuant à utiliser l’application, vous confirmez avoir lu et accepté ces conditions.'**
  String get cguConclusion;

  /// No description provided for @homeNavHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get homeNavHome;

  /// No description provided for @homeNavRequests.
  ///
  /// In fr, this message translates to:
  /// **'Demandes'**
  String get homeNavRequests;

  /// No description provided for @homeNavPros.
  ///
  /// In fr, this message translates to:
  /// **'Pros'**
  String get homeNavPros;

  /// No description provided for @homeNavProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get homeNavProfile;

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour 👋'**
  String get homeGreeting;

  /// No description provided for @homeQuestion.
  ///
  /// In fr, this message translates to:
  /// **'De quel service avez-vous besoin ?'**
  String get homeQuestion;

  /// No description provided for @homeDefaultHeroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Besoin d’un pro tout de suite ?'**
  String get homeDefaultHeroTitle;

  /// No description provided for @homeDefaultHeroSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Déposez votre demande en moins d’une minute et recevez une réponse rapide.'**
  String get homeDefaultHeroSubtitle;

  /// No description provided for @homeDefaultHeroPrimaryCta.
  ///
  /// In fr, this message translates to:
  /// **'Demande urgente'**
  String get homeDefaultHeroPrimaryCta;

  /// No description provided for @homeDefaultHeroSecondaryCta.
  ///
  /// In fr, this message translates to:
  /// **'Voir les pros'**
  String get homeDefaultHeroSecondaryCta;

  /// No description provided for @homeMetricVerifiedPros.
  ///
  /// In fr, this message translates to:
  /// **'Pros vérifiés'**
  String get homeMetricVerifiedPros;

  /// No description provided for @homeMetricAverageResponse.
  ///
  /// In fr, this message translates to:
  /// **'Réponse moyenne'**
  String get homeMetricAverageResponse;

  /// No description provided for @homeMetricAverageRating.
  ///
  /// In fr, this message translates to:
  /// **'Note moyenne'**
  String get homeMetricAverageRating;

  /// No description provided for @homeMetricNotAvailable.
  ///
  /// In fr, this message translates to:
  /// **'N/A'**
  String get homeMetricNotAvailable;

  /// No description provided for @homeReviewsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 avis} other{{count} avis}}'**
  String homeReviewsCount(int count);

  /// No description provided for @homeCategoriesEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune catégorie disponible'**
  String get homeCategoriesEmptyTitle;

  /// No description provided for @homeCategoriesEmptyDescription.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des catégories dans home/categories sur Firebase pour alimenter l’accueil.'**
  String get homeCategoriesEmptyDescription;

  /// No description provided for @homeSearchFallback.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get homeSearchFallback;

  /// No description provided for @homeSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un service...'**
  String get homeSearchHint;

  /// No description provided for @homeRecentRequestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dernière demande'**
  String get homeRecentRequestTitle;

  /// No description provided for @homeAcceptedOfferTitle.
  ///
  /// In fr, this message translates to:
  /// **'Offre retenue'**
  String get homeAcceptedOfferTitle;

  /// No description provided for @homeAcceptedPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix accepté : {price}'**
  String homeAcceptedPrice(Object price);

  /// No description provided for @homeConfirmedEta.
  ///
  /// In fr, this message translates to:
  /// **'Délai confirmé : {eta}'**
  String homeConfirmedEta(Object eta);

  /// No description provided for @homeTrackRequest.
  ///
  /// In fr, this message translates to:
  /// **'Suivre ma demande'**
  String get homeTrackRequest;

  /// No description provided for @homeNewRequest.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande'**
  String get homeNewRequest;

  /// No description provided for @homePopularServices.
  ///
  /// In fr, this message translates to:
  /// **'Services populaires'**
  String get homePopularServices;

  /// No description provided for @homeNeedHelpTitle.
  ///
  /// In fr, this message translates to:
  /// **'Besoin d’aide ?'**
  String get homeNeedHelpTitle;

  /// No description provided for @homeNeedHelpDescription.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez votre problème. LigueyPro AI vous aide à trouver le bon professionnel.'**
  String get homeNeedHelpDescription;

  /// No description provided for @homeSeePresentation.
  ///
  /// In fr, this message translates to:
  /// **'Voir la présentation'**
  String get homeSeePresentation;

  /// No description provided for @homeStatusAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Acceptée'**
  String get homeStatusAccepted;

  /// No description provided for @homeStatusAwaitingOffers.
  ///
  /// In fr, this message translates to:
  /// **'En attente d’offres'**
  String get homeStatusAwaitingOffers;

  /// No description provided for @homeStatusInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get homeStatusInProgress;

  /// No description provided for @homeStatusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminée'**
  String get homeStatusCompleted;

  /// No description provided for @homeStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get homeStatusPending;

  /// No description provided for @presentationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Présentation de l’application'**
  String get presentationTitle;

  /// No description provided for @presentationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez le bon service près de chez vous'**
  String get presentationSubtitle;

  /// No description provided for @presentationVideoLabel.
  ///
  /// In fr, this message translates to:
  /// **'Vidéo de présentation'**
  String get presentationVideoLabel;

  /// No description provided for @presentationWhyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi LigueyPro 2.0 ?'**
  String get presentationWhyTitle;

  /// No description provided for @presentationFeatureFastSearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche rapide'**
  String get presentationFeatureFastSearchTitle;

  /// No description provided for @presentationFeatureFastSearchDescription.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez un service adapté à votre besoin en quelques secondes.'**
  String get presentationFeatureFastSearchDescription;

  /// No description provided for @presentationFeatureReliableProsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Professionnels fiables'**
  String get presentationFeatureReliableProsTitle;

  /// No description provided for @presentationFeatureReliableProsDescription.
  ///
  /// In fr, this message translates to:
  /// **'Consultez les avis, les évaluations et les profils disponibles.'**
  String get presentationFeatureReliableProsDescription;

  /// No description provided for @presentationFeatureSimpleTrackingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Suivi simple'**
  String get presentationFeatureSimpleTrackingTitle;

  /// No description provided for @presentationFeatureSimpleTrackingDescription.
  ///
  /// In fr, this message translates to:
  /// **'Suivez vos demandes et recevez des notifications utiles.'**
  String get presentationFeatureSimpleTrackingDescription;

  /// No description provided for @requestPageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle demande'**
  String get requestPageTitle;

  /// No description provided for @requestPageDescribeNeed.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez votre besoin'**
  String get requestPageDescribeNeed;

  /// No description provided for @requestNeedDescription.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez décrire votre besoin.'**
  String get requestNeedDescription;

  /// No description provided for @requestNeedPhone.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez renseigner votre numéro de téléphone.'**
  String get requestNeedPhone;

  /// No description provided for @requestNoServiceAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucun service n’est disponible pour le moment.'**
  String get requestNoServiceAvailable;

  /// No description provided for @requestDialogSentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée'**
  String get requestDialogSentTitle;

  /// No description provided for @requestDialogSentBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre demande a été publiée. Les professionnels abonnés peuvent maintenant recevoir cette demande et vous envoyer leurs offres.'**
  String get requestDialogSentBody;

  /// No description provided for @requestDialogViewMyRequests.
  ///
  /// In fr, this message translates to:
  /// **'Voir mes demandes'**
  String get requestDialogViewMyRequests;

  /// No description provided for @requestSaveFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de sauvegarde de la demande. Réessayez.'**
  String get requestSaveFailed;

  /// No description provided for @requestFirebaseNoService.
  ///
  /// In fr, this message translates to:
  /// **'Aucun service disponible dans Firebase.'**
  String get requestFirebaseNoService;

  /// No description provided for @requestServiceTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de service'**
  String get requestServiceTypeLabel;

  /// No description provided for @requestSummaryTitle.
  ///
  /// In fr, this message translates to:
  /// **'Résumé de votre demande'**
  String get requestSummaryTitle;

  /// No description provided for @requestSummaryService.
  ///
  /// In fr, this message translates to:
  /// **'Service : {service}'**
  String requestSummaryService(Object service);

  /// No description provided for @requestSummaryUrgency.
  ///
  /// In fr, this message translates to:
  /// **'Urgence : {urgency}'**
  String requestSummaryUrgency(Object urgency);

  /// No description provided for @requestSummaryNoService.
  ///
  /// In fr, this message translates to:
  /// **'Non disponible'**
  String get requestSummaryNoService;

  /// No description provided for @requestSummaryImproveMatching.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez une description claire pour améliorer le matching.'**
  String get requestSummaryImproveMatching;

  /// No description provided for @requestDirectPaymentNotice.
  ///
  /// In fr, this message translates to:
  /// **'Paiement direct : le client règle ensuite le professionnel hors application, après réception des offres.'**
  String get requestDirectPaymentNotice;

  /// No description provided for @requestUrgencyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Urgence'**
  String get requestUrgencyTitle;

  /// No description provided for @requestDescriptionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get requestDescriptionTitle;

  /// No description provided for @requestDescriptionHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. Mon climatiseur ne refroidit plus…'**
  String get requestDescriptionHint;

  /// No description provided for @requestPhoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get requestPhoneLabel;

  /// No description provided for @requestPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'+221 77 123 45 67'**
  String get requestPhoneHint;

  /// No description provided for @requestLocationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Localisation'**
  String get requestLocationLabel;

  /// No description provided for @requestLocationHint.
  ///
  /// In fr, this message translates to:
  /// **'Votre adresse ou quartier'**
  String get requestLocationHint;

  /// No description provided for @requestPublish.
  ///
  /// In fr, this message translates to:
  /// **'Publier la demande'**
  String get requestPublish;

  /// No description provided for @requestDefaultLocation.
  ///
  /// In fr, this message translates to:
  /// **'Dakar, Sénégal'**
  String get requestDefaultLocation;

  /// No description provided for @requestUnknownLocation.
  ///
  /// In fr, this message translates to:
  /// **'Localisation non renseignée'**
  String get requestUnknownLocation;

  /// No description provided for @requestsMyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Mes demandes'**
  String get requestsMyTitle;

  /// No description provided for @requestsAllTypes.
  ///
  /// In fr, this message translates to:
  /// **'Tous les types'**
  String get requestsAllTypes;

  /// No description provided for @requestsAllCategories.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les catégories'**
  String get requestsAllCategories;

  /// No description provided for @requestsFilterTitle.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get requestsFilterTitle;

  /// No description provided for @requestsFilterTypeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Type de demande'**
  String get requestsFilterTypeLabel;

  /// No description provided for @requestsFilterCategoryLabel.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie'**
  String get requestsFilterCategoryLabel;

  /// No description provided for @requestsFilterDateLabel.
  ///
  /// In fr, this message translates to:
  /// **'Tri par date'**
  String get requestsFilterDateLabel;

  /// No description provided for @requestsSortNewest.
  ///
  /// In fr, this message translates to:
  /// **'Plus récentes d’abord'**
  String get requestsSortNewest;

  /// No description provided for @requestsSortOldest.
  ///
  /// In fr, this message translates to:
  /// **'Plus anciennes d’abord'**
  String get requestsSortOldest;

  /// No description provided for @requestsLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement des demandes...'**
  String get requestsLoading;

  /// No description provided for @requestsStatusAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Acceptée'**
  String get requestsStatusAccepted;

  /// No description provided for @requestsStatusAwaitingOffers.
  ///
  /// In fr, this message translates to:
  /// **'En attente d’offres'**
  String get requestsStatusAwaitingOffers;

  /// No description provided for @requestsStatusEnRoute.
  ///
  /// In fr, this message translates to:
  /// **'En route'**
  String get requestsStatusEnRoute;

  /// No description provided for @requestsStatusInProgress.
  ///
  /// In fr, this message translates to:
  /// **'En cours'**
  String get requestsStatusInProgress;

  /// No description provided for @requestsStatusCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Terminée'**
  String get requestsStatusCompleted;

  /// No description provided for @requestsStatusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get requestsStatusCancelled;

  /// No description provided for @requestsStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get requestsStatusPending;

  /// No description provided for @requestsOffersAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Offre acceptée'**
  String get requestsOffersAccepted;

  /// No description provided for @requestsOffersClosed.
  ///
  /// In fr, this message translates to:
  /// **'Appel d’offres clos'**
  String get requestsOffersClosed;

  /// No description provided for @requestsOffersOpen.
  ///
  /// In fr, this message translates to:
  /// **'Offres ouvertes'**
  String get requestsOffersOpen;

  /// No description provided for @requestsCreatedOn.
  ///
  /// In fr, this message translates to:
  /// **'Créée le {date}'**
  String requestsCreatedOn(Object date);

  /// No description provided for @requestsOffersCountSummary.
  ///
  /// In fr, this message translates to:
  /// **'{status} • {count} offre(s)'**
  String requestsOffersCountSummary(Object status, Object count);

  /// No description provided for @requestsDirectPaymentAfterOffer.
  ///
  /// In fr, this message translates to:
  /// **'Règlement direct entre client et professionnel après choix de l’offre.'**
  String get requestsDirectPaymentAfterOffer;

  /// No description provided for @requestsChosenProfessional.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel retenu'**
  String get requestsChosenProfessional;

  /// No description provided for @requestsAcceptedPrice.
  ///
  /// In fr, this message translates to:
  /// **'Prix accepté : {price}'**
  String requestsAcceptedPrice(Object price);

  /// No description provided for @requestsConfirmedEta.
  ///
  /// In fr, this message translates to:
  /// **'Délai confirmé : {eta}'**
  String requestsConfirmedEta(Object eta);

  /// No description provided for @requestsViewProfile.
  ///
  /// In fr, this message translates to:
  /// **'Voir le profil'**
  String get requestsViewProfile;

  /// No description provided for @requestsViewOffers.
  ///
  /// In fr, this message translates to:
  /// **'Voir les offres'**
  String get requestsViewOffers;

  /// No description provided for @requestsEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande envoyée'**
  String get requestsEmptyTitle;

  /// No description provided for @requestsEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Vos demandes apparaîtront ici avec leur statut, leurs offres et leur historique.'**
  String get requestsEmptyMessage;

  /// No description provided for @requestsNoFilterResultsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat pour ces filtres'**
  String get requestsNoFilterResultsTitle;

  /// No description provided for @requestsNoFilterResultsMessage.
  ///
  /// In fr, this message translates to:
  /// **'Modifiez le type, la catégorie ou le tri pour afficher d’autres demandes.'**
  String get requestsNoFilterResultsMessage;

  /// No description provided for @requestsNoRequestsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande disponible pour le moment.'**
  String get requestsNoRequestsAvailable;

  /// No description provided for @requestOffersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Offres reçues'**
  String get requestOffersTitle;

  /// No description provided for @requestOffersAcceptedMessage.
  ///
  /// In fr, this message translates to:
  /// **'Offre de {name} acceptée. Le règlement se fait ensuite en direct.'**
  String requestOffersAcceptedMessage(Object name);

  /// No description provided for @requestOffersEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune offre reçue pour le moment'**
  String get requestOffersEmptyTitle;

  /// No description provided for @requestOffersEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Les professionnels abonnés verront votre demande et pourront bientôt proposer leurs prix et délais.'**
  String get requestOffersEmptyMessage;

  /// No description provided for @requestOffersBadgeAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Offre acceptée'**
  String get requestOffersBadgeAccepted;

  /// No description provided for @requestOffersBadgeHighlighted.
  ///
  /// In fr, this message translates to:
  /// **'Offre mise en avant'**
  String get requestOffersBadgeHighlighted;

  /// No description provided for @requestOffersCallPro.
  ///
  /// In fr, this message translates to:
  /// **'Appeler le pro'**
  String get requestOffersCallPro;

  /// No description provided for @requestOffersContact.
  ///
  /// In fr, this message translates to:
  /// **'Contacter'**
  String get requestOffersContact;

  /// No description provided for @requestOffersRetained.
  ///
  /// In fr, this message translates to:
  /// **'Offre retenue'**
  String get requestOffersRetained;

  /// No description provided for @requestOffersAlreadyAssigned.
  ///
  /// In fr, this message translates to:
  /// **'Déjà attribuée'**
  String get requestOffersAlreadyAssigned;

  /// No description provided for @requestOffersValidating.
  ///
  /// In fr, this message translates to:
  /// **'Validation...'**
  String get requestOffersValidating;

  /// No description provided for @requestOffersChooseThis.
  ///
  /// In fr, this message translates to:
  /// **'Choisir cette offre'**
  String get requestOffersChooseThis;

  /// No description provided for @serviceSearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche'**
  String get serviceSearchTitle;

  /// No description provided for @serviceSearchAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get serviceSearchAdd;

  /// No description provided for @serviceSearchNearby.
  ///
  /// In fr, this message translates to:
  /// **'Professionnels proches'**
  String get serviceSearchNearby;

  /// No description provided for @serviceSearchResultsFor.
  ///
  /// In fr, this message translates to:
  /// **'Résultats pour “{query}”'**
  String serviceSearchResultsFor(Object query);

  /// No description provided for @serviceSearchFilterDescription.
  ///
  /// In fr, this message translates to:
  /// **'Filtrez les profils les plus fiables, disponibles et bien notés.'**
  String get serviceSearchFilterDescription;

  /// No description provided for @serviceSearchFilterAll.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get serviceSearchFilterAll;

  /// No description provided for @serviceSearchFilterVerified.
  ///
  /// In fr, this message translates to:
  /// **'Vérifiés'**
  String get serviceSearchFilterVerified;

  /// No description provided for @serviceSearchFilterAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponibles'**
  String get serviceSearchFilterAvailable;

  /// No description provided for @serviceSearchFilterTopRated.
  ///
  /// In fr, this message translates to:
  /// **'Top notés'**
  String get serviceSearchFilterTopRated;

  /// No description provided for @serviceSearchBadgeVerified.
  ///
  /// In fr, this message translates to:
  /// **'Vérifié'**
  String get serviceSearchBadgeVerified;

  /// No description provided for @serviceSearchBadgeAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get serviceSearchBadgeAvailable;

  /// No description provided for @serviceSearchSee.
  ///
  /// In fr, this message translates to:
  /// **'Voir'**
  String get serviceSearchSee;

  /// No description provided for @serviceSearchEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun professionnel trouvé'**
  String get serviceSearchEmptyTitle;

  /// No description provided for @serviceSearchEmptyMessage.
  ///
  /// In fr, this message translates to:
  /// **'Aucun profil ne correspond à cette recherche dans Firebase pour le moment.'**
  String get serviceSearchEmptyMessage;

  /// No description provided for @serviceSearchDefaultPrice.
  ///
  /// In fr, this message translates to:
  /// **'À confirmer'**
  String get serviceSearchDefaultPrice;

  /// No description provided for @serviceSearchDefaultResponseTime.
  ///
  /// In fr, this message translates to:
  /// **'Réponse rapide'**
  String get serviceSearchDefaultResponseTime;

  /// No description provided for @addProfessionalInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Informations du professionnel'**
  String get addProfessionalInfoTitle;

  /// No description provided for @addProfessionalNoService.
  ///
  /// In fr, this message translates to:
  /// **'Aucun service disponible pour le moment.'**
  String get addProfessionalNoService;

  /// No description provided for @addProfessionalFillAll.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez remplir tous les champs.'**
  String get addProfessionalFillAll;

  /// No description provided for @addProfessionalSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel ajouté avec succès.'**
  String get addProfessionalSuccess;

  /// No description provided for @addProfessionalSaveFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l’ajout du professionnel. Réessayez.'**
  String get addProfessionalSaveFailed;

  /// No description provided for @addProfessionalNameLabel.
  ///
  /// In fr, this message translates to:
  /// **'Nom du professionnel'**
  String get addProfessionalNameLabel;

  /// No description provided for @addProfessionalServiceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Service'**
  String get addProfessionalServiceLabel;

  /// No description provided for @addProfessionalLocationLabel.
  ///
  /// In fr, this message translates to:
  /// **'Zone d’intervention'**
  String get addProfessionalLocationLabel;

  /// No description provided for @addProfessionalPriceLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prix / Tarification'**
  String get addProfessionalPriceLabel;

  /// No description provided for @addProfessionalPhoneLabel.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get addProfessionalPhoneLabel;

  /// No description provided for @addProfessionalPhoneHint.
  ///
  /// In fr, this message translates to:
  /// **'+221 77 000 00 00'**
  String get addProfessionalPhoneHint;

  /// No description provided for @addProfessionalResponseLabel.
  ///
  /// In fr, this message translates to:
  /// **'Délai de réponse estimé'**
  String get addProfessionalResponseLabel;

  /// No description provided for @addProfessionalResponseHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. Répond en moins de 15 min'**
  String get addProfessionalResponseHint;

  /// No description provided for @addProfessionalAvailableNowTitle.
  ///
  /// In fr, this message translates to:
  /// **'Disponible immédiatement'**
  String get addProfessionalAvailableNowTitle;

  /// No description provided for @addProfessionalAvailableNowSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Visible comme disponible dans les résultats.'**
  String get addProfessionalAvailableNowSubtitle;

  /// No description provided for @addProfessionalSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer le professionnel'**
  String get addProfessionalSave;

  /// No description provided for @professionalPageTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil professionnel'**
  String get professionalPageTitle;

  /// No description provided for @professionalRequestService.
  ///
  /// In fr, this message translates to:
  /// **'Demander un service'**
  String get professionalRequestService;

  /// No description provided for @professionalWhatsappUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'WhatsApp n’est pas disponible sur cet appareil.'**
  String get professionalWhatsappUnavailable;

  /// No description provided for @professionalReviewNoComment.
  ///
  /// In fr, this message translates to:
  /// **'Sans commentaire'**
  String get professionalReviewNoComment;

  /// No description provided for @professionalNoReviewsYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucun avis pour le moment'**
  String get professionalNoReviewsYet;

  /// No description provided for @professionalJustNow.
  ///
  /// In fr, this message translates to:
  /// **'à l’instant'**
  String get professionalJustNow;

  /// No description provided for @professionalMinutesAgo.
  ///
  /// In fr, this message translates to:
  /// **'il y a {minutes} min'**
  String professionalMinutesAgo(Object minutes);

  /// No description provided for @professionalHoursAgo.
  ///
  /// In fr, this message translates to:
  /// **'il y a {hours} h'**
  String professionalHoursAgo(Object hours);

  /// No description provided for @professionalDaysAgo.
  ///
  /// In fr, this message translates to:
  /// **'il y a {days} j'**
  String professionalDaysAgo(Object days);

  /// No description provided for @professionalTrust.
  ///
  /// In fr, this message translates to:
  /// **'Confiance'**
  String get professionalTrust;

  /// No description provided for @professionalTrustVerified.
  ///
  /// In fr, this message translates to:
  /// **'Badge vérifié'**
  String get professionalTrustVerified;

  /// No description provided for @professionalTrustStandard.
  ///
  /// In fr, this message translates to:
  /// **'Profil standard'**
  String get professionalTrustStandard;

  /// No description provided for @professionalInterventions.
  ///
  /// In fr, this message translates to:
  /// **'Interventions'**
  String get professionalInterventions;

  /// No description provided for @professionalInterventionsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} réalisées'**
  String professionalInterventionsCount(Object count);

  /// No description provided for @professionalResponse.
  ///
  /// In fr, this message translates to:
  /// **'Réponse'**
  String get professionalResponse;

  /// No description provided for @professionalChooseRating.
  ///
  /// In fr, this message translates to:
  /// **'Veuillez choisir une note.'**
  String get professionalChooseRating;

  /// No description provided for @professionalNotFoundForRating.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel introuvable pour enregistrer la note.'**
  String get professionalNotFoundForRating;

  /// No description provided for @professionalThanksForRating.
  ///
  /// In fr, this message translates to:
  /// **'Merci pour votre note de {rating}/5.'**
  String professionalThanksForRating(Object rating);

  /// No description provided for @professionalRatingSaveFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l’enregistrement de la note. Réessayez.'**
  String get professionalRatingSaveFailed;

  /// No description provided for @professionalNotFoundTitle.
  ///
  /// In fr, this message translates to:
  /// **'Profil introuvable'**
  String get professionalNotFoundTitle;

  /// No description provided for @professionalNotFoundMessage.
  ///
  /// In fr, this message translates to:
  /// **'Ce professionnel n’est pas présent dans Firebase ou n’est plus disponible.'**
  String get professionalNotFoundMessage;

  /// No description provided for @professionalLoading.
  ///
  /// In fr, this message translates to:
  /// **'Chargement...'**
  String get professionalLoading;

  /// No description provided for @professionalDefaultBadge.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel'**
  String get professionalDefaultBadge;

  /// No description provided for @professionalVerifiedBadge.
  ///
  /// In fr, this message translates to:
  /// **'Profil vérifié'**
  String get professionalVerifiedBadge;

  /// No description provided for @professionalSubscribedBadge.
  ///
  /// In fr, this message translates to:
  /// **'Abonné Pro'**
  String get professionalSubscribedBadge;

  /// No description provided for @professionalAvailableBadge.
  ///
  /// In fr, this message translates to:
  /// **'Disponible maintenant'**
  String get professionalAvailableBadge;

  /// No description provided for @professionalSubscriptionInfo.
  ///
  /// In fr, this message translates to:
  /// **'Ce professionnel est abonné au plan {plan} et peut recevoir vos demandes puis vous émettre des offres.'**
  String professionalSubscriptionInfo(Object plan);

  /// No description provided for @professionalInfoSection.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get professionalInfoSection;

  /// No description provided for @professionalLocationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Zone d’intervention'**
  String get professionalLocationSubtitle;

  /// No description provided for @professionalServiceSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Service principal'**
  String get professionalServiceSubtitle;

  /// No description provided for @professionalPriceSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Indication tarifaire'**
  String get professionalPriceSubtitle;

  /// No description provided for @professionalCall.
  ///
  /// In fr, this message translates to:
  /// **'Appeler'**
  String get professionalCall;

  /// No description provided for @professionalWhatsapp.
  ///
  /// In fr, this message translates to:
  /// **'WhatsApp'**
  String get professionalWhatsapp;

  /// No description provided for @professionalRecentReviews.
  ///
  /// In fr, this message translates to:
  /// **'Avis récents'**
  String get professionalRecentReviews;

  /// No description provided for @professionalNoRecentReviews.
  ///
  /// In fr, this message translates to:
  /// **'Aucun avis récent disponible pour ce professionnel.'**
  String get professionalNoRecentReviews;

  /// No description provided for @professionalRateTitle.
  ///
  /// In fr, this message translates to:
  /// **'Noter ce professionnel'**
  String get professionalRateTitle;

  /// No description provided for @professionalReviewLabel.
  ///
  /// In fr, this message translates to:
  /// **'Votre avis'**
  String get professionalReviewLabel;

  /// No description provided for @professionalReviewHint.
  ///
  /// In fr, this message translates to:
  /// **'Décrivez votre expérience...'**
  String get professionalReviewHint;

  /// No description provided for @professionalValidateRating.
  ///
  /// In fr, this message translates to:
  /// **'Valider la note'**
  String get professionalValidateRating;

  /// No description provided for @professionalUnknownLocation.
  ///
  /// In fr, this message translates to:
  /// **'Localisation non renseignée'**
  String get professionalUnknownLocation;

  /// No description provided for @professionalUnknownPrice.
  ///
  /// In fr, this message translates to:
  /// **'Tarif à confirmer'**
  String get professionalUnknownPrice;

  /// No description provided for @professionalUnknownService.
  ///
  /// In fr, this message translates to:
  /// **'Service non renseigné'**
  String get professionalUnknownService;

  /// No description provided for @professionalUnknownResponse.
  ///
  /// In fr, this message translates to:
  /// **'Temps de réponse non renseigné'**
  String get professionalUnknownResponse;

  /// No description provided for @proSubscriptionTitle.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement Pro'**
  String get proSubscriptionTitle;

  /// No description provided for @proSubscriptionActivated.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement Pro simulé activé. Branchez ensuite votre moyen d’encaissement réel.'**
  String get proSubscriptionActivated;

  /// No description provided for @proSubscriptionHeroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevez des demandes et envoyez des offres'**
  String get proSubscriptionHeroTitle;

  /// No description provided for @proSubscriptionHeroBody.
  ///
  /// In fr, this message translates to:
  /// **'L’abonnement remplace le paiement client dans l’app. Les professionnels paient pour recevoir des opportunités et répondre avec leurs offres.'**
  String get proSubscriptionHeroBody;

  /// No description provided for @proSubscriptionLeadsIncluded.
  ///
  /// In fr, this message translates to:
  /// **'{count} demandes incluses par mois'**
  String proSubscriptionLeadsIncluded(Object count);

  /// No description provided for @proSubscriptionSelectedPlan.
  ///
  /// In fr, this message translates to:
  /// **'Plan choisi : {plan}. Les professionnels abonnés peuvent recevoir les demandes et proposer leurs offres sans encaissement client dans l’application.'**
  String proSubscriptionSelectedPlan(Object plan);

  /// No description provided for @proSubscriptionChoosePlan.
  ///
  /// In fr, this message translates to:
  /// **'Choisir {plan}'**
  String proSubscriptionChoosePlan(Object plan);

  /// No description provided for @landingWhyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi LigueyPro'**
  String get landingWhyTitle;

  /// No description provided for @landingWhySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Une place de marché locale pensée pour accélérer la rencontre entre clients et professionnels abonnés.'**
  String get landingWhySubtitle;

  /// No description provided for @landingFeatureExpressTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande express'**
  String get landingFeatureExpressTitle;

  /// No description provided for @landingFeatureExpressBody.
  ///
  /// In fr, this message translates to:
  /// **'Le client publie son besoin en quelques secondes avec urgence, zone et téléphone.'**
  String get landingFeatureExpressBody;

  /// No description provided for @landingFeatureOffersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Offres comparables'**
  String get landingFeatureOffersTitle;

  /// No description provided for @landingFeatureOffersBody.
  ///
  /// In fr, this message translates to:
  /// **'Les pros abonnés répondent avec prix, délai et message personnalisé.'**
  String get landingFeatureOffersBody;

  /// No description provided for @landingFeatureBackOfficeTitle.
  ///
  /// In fr, this message translates to:
  /// **'BO sécurisé'**
  String get landingFeatureBackOfficeTitle;

  /// No description provided for @landingFeatureBackOfficeBody.
  ///
  /// In fr, this message translates to:
  /// **'Le back-office permet de piloter les demandes, les offres et la performance commerciale.'**
  String get landingFeatureBackOfficeBody;

  /// No description provided for @landingMetricsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Indicateurs clés'**
  String get landingMetricsTitle;

  /// No description provided for @landingMetricsSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Des chiffres réels issus de Firebase pour refléter le volume et la qualité de l’activité LigueyPro.'**
  String get landingMetricsSubtitle;

  /// No description provided for @landingMetricActivePros.
  ///
  /// In fr, this message translates to:
  /// **'Professionnels actifs'**
  String get landingMetricActivePros;

  /// No description provided for @landingMetricPublishedRequests.
  ///
  /// In fr, this message translates to:
  /// **'Demandes publiées'**
  String get landingMetricPublishedRequests;

  /// No description provided for @landingMetricSentOffers.
  ///
  /// In fr, this message translates to:
  /// **'Offres envoyées'**
  String get landingMetricSentOffers;

  /// No description provided for @landingMetricAverageRating.
  ///
  /// In fr, this message translates to:
  /// **'Note moyenne'**
  String get landingMetricAverageRating;

  /// No description provided for @landingMetricAverageRatingWithReviews.
  ///
  /// In fr, this message translates to:
  /// **'Note moyenne ({count} avis)'**
  String landingMetricAverageRatingWithReviews(Object count);

  /// No description provided for @landingSwitchAppTitle.
  ///
  /// In fr, this message translates to:
  /// **'Passez à l’application'**
  String get landingSwitchAppTitle;

  /// No description provided for @landingSwitchAppBody.
  ///
  /// In fr, this message translates to:
  /// **'Consultez les services, publiez une demande ou ouvrez votre back-office professionnel sécurisé.'**
  String get landingSwitchAppBody;

  /// No description provided for @landingNavProfessionals.
  ///
  /// In fr, this message translates to:
  /// **'Professionnels'**
  String get landingNavProfessionals;

  /// No description provided for @landingNavPresentation.
  ///
  /// In fr, this message translates to:
  /// **'Présentation'**
  String get landingNavPresentation;

  /// No description provided for @landingNavBackOffice.
  ///
  /// In fr, this message translates to:
  /// **'Back-office'**
  String get landingNavBackOffice;

  /// No description provided for @landingBrandSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Marketplace sénégalaise de services et back-office professionnel'**
  String get landingBrandSubtitle;

  /// No description provided for @landingHeroBadge.
  ///
  /// In fr, this message translates to:
  /// **'Client + Professionnel + BO'**
  String get landingHeroBadge;

  /// No description provided for @landingHeroCompactTitle.
  ///
  /// In fr, this message translates to:
  /// **'Le bon pro, plus vite.'**
  String get landingHeroCompactTitle;

  /// No description provided for @landingHeroWideTitle.
  ///
  /// In fr, this message translates to:
  /// **'Publiez une demande, comparez les offres et pilotez vos opérations depuis un back-office sécurisé.'**
  String get landingHeroWideTitle;

  /// No description provided for @landingHeroBody.
  ///
  /// In fr, this message translates to:
  /// **'LigueyPro connecte les besoins du quotidien à {subscribedCount} professionnel(s) abonné(s), avec {offersCount} offre(s) déjà envoyée(s) et un temps de réponse moyen de {responseTime}.'**
  String landingHeroBody(
      Object subscribedCount, Object offersCount, Object responseTime);

  /// No description provided for @landingHeroServicesCovered.
  ///
  /// In fr, this message translates to:
  /// **'services couverts'**
  String get landingHeroServicesCovered;

  /// No description provided for @landingHeroVerifiedPros.
  ///
  /// In fr, this message translates to:
  /// **'pros vérifiés'**
  String get landingHeroVerifiedPros;

  /// No description provided for @landingHeroSubscribedPros.
  ///
  /// In fr, this message translates to:
  /// **'pros abonnés'**
  String get landingHeroSubscribedPros;

  /// No description provided for @landingQuickAccessTitle.
  ///
  /// In fr, this message translates to:
  /// **'Entrées rapides'**
  String get landingQuickAccessTitle;

  /// No description provided for @landingQuickAccessSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre parcours selon votre rôle ou votre objectif du moment.'**
  String get landingQuickAccessSubtitle;

  /// No description provided for @landingAccessBrowseTitle.
  ///
  /// In fr, this message translates to:
  /// **'Parcourir l’application'**
  String get landingAccessBrowseTitle;

  /// No description provided for @landingAccessBrowseSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir les services et publier une demande.'**
  String get landingAccessBrowseSubtitle;

  /// No description provided for @landingAccessBecomeProTitle.
  ///
  /// In fr, this message translates to:
  /// **'Devenir professionnel'**
  String get landingAccessBecomeProTitle;

  /// No description provided for @landingAccessBecomeProSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Découvrir les abonnements et laisser vos coordonnées.'**
  String get landingAccessBecomeProSubtitle;

  /// No description provided for @landingAccessBackOfficeTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir le back-office'**
  String get landingAccessBackOfficeTitle;

  /// No description provided for @landingAccessBackOfficeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Accès protégé aux leads, offres et statistiques.'**
  String get landingAccessBackOfficeSubtitle;

  /// No description provided for @landingAccessPresentationTitle.
  ///
  /// In fr, this message translates to:
  /// **'Voir la présentation'**
  String get landingAccessPresentationTitle;

  /// No description provided for @landingAccessPresentationSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Comprendre le fonctionnement de LigueyPro.'**
  String get landingAccessPresentationSubtitle;

  /// No description provided for @landingEnterApp.
  ///
  /// In fr, this message translates to:
  /// **'Entrer dans l’application'**
  String get landingEnterApp;

  /// No description provided for @landingSecureBo.
  ///
  /// In fr, this message translates to:
  /// **'Accéder au BO sécurisé'**
  String get landingSecureBo;

  /// No description provided for @landingNotAvailable.
  ///
  /// In fr, this message translates to:
  /// **'N/A'**
  String get landingNotAvailable;

  /// No description provided for @proMarketingTitle.
  ///
  /// In fr, this message translates to:
  /// **'LigueyPro pour les professionnels'**
  String get proMarketingTitle;

  /// No description provided for @proMarketingSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Leads, offres, abonnement et back-office sécurisé'**
  String get proMarketingSubtitle;

  /// No description provided for @proMarketingHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get proMarketingHome;

  /// No description provided for @proMarketingHeroBadge.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement pro + conversion'**
  String get proMarketingHeroBadge;

  /// No description provided for @proMarketingHeroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevez plus d’opportunités qualifiées et répondez plus vite que vos concurrents.'**
  String get proMarketingHeroTitle;

  /// No description provided for @proMarketingHeroBody.
  ///
  /// In fr, this message translates to:
  /// **'LigueyPro permet aux professionnels abonnés de capter des demandes réelles, d’émettre des offres structurées et de piloter leur activité avec des indicateurs simples.'**
  String get proMarketingHeroBody;

  /// No description provided for @proMarketingMetricLeads.
  ///
  /// In fr, this message translates to:
  /// **'leads mensuels sur le plan Pro'**
  String get proMarketingMetricLeads;

  /// No description provided for @proMarketingMetricSecurity.
  ///
  /// In fr, this message translates to:
  /// **'chiffres pour protéger le BO'**
  String get proMarketingMetricSecurity;

  /// No description provided for @proMarketingMetricWorkflow.
  ///
  /// In fr, this message translates to:
  /// **'workflow simple d’acquisition'**
  String get proMarketingMetricWorkflow;

  /// No description provided for @proMarketingWhyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Pourquoi s’abonner'**
  String get proMarketingWhyTitle;

  /// No description provided for @proMarketingWhySubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Le modèle LigueyPro remplace le paiement client dans l’application par une logique simple d’abonnement professionnel.'**
  String get proMarketingWhySubtitle;

  /// No description provided for @proMarketingValueLeadsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir des demandes ciblées'**
  String get proMarketingValueLeadsTitle;

  /// No description provided for @proMarketingValueLeadsBody.
  ///
  /// In fr, this message translates to:
  /// **'Accédez aux demandes liées à votre métier et à votre zone d’intervention.'**
  String get proMarketingValueLeadsBody;

  /// No description provided for @proMarketingValueOffersTitle.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer des offres claires'**
  String get proMarketingValueOffersTitle;

  /// No description provided for @proMarketingValueOffersBody.
  ///
  /// In fr, this message translates to:
  /// **'Répondez avec vos tarifs, délais et un message rassurant pour augmenter votre conversion.'**
  String get proMarketingValueOffersBody;

  /// No description provided for @proMarketingValuePerformanceTitle.
  ///
  /// In fr, this message translates to:
  /// **'Piloter votre performance'**
  String get proMarketingValuePerformanceTitle;

  /// No description provided for @proMarketingValuePerformanceBody.
  ///
  /// In fr, this message translates to:
  /// **'Suivez vos offres, vos gains et vos indicateurs dans un back-office sécurisé.'**
  String get proMarketingValuePerformanceBody;

  /// No description provided for @proMarketingPlansTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plans professionnels'**
  String get proMarketingPlansTitle;

  /// No description provided for @proMarketingPlansSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un niveau d’engagement adapté à votre volume de demandes et à votre ambition commerciale.'**
  String get proMarketingPlansSubtitle;

  /// No description provided for @proMarketingCtaTitle.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à activer votre profil pro ?'**
  String get proMarketingCtaTitle;

  /// No description provided for @proMarketingCtaBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre profil, choisissez votre abonnement et accédez ensuite à votre back-office sécurisé pour traiter les demandes.'**
  String get proMarketingCtaBody;

  /// No description provided for @proMarketingGetStartedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Démarrer en 3 étapes'**
  String get proMarketingGetStartedTitle;

  /// No description provided for @proMarketingGetStartedBody.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre profil, activez votre abonnement, puis traitez vos demandes depuis le BO.'**
  String get proMarketingGetStartedBody;

  /// No description provided for @proMarketingStep1Title.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter votre profil'**
  String get proMarketingStep1Title;

  /// No description provided for @proMarketingStep1Body.
  ///
  /// In fr, this message translates to:
  /// **'Renseignez votre service, votre zone et vos coordonnées.'**
  String get proMarketingStep1Body;

  /// No description provided for @proMarketingStep2Title.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un plan'**
  String get proMarketingStep2Title;

  /// No description provided for @proMarketingStep2Body.
  ///
  /// In fr, this message translates to:
  /// **'Activez un abonnement adapté à votre volume de leads.'**
  String get proMarketingStep2Body;

  /// No description provided for @proMarketingStep3Title.
  ///
  /// In fr, this message translates to:
  /// **'Piloter vos offres'**
  String get proMarketingStep3Title;

  /// No description provided for @proMarketingStep3Body.
  ///
  /// In fr, this message translates to:
  /// **'Suivez vos réponses, vos attributions et votre conversion.'**
  String get proMarketingStep3Body;

  /// No description provided for @proMarketingLeaveDetails.
  ///
  /// In fr, this message translates to:
  /// **'Laisser mes coordonnées'**
  String get proMarketingLeaveDetails;

  /// No description provided for @proMarketingSeeSubscriptions.
  ///
  /// In fr, this message translates to:
  /// **'Voir les abonnements'**
  String get proMarketingSeeSubscriptions;

  /// No description provided for @proMarketingBalanced.
  ///
  /// In fr, this message translates to:
  /// **'Le plus équilibré'**
  String get proMarketingBalanced;

  /// No description provided for @proMarketingRequestsPerMonth.
  ///
  /// In fr, this message translates to:
  /// **'{count} demandes par mois'**
  String proMarketingRequestsPerMonth(Object count);

  /// No description provided for @boAccessLoadingHint.
  ///
  /// In fr, this message translates to:
  /// **'Chargement du code d’accès...'**
  String get boAccessLoadingHint;

  /// No description provided for @boAccessInvalidCode.
  ///
  /// In fr, this message translates to:
  /// **'Code invalide. Vérifiez le code BO et réessayez.'**
  String get boAccessInvalidCode;

  /// No description provided for @boAccessDescription.
  ///
  /// In fr, this message translates to:
  /// **'Le back-office permet de piloter les demandes, vos offres et le professionnel actif. L’accès est limité à une session sécurisée de 30 minutes.'**
  String get boAccessDescription;

  /// No description provided for @boAccessSession.
  ///
  /// In fr, this message translates to:
  /// **'Session 30 min'**
  String get boAccessSession;

  /// No description provided for @boAccessPrivate.
  ///
  /// In fr, this message translates to:
  /// **'Accès privé'**
  String get boAccessPrivate;

  /// No description provided for @boAccessUnlockTitle.
  ///
  /// In fr, this message translates to:
  /// **'Déverrouiller le BO'**
  String get boAccessUnlockTitle;

  /// No description provided for @boAccessCodeLabel.
  ///
  /// In fr, this message translates to:
  /// **'Code BO'**
  String get boAccessCodeLabel;

  /// No description provided for @boAccessCodeHint.
  ///
  /// In fr, this message translates to:
  /// **'Saisir 6 chiffres'**
  String get boAccessCodeHint;

  /// No description provided for @boCommonUnlock.
  ///
  /// In fr, this message translates to:
  /// **'Déverrouiller'**
  String get boCommonUnlock;

  /// No description provided for @categoryAdminLabelRequired.
  ///
  /// In fr, this message translates to:
  /// **'Renseignez un libellé de catégorie.'**
  String get categoryAdminLabelRequired;

  /// No description provided for @categoryAdminFirebaseUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Firebase n’est pas disponible pour le moment.'**
  String get categoryAdminFirebaseUnavailable;

  /// No description provided for @categoryAdminCreated.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie ajoutée.'**
  String get categoryAdminCreated;

  /// No description provided for @categoryAdminCreateFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de l’ajout de la catégorie.'**
  String get categoryAdminCreateFailed;

  /// No description provided for @categoryAdminDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la catégorie'**
  String get categoryAdminDeleteTitle;

  /// No description provided for @categoryAdminDeleteBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette action retirera la catégorie de l’accueil et du formulaire de demande.'**
  String get categoryAdminDeleteBody;

  /// No description provided for @categoryAdminDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie supprimée.'**
  String get categoryAdminDeleted;

  /// No description provided for @categoryAdminDeleteFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la suppression de la catégorie.'**
  String get categoryAdminDeleteFailed;

  /// No description provided for @categoryAdminUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie mise à jour.'**
  String get categoryAdminUpdated;

  /// No description provided for @categoryAdminUpdateFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la mise à jour de la catégorie.'**
  String get categoryAdminUpdateFailed;

  /// No description provided for @categoryAdminReorderFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la mise à jour de l’ordre des catégories.'**
  String get categoryAdminReorderFailed;

  /// No description provided for @categoryAdminEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la catégorie'**
  String get categoryAdminEditTitle;

  /// No description provided for @categoryAdminLabel.
  ///
  /// In fr, this message translates to:
  /// **'Libellé'**
  String get categoryAdminLabel;

  /// No description provided for @categoryAdminIcon.
  ///
  /// In fr, this message translates to:
  /// **'Icône'**
  String get categoryAdminIcon;

  /// No description provided for @categoryAdminTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catégories'**
  String get categoryAdminTitle;

  /// No description provided for @boCommonBackToBo.
  ///
  /// In fr, this message translates to:
  /// **'Retour BO'**
  String get boCommonBackToBo;

  /// No description provided for @categoryAdminHeroTitle.
  ///
  /// In fr, this message translates to:
  /// **'Catégories de services'**
  String get categoryAdminHeroTitle;

  /// No description provided for @categoryAdminHeroBody.
  ///
  /// In fr, this message translates to:
  /// **'Gérez les catégories visibles sur l’accueil et dans le formulaire de demande, sans passer par la console Firebase.'**
  String get categoryAdminHeroBody;

  /// No description provided for @categoryAdminAddTitle.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une catégorie'**
  String get categoryAdminAddTitle;

  /// No description provided for @categoryAdminLabelHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. Climatisation'**
  String get categoryAdminLabelHint;

  /// No description provided for @categoryAdminAdding.
  ///
  /// In fr, this message translates to:
  /// **'Ajout...'**
  String get categoryAdminAdding;

  /// No description provided for @categoryAdminAddAction.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter la catégorie'**
  String get categoryAdminAddAction;

  /// No description provided for @boCommonMoveUp.
  ///
  /// In fr, this message translates to:
  /// **'Monter'**
  String get boCommonMoveUp;

  /// No description provided for @boCommonMoveDown.
  ///
  /// In fr, this message translates to:
  /// **'Descendre'**
  String get boCommonMoveDown;

  /// No description provided for @boCommonEdit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get boCommonEdit;

  /// No description provided for @boCommonDelete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get boCommonDelete;

  /// No description provided for @categoryAdminPositionIcon.
  ///
  /// In fr, this message translates to:
  /// **'Position {position} • Icône : {icon}'**
  String categoryAdminPositionIcon(Object position, Object icon);

  /// No description provided for @categoryAdminEmptyTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucune catégorie configurée'**
  String get categoryAdminEmptyTitle;

  /// No description provided for @categoryAdminEmptyBody.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre première catégorie pour alimenter l’accueil et le formulaire de demande.'**
  String get categoryAdminEmptyBody;

  /// No description provided for @categoryAdminOfflineTitle.
  ///
  /// In fr, this message translates to:
  /// **'Firebase indisponible'**
  String get categoryAdminOfflineTitle;

  /// No description provided for @categoryAdminOfflineBody.
  ///
  /// In fr, this message translates to:
  /// **'La gestion des catégories nécessite une connexion Firebase active.'**
  String get categoryAdminOfflineBody;

  /// No description provided for @boCommonCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get boCommonCancel;

  /// No description provided for @boCommonSave.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get boCommonSave;

  /// No description provided for @boCommonSaving.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement...'**
  String get boCommonSaving;

  /// No description provided for @requestAdminStatusUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Statut de la demande mis à jour.'**
  String get requestAdminStatusUpdated;

  /// No description provided for @requestAdminEditTitle.
  ///
  /// In fr, this message translates to:
  /// **'Modifier la demande'**
  String get requestAdminEditTitle;

  /// No description provided for @requestAdminService.
  ///
  /// In fr, this message translates to:
  /// **'Service'**
  String get requestAdminService;

  /// No description provided for @requestAdminUrgency.
  ///
  /// In fr, this message translates to:
  /// **'Urgence'**
  String get requestAdminUrgency;

  /// No description provided for @requestAdminDescription.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get requestAdminDescription;

  /// No description provided for @requestAdminLocation.
  ///
  /// In fr, this message translates to:
  /// **'Localisation'**
  String get requestAdminLocation;

  /// No description provided for @requestAdminPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get requestAdminPhone;

  /// No description provided for @requestAdminOffersCount.
  ///
  /// In fr, this message translates to:
  /// **'Nombre d’offres'**
  String get requestAdminOffersCount;

  /// No description provided for @requestAdminStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut'**
  String get requestAdminStatus;

  /// No description provided for @requestAdminOffersStatus.
  ///
  /// In fr, this message translates to:
  /// **'Statut des offres'**
  String get requestAdminOffersStatus;

  /// No description provided for @requestAdminOffersStatusOpen.
  ///
  /// In fr, this message translates to:
  /// **'Ouvert'**
  String get requestAdminOffersStatusOpen;

  /// No description provided for @requestAdminOffersStatusAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Accepté'**
  String get requestAdminOffersStatusAccepted;

  /// No description provided for @requestAdminOffersStatusClosed.
  ///
  /// In fr, this message translates to:
  /// **'Fermé'**
  String get requestAdminOffersStatusClosed;

  /// No description provided for @requestAdminRequiredFields.
  ///
  /// In fr, this message translates to:
  /// **'Tous les champs principaux doivent être remplis.'**
  String get requestAdminRequiredFields;

  /// No description provided for @requestAdminUpdated.
  ///
  /// In fr, this message translates to:
  /// **'Demande mise à jour.'**
  String get requestAdminUpdated;

  /// No description provided for @requestAdminUpdateFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la mise à jour.'**
  String get requestAdminUpdateFailed;

  /// No description provided for @requestAdminDeleteTitle.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la demande'**
  String get requestAdminDeleteTitle;

  /// No description provided for @requestAdminDeleteBody.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer la demande {service} de {location} ?'**
  String requestAdminDeleteBody(Object service, Object location);

  /// No description provided for @requestAdminDeleted.
  ///
  /// In fr, this message translates to:
  /// **'Demande supprimée.'**
  String get requestAdminDeleted;

  /// No description provided for @requestAdminDeleteFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échec de la suppression.'**
  String get requestAdminDeleteFailed;

  /// No description provided for @requestAdminPhoneValue.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone : {phone}'**
  String requestAdminPhoneValue(Object phone);

  /// No description provided for @requestAdminOffersValue.
  ///
  /// In fr, this message translates to:
  /// **'Offres : {count} • {status}'**
  String requestAdminOffersValue(Object count, Object status);

  /// No description provided for @requestAdminRelaunch.
  ///
  /// In fr, this message translates to:
  /// **'Relancer'**
  String get requestAdminRelaunch;

  /// No description provided for @requestAdminTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demandes BO'**
  String get requestAdminTitle;

  /// No description provided for @requestAdminFirebaseUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Firebase indisponible'**
  String get requestAdminFirebaseUnavailable;

  /// No description provided for @requestAdminHeroEyebrow.
  ///
  /// In fr, this message translates to:
  /// **'Gestion des demandes'**
  String get requestAdminHeroEyebrow;

  /// No description provided for @requestAdminHeroCount.
  ///
  /// In fr, this message translates to:
  /// **'{count} demande(s) enregistrée(s)'**
  String requestAdminHeroCount(Object count);

  /// No description provided for @requestAdminHeroBody.
  ///
  /// In fr, this message translates to:
  /// **'Modifiez ou supprimez les demandes clients stockées dans /requests.'**
  String get requestAdminHeroBody;

  /// No description provided for @requestAdminEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande n’est encore disponible dans Firebase.'**
  String get requestAdminEmpty;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
