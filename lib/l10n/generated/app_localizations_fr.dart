// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'LigueyPro 2.0';

  @override
  String get splashHeadline => 'VOS SERVICES,';

  @override
  String get splashTagline => 'PLUS PROCHES · PLUS SIMPLES';

  @override
  String get splashCopyright => '© 2026 LigueyPro 2.0. Tous droits réservés.';

  @override
  String get profileTitle => 'Mon profil';

  @override
  String get profileAccountTitle => 'Mon compte';

  @override
  String get profileAccountSubtitle =>
      'Gérez vos demandes, vos préférences et votre espace pro.';

  @override
  String get profileSectionRequests => 'DEMANDES';

  @override
  String get profileNewRequest => 'Nouvelle demande';

  @override
  String get profileMyRequests => 'Mes demandes';

  @override
  String get profileSectionProNetwork => 'RÉSEAU PRO';

  @override
  String get profileAddProfessional => 'Ajouter un professionnel';

  @override
  String get profileAllProfessionals => 'Tous les professionnels';

  @override
  String get profileSectionApplication => 'APPLICATION';

  @override
  String get profilePresentation => 'Présentation de l’application';

  @override
  String get profileSectionSupport => 'SUPPORT';

  @override
  String get profileHelpSupport => 'Aide et support';

  @override
  String get profileTerms => 'CGU';

  @override
  String get profileSettingsShort => 'Paramètres';

  @override
  String get commonNotifications => 'Notifications';

  @override
  String get commonLocation => 'Localisation';

  @override
  String get commonLanguage => 'Langue';

  @override
  String get commonVersion => 'Version';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonLoading => 'Chargement...';

  @override
  String get settingsTitle => 'Paramètres de l’application';

  @override
  String get settingsPreferences => 'Préférences';

  @override
  String get settingsSubtitle => 'Gérez les réglages principaux de LigueyPro.';

  @override
  String get settingsNotificationsSubtitle =>
      'Recevoir les alertes sur les nouvelles demandes.';

  @override
  String get settingsLocationSubtitle =>
      'Utiliser votre position pour faciliter les demandes.';

  @override
  String get settingsVideoAutoplay => 'Lecture automatique des vidéos';

  @override
  String get settingsVideoAutoplaySubtitle =>
      'Lancer automatiquement la vidéo de présentation.';

  @override
  String get settingsNotificationsDenied =>
      'Les notifications sont refusées. Autorisez-les dans les réglages système.';

  @override
  String get settingsNotificationsDisableInSystem =>
      'Désactivez les notifications dans les réglages système si nécessaire.';

  @override
  String get settingsLocationDenied =>
      'La localisation est refusée. Autorisez-la dans les réglages système.';

  @override
  String get settingsLocationDisableInSystem =>
      'Désactivez la localisation dans les réglages système si nécessaire.';

  @override
  String get settingsLanguageUpdated => 'Langue de l’application mise à jour.';

  @override
  String get settingsLanguageFrenchInterface => 'Interface en français';

  @override
  String get settingsLanguageEnglishInterface => 'Interface en anglais';

  @override
  String get settingsBackOfficeHintUnavailable =>
      'Code BO indisponible. Vérifiez la clé Firebase security/backoffice/access_code.';

  @override
  String settingsBackOfficeHintActive(Object prefix) {
    return 'Code BO actif dans Firebase : $prefix- *** (6 chiffres)';
  }

  @override
  String get settingsBackOfficeSecurity => 'Sécurité du back-office';

  @override
  String get settingsBackOfficeStatusOpen => 'Ouvert';

  @override
  String get settingsBackOfficeStatusLocked => 'Verrouillé';

  @override
  String get settingsBackOfficeChangeCode => 'Modifier le code BO';

  @override
  String get settingsBackOfficeCodeUnavailable => 'Code BO Firebase non chargé';

  @override
  String settingsBackOfficeCodeActive(Object code) {
    return 'Code actif : $code';
  }

  @override
  String get settingsBackOfficeLockTitle => 'Verrouiller le back-office';

  @override
  String get settingsBackOfficeLockSubtitle =>
      'Couper immédiatement la session BO en cours';

  @override
  String get settingsBackOfficeLockedNow =>
      'Back-office verrouillé immédiatement.';

  @override
  String get settingsBackOfficeDialogTitle => 'Code du back-office';

  @override
  String get settingsBackOfficeDialogDescription =>
      'Définissez un code à 6 chiffres pour protéger l’accès au BO.';

  @override
  String get settingsBackOfficeNewCode => 'Nouveau code';

  @override
  String get settingsSixDigits => '6 chiffres';

  @override
  String get settingsBackOfficeCodeInvalid =>
      'Le code BO doit contenir exactement 6 chiffres.';

  @override
  String get settingsBackOfficeCodeSaved =>
      'Code BO Firebase enregistré. La session a été reverrouillée.';

  @override
  String notificationsHeaderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notifications disponibles.',
      one: '1 notification disponible.',
      zero: 'Aucune alerte pour le moment.',
    );
    return '$_temp0';
  }

  @override
  String get notificationsManagePermissions => 'Régler les autorisations';

  @override
  String get notificationsEmptyTitle => 'Aucune notification à afficher';

  @override
  String get notificationsEmptyDescription =>
      'Les nouvelles demandes et alertes importantes apparaîtront ici en temps réel.';

  @override
  String get notificationsFirebaseUnavailable =>
      'Les notifications ne sont pas disponibles tant que Firebase n’est pas initialisé.';

  @override
  String get notificationsLoadError =>
      'Impossible de charger les notifications pour le moment.';

  @override
  String get notificationsDefaultRequestTitle => 'Nouvelle demande';

  @override
  String get notificationsDefaultRequestBody => 'Une demande a été soumise.';

  @override
  String get notificationsDefaultCategory => 'Non classée';

  @override
  String get helpSupportHowItWorks => 'Comment ça marche';

  @override
  String get helpSupportFindServiceTitle => 'Trouver un service';

  @override
  String get helpSupportFindServiceDescription =>
      'Choisissez une catégorie ou utilisez la recherche pour trouver le bon professionnel près de chez vous.';

  @override
  String get helpSupportCreateRequestTitle => 'Créer une demande';

  @override
  String get helpSupportCreateRequestDescription =>
      'Décrivez votre besoin, choisissez la catégorie et précisez l’urgence, votre localisation et votre numéro de téléphone.';

  @override
  String get helpSupportTrackRequestTitle => 'Suivre votre demande';

  @override
  String get helpSupportTrackRequestDescription =>
      'Consultez les demandes dans “Mes demandes” pour voir l’état et l’ordre d’urgence des interventions.';

  @override
  String get helpSupportFaqTitle => 'Questions fréquentes';

  @override
  String get helpSupportFaqEditQuestion =>
      'Comment puis-je modifier une demande ?';

  @override
  String get helpSupportFaqEditAnswer =>
      'Rendez-vous dans la liste de vos demandes et sélectionnez la demande concernée pour vérifier ou corriger les informations.';

  @override
  String get helpSupportFaqNoReplyQuestion =>
      'Que faire si je ne reçois pas de réponse ?';

  @override
  String get helpSupportFaqNoReplyAnswer =>
      'Vous pouvez relancer votre demande, vérifier l’urgence sélectionnée et confirmer votre numéro de téléphone pour être recontacté.';

  @override
  String get helpSupportFaqContactQuestion =>
      'Comment contacter l’assistance ?';

  @override
  String get helpSupportFaqContactAnswer =>
      'Vous pouvez nous écrire via le support de l’application ou appeler le centre d’assistance disponible dans votre région.';

  @override
  String get helpSupportNeedHelpTitle => 'Besoin d’accompagnement ?';

  @override
  String get helpSupportNeedHelpDescription =>
      'Notre équipe peut vous aider pour la création d’une demande, le suivi ou la résolution d’un problème technique.';

  @override
  String get cguTitle => 'Conditions générales d’utilisation';

  @override
  String get cguIntro =>
      'Bienvenue sur LigueyPro. En utilisant cette application, vous acceptez les présentes conditions générales.';

  @override
  String get cguSection1Title => '1. Objet';

  @override
  String get cguSection1Body =>
      'L’application a pour objectif de mettre en relation les utilisateurs avec des professionnels de services disponibles dans leur zone géographique.';

  @override
  String get cguSection2Title => '2. Utilisation du service';

  @override
  String get cguSection2Body =>
      'Vous vous engagez à fournir des informations exactes, notamment votre localisation, votre numéro de téléphone et votre description de besoin. Vous devez utiliser l’application de manière responsable et conforme à la loi.';

  @override
  String get cguSection3Title => '3. Demandes et professionnels';

  @override
  String get cguSection3Body =>
      'Les demandes soumises sont transmises aux professionnels disponibles. La disponibilité, le prix et les délais peuvent varier selon les conditions réelles du prestataire et de la demande.';

  @override
  String get cguSection4Title => '4. Responsabilités';

  @override
  String get cguSection4Body =>
      'L’application sert uniquement de plateforme de mise en relation. LigueyPro n’est pas responsable directe des prestations réalisées par les professionnels, des résultats obtenus ou des éventuels litiges entre utilisateurs et prestataires.';

  @override
  String get cguSection5Title => '5. Données personnelles';

  @override
  String get cguSection5Body =>
      'Les données collectées, notamment le numéro de téléphone et la localisation, sont utilisées pour faciliter la mise en relation et le suivi des demandes. Elles doivent être traitées conformément à la réglementation sur la protection des données.';

  @override
  String get cguSection6Title => '6. Modifications';

  @override
  String get cguSection6Body =>
      'Nous pouvons modifier ces conditions à tout moment. Les changements importants seront signalés dans l’application ou via les moyens disponibles.';

  @override
  String get cguConclusion =>
      'En continuant à utiliser l’application, vous confirmez avoir lu et accepté ces conditions.';

  @override
  String get homeNavHome => 'Accueil';

  @override
  String get homeNavRequests => 'Demandes';

  @override
  String get homeNavPros => 'Pros';

  @override
  String get homeNavProfile => 'Profil';

  @override
  String get homeGreeting => 'Bonjour 👋';

  @override
  String get homeQuestion => 'De quel service avez-vous besoin ?';

  @override
  String get homeDefaultHeroTitle => 'Besoin d’un pro tout de suite ?';

  @override
  String get homeDefaultHeroSubtitle =>
      'Déposez votre demande en moins d’une minute et recevez une réponse rapide.';

  @override
  String get homeDefaultHeroPrimaryCta => 'Demande urgente';

  @override
  String get homeDefaultHeroSecondaryCta => 'Voir les pros';

  @override
  String get homeMetricVerifiedPros => 'Pros vérifiés';

  @override
  String get homeMetricAverageResponse => 'Réponse moyenne';

  @override
  String get homeMetricAverageRating => 'Note moyenne';

  @override
  String get homeMetricNotAvailable => 'N/A';

  @override
  String homeReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count avis',
      one: '1 avis',
    );
    return '$_temp0';
  }

  @override
  String get homeCategoriesEmptyTitle => 'Aucune catégorie disponible';

  @override
  String get homeCategoriesEmptyDescription =>
      'Ajoutez des catégories dans home/categories sur Firebase pour alimenter l’accueil.';

  @override
  String get homeSearchFallback => 'Recherche';

  @override
  String get homeSearchHint => 'Rechercher un service...';

  @override
  String get homeRecentRequestTitle => 'Dernière demande';

  @override
  String get homeAcceptedOfferTitle => 'Offre retenue';

  @override
  String homeAcceptedPrice(Object price) {
    return 'Prix accepté : $price';
  }

  @override
  String homeConfirmedEta(Object eta) {
    return 'Délai confirmé : $eta';
  }

  @override
  String get homeTrackRequest => 'Suivre ma demande';

  @override
  String get homeNewRequest => 'Nouvelle demande';

  @override
  String get homePopularServices => 'Services populaires';

  @override
  String get homeNeedHelpTitle => 'Besoin d’aide ?';

  @override
  String get homeNeedHelpDescription =>
      'Décrivez votre problème. LigueyPro AI vous aide à trouver le bon professionnel.';

  @override
  String get homeSeePresentation => 'Voir la présentation';

  @override
  String get homeStatusAccepted => 'Acceptée';

  @override
  String get homeStatusAwaitingOffers => 'En attente d’offres';

  @override
  String get homeStatusInProgress => 'En cours';

  @override
  String get homeStatusCompleted => 'Terminée';

  @override
  String get homeStatusPending => 'En attente';

  @override
  String get presentationTitle => 'Présentation de l’application';

  @override
  String get presentationSubtitle => 'Trouvez le bon service près de chez vous';

  @override
  String get presentationVideoLabel => 'Vidéo de présentation';

  @override
  String get presentationWhyTitle => 'Pourquoi LigueyPro 2.0 ?';

  @override
  String get presentationFeatureFastSearchTitle => 'Recherche rapide';

  @override
  String get presentationFeatureFastSearchDescription =>
      'Trouvez un service adapté à votre besoin en quelques secondes.';

  @override
  String get presentationFeatureReliableProsTitle => 'Professionnels fiables';

  @override
  String get presentationFeatureReliableProsDescription =>
      'Consultez les avis, les évaluations et les profils disponibles.';

  @override
  String get presentationFeatureSimpleTrackingTitle => 'Suivi simple';

  @override
  String get presentationFeatureSimpleTrackingDescription =>
      'Suivez vos demandes et recevez des notifications utiles.';

  @override
  String get requestPageTitle => 'Nouvelle demande';

  @override
  String get requestPageDescribeNeed => 'Décrivez votre besoin';

  @override
  String get requestNeedDescription => 'Veuillez décrire votre besoin.';

  @override
  String get requestNeedPhone =>
      'Veuillez renseigner votre numéro de téléphone.';

  @override
  String get requestNoServiceAvailable =>
      'Aucun service n’est disponible pour le moment.';

  @override
  String get requestDialogSentTitle => 'Demande envoyée';

  @override
  String get requestDialogSentBody =>
      'Votre demande a été publiée. Les professionnels abonnés peuvent maintenant recevoir cette demande et vous envoyer leurs offres.';

  @override
  String get requestDialogViewMyRequests => 'Voir mes demandes';

  @override
  String get requestSaveFailed =>
      'Échec de sauvegarde de la demande. Réessayez.';

  @override
  String get requestFirebaseNoService =>
      'Aucun service disponible dans Firebase.';

  @override
  String get requestServiceTypeLabel => 'Type de service';

  @override
  String get requestSummaryTitle => 'Résumé de votre demande';

  @override
  String requestSummaryService(Object service) {
    return 'Service : $service';
  }

  @override
  String requestSummaryUrgency(Object urgency) {
    return 'Urgence : $urgency';
  }

  @override
  String get requestSummaryNoService => 'Non disponible';

  @override
  String get requestSummaryImproveMatching =>
      'Ajoutez une description claire pour améliorer le matching.';

  @override
  String get requestDirectPaymentNotice =>
      'Paiement direct : le client règle ensuite le professionnel hors application, après réception des offres.';

  @override
  String get requestUrgencyTitle => 'Urgence';

  @override
  String get requestDescriptionTitle => 'Description';

  @override
  String get requestDescriptionHint => 'Ex. Mon climatiseur ne refroidit plus…';

  @override
  String get requestPhoneLabel => 'Numéro de téléphone';

  @override
  String get requestPhoneHint => '+221 77 123 45 67';

  @override
  String get requestLocationLabel => 'Localisation';

  @override
  String get requestLocationHint => 'Votre adresse ou quartier';

  @override
  String get requestPublish => 'Publier la demande';

  @override
  String get requestDefaultLocation => 'Dakar, Sénégal';

  @override
  String get requestUnknownLocation => 'Localisation non renseignée';

  @override
  String get requestsMyTitle => 'Mes demandes';

  @override
  String get requestsAllTypes => 'Tous les types';

  @override
  String get requestsAllCategories => 'Toutes les catégories';

  @override
  String get requestsFilterTitle => 'Filtres';

  @override
  String get requestsFilterTypeLabel => 'Type de demande';

  @override
  String get requestsFilterCategoryLabel => 'Catégorie';

  @override
  String get requestsFilterDateLabel => 'Tri par date';

  @override
  String get requestsSortNewest => 'Plus récentes d’abord';

  @override
  String get requestsSortOldest => 'Plus anciennes d’abord';

  @override
  String get requestsLoading => 'Chargement des demandes...';

  @override
  String get requestsStatusAccepted => 'Acceptée';

  @override
  String get requestsStatusAwaitingOffers => 'En attente d’offres';

  @override
  String get requestsStatusEnRoute => 'En route';

  @override
  String get requestsStatusInProgress => 'En cours';

  @override
  String get requestsStatusCompleted => 'Terminée';

  @override
  String get requestsStatusCancelled => 'Annulée';

  @override
  String get requestsStatusPending => 'En attente';

  @override
  String get requestsOffersAccepted => 'Offre acceptée';

  @override
  String get requestsOffersClosed => 'Appel d’offres clos';

  @override
  String get requestsOffersOpen => 'Offres ouvertes';

  @override
  String requestsCreatedOn(Object date) {
    return 'Créée le $date';
  }

  @override
  String requestsOffersCountSummary(Object status, Object count) {
    return '$status • $count offre(s)';
  }

  @override
  String get requestsDirectPaymentAfterOffer =>
      'Règlement direct entre client et professionnel après choix de l’offre.';

  @override
  String get requestsChosenProfessional => 'Professionnel retenu';

  @override
  String requestsAcceptedPrice(Object price) {
    return 'Prix accepté : $price';
  }

  @override
  String requestsConfirmedEta(Object eta) {
    return 'Délai confirmé : $eta';
  }

  @override
  String get requestsViewProfile => 'Voir le profil';

  @override
  String get requestsViewOffers => 'Voir les offres';

  @override
  String get requestsEmptyTitle => 'Aucune demande envoyée';

  @override
  String get requestsEmptyMessage =>
      'Vos demandes apparaîtront ici avec leur statut, leurs offres et leur historique.';

  @override
  String get requestsNoFilterResultsTitle => 'Aucun résultat pour ces filtres';

  @override
  String get requestsNoFilterResultsMessage =>
      'Modifiez le type, la catégorie ou le tri pour afficher d’autres demandes.';

  @override
  String get requestsNoRequestsAvailable =>
      'Aucune demande disponible pour le moment.';

  @override
  String get requestOffersTitle => 'Offres reçues';

  @override
  String requestOffersAcceptedMessage(Object name) {
    return 'Offre de $name acceptée. Le règlement se fait ensuite en direct.';
  }

  @override
  String get requestOffersEmptyTitle => 'Aucune offre reçue pour le moment';

  @override
  String get requestOffersEmptyMessage =>
      'Les professionnels abonnés verront votre demande et pourront bientôt proposer leurs prix et délais.';

  @override
  String get requestOffersBadgeAccepted => 'Offre acceptée';

  @override
  String get requestOffersBadgeHighlighted => 'Offre mise en avant';

  @override
  String get requestOffersCallPro => 'Appeler le pro';

  @override
  String get requestOffersContact => 'Contacter';

  @override
  String get requestOffersRetained => 'Offre retenue';

  @override
  String get requestOffersAlreadyAssigned => 'Déjà attribuée';

  @override
  String get requestOffersValidating => 'Validation...';

  @override
  String get requestOffersChooseThis => 'Choisir cette offre';

  @override
  String get serviceSearchTitle => 'Recherche';

  @override
  String get serviceSearchAdd => 'Ajouter';

  @override
  String get serviceSearchNearby => 'Professionnels proches';

  @override
  String serviceSearchResultsFor(Object query) {
    return 'Résultats pour “$query”';
  }

  @override
  String get serviceSearchFilterDescription =>
      'Filtrez les profils les plus fiables, disponibles et bien notés.';

  @override
  String get serviceSearchFilterAll => 'Tous';

  @override
  String get serviceSearchFilterVerified => 'Vérifiés';

  @override
  String get serviceSearchFilterAvailable => 'Disponibles';

  @override
  String get serviceSearchFilterTopRated => 'Top notés';

  @override
  String get serviceSearchBadgeVerified => 'Vérifié';

  @override
  String get serviceSearchBadgeAvailable => 'Disponible';

  @override
  String get serviceSearchSee => 'Voir';

  @override
  String get serviceSearchEmptyTitle => 'Aucun professionnel trouvé';

  @override
  String get serviceSearchEmptyMessage =>
      'Aucun profil ne correspond à cette recherche dans Firebase pour le moment.';

  @override
  String get serviceSearchDefaultPrice => 'À confirmer';

  @override
  String get serviceSearchDefaultResponseTime => 'Réponse rapide';

  @override
  String get addProfessionalInfoTitle => 'Informations du professionnel';

  @override
  String get addProfessionalNoService =>
      'Aucun service disponible pour le moment.';

  @override
  String get addProfessionalFillAll => 'Veuillez remplir tous les champs.';

  @override
  String get addProfessionalSuccess => 'Professionnel ajouté avec succès.';

  @override
  String get addProfessionalSaveFailed =>
      'Échec de l’ajout du professionnel. Réessayez.';

  @override
  String get addProfessionalNameLabel => 'Nom du professionnel';

  @override
  String get addProfessionalServiceLabel => 'Service';

  @override
  String get addProfessionalLocationLabel => 'Zone d’intervention';

  @override
  String get addProfessionalPriceLabel => 'Prix / Tarification';

  @override
  String get addProfessionalPhoneLabel => 'Téléphone';

  @override
  String get addProfessionalPhoneHint => '+221 77 000 00 00';

  @override
  String get addProfessionalResponseLabel => 'Délai de réponse estimé';

  @override
  String get addProfessionalResponseHint => 'Ex. Répond en moins de 15 min';

  @override
  String get addProfessionalAvailableNowTitle => 'Disponible immédiatement';

  @override
  String get addProfessionalAvailableNowSubtitle =>
      'Visible comme disponible dans les résultats.';

  @override
  String get addProfessionalSave => 'Enregistrer le professionnel';

  @override
  String get professionalPageTitle => 'Profil professionnel';

  @override
  String get professionalRequestService => 'Demander un service';

  @override
  String get professionalWhatsappUnavailable =>
      'WhatsApp n’est pas disponible sur cet appareil.';

  @override
  String get professionalReviewNoComment => 'Sans commentaire';

  @override
  String get professionalNoReviewsYet => 'Aucun avis pour le moment';

  @override
  String get professionalJustNow => 'à l’instant';

  @override
  String professionalMinutesAgo(Object minutes) {
    return 'il y a $minutes min';
  }

  @override
  String professionalHoursAgo(Object hours) {
    return 'il y a $hours h';
  }

  @override
  String professionalDaysAgo(Object days) {
    return 'il y a $days j';
  }

  @override
  String get professionalTrust => 'Confiance';

  @override
  String get professionalTrustVerified => 'Badge vérifié';

  @override
  String get professionalTrustStandard => 'Profil standard';

  @override
  String get professionalInterventions => 'Interventions';

  @override
  String professionalInterventionsCount(Object count) {
    return '$count réalisées';
  }

  @override
  String get professionalResponse => 'Réponse';

  @override
  String get professionalChooseRating => 'Veuillez choisir une note.';

  @override
  String get professionalNotFoundForRating =>
      'Professionnel introuvable pour enregistrer la note.';

  @override
  String professionalThanksForRating(Object rating) {
    return 'Merci pour votre note de $rating/5.';
  }

  @override
  String get professionalRatingSaveFailed =>
      'Échec de l’enregistrement de la note. Réessayez.';

  @override
  String get professionalNotFoundTitle => 'Profil introuvable';

  @override
  String get professionalNotFoundMessage =>
      'Ce professionnel n’est pas présent dans Firebase ou n’est plus disponible.';

  @override
  String get professionalLoading => 'Chargement...';

  @override
  String get professionalDefaultBadge => 'Professionnel';

  @override
  String get professionalVerifiedBadge => 'Profil vérifié';

  @override
  String get professionalSubscribedBadge => 'Abonné Pro';

  @override
  String get professionalAvailableBadge => 'Disponible maintenant';

  @override
  String professionalSubscriptionInfo(Object plan) {
    return 'Ce professionnel est abonné au plan $plan et peut recevoir vos demandes puis vous émettre des offres.';
  }

  @override
  String get professionalInfoSection => 'Informations';

  @override
  String get professionalLocationSubtitle => 'Zone d’intervention';

  @override
  String get professionalServiceSubtitle => 'Service principal';

  @override
  String get professionalPriceSubtitle => 'Indication tarifaire';

  @override
  String get professionalCall => 'Appeler';

  @override
  String get professionalWhatsapp => 'WhatsApp';

  @override
  String get professionalRecentReviews => 'Avis récents';

  @override
  String get professionalNoRecentReviews =>
      'Aucun avis récent disponible pour ce professionnel.';

  @override
  String get professionalRateTitle => 'Noter ce professionnel';

  @override
  String get professionalReviewLabel => 'Votre avis';

  @override
  String get professionalReviewHint => 'Décrivez votre expérience...';

  @override
  String get professionalValidateRating => 'Valider la note';

  @override
  String get professionalUnknownLocation => 'Localisation non renseignée';

  @override
  String get professionalUnknownPrice => 'Tarif à confirmer';

  @override
  String get professionalUnknownService => 'Service non renseigné';

  @override
  String get professionalUnknownResponse => 'Temps de réponse non renseigné';

  @override
  String get proSubscriptionTitle => 'Abonnement Pro';

  @override
  String get proSubscriptionActivated =>
      'Abonnement Pro simulé activé. Branchez ensuite votre moyen d’encaissement réel.';

  @override
  String get proSubscriptionHeroTitle =>
      'Recevez des demandes et envoyez des offres';

  @override
  String get proSubscriptionHeroBody =>
      'L’abonnement remplace le paiement client dans l’app. Les professionnels paient pour recevoir des opportunités et répondre avec leurs offres.';

  @override
  String proSubscriptionLeadsIncluded(Object count) {
    return '$count demandes incluses par mois';
  }

  @override
  String proSubscriptionSelectedPlan(Object plan) {
    return 'Plan choisi : $plan. Les professionnels abonnés peuvent recevoir les demandes et proposer leurs offres sans encaissement client dans l’application.';
  }

  @override
  String proSubscriptionChoosePlan(Object plan) {
    return 'Choisir $plan';
  }

  @override
  String get landingWhyTitle => 'Pourquoi LigueyPro';

  @override
  String get landingWhySubtitle =>
      'Une place de marché locale pensée pour accélérer la rencontre entre clients et professionnels abonnés.';

  @override
  String get landingFeatureExpressTitle => 'Demande express';

  @override
  String get landingFeatureExpressBody =>
      'Le client publie son besoin en quelques secondes avec urgence, zone et téléphone.';

  @override
  String get landingFeatureOffersTitle => 'Offres comparables';

  @override
  String get landingFeatureOffersBody =>
      'Les pros abonnés répondent avec prix, délai et message personnalisé.';

  @override
  String get landingFeatureBackOfficeTitle => 'BO sécurisé';

  @override
  String get landingFeatureBackOfficeBody =>
      'Le back-office permet de piloter les demandes, les offres et la performance commerciale.';

  @override
  String get landingMetricsTitle => 'Indicateurs clés';

  @override
  String get landingMetricsSubtitle =>
      'Des chiffres réels issus de Firebase pour refléter le volume et la qualité de l’activité LigueyPro.';

  @override
  String get landingMetricActivePros => 'Professionnels actifs';

  @override
  String get landingMetricPublishedRequests => 'Demandes publiées';

  @override
  String get landingMetricSentOffers => 'Offres envoyées';

  @override
  String get landingMetricAverageRating => 'Note moyenne';

  @override
  String landingMetricAverageRatingWithReviews(Object count) {
    return 'Note moyenne ($count avis)';
  }

  @override
  String get landingSwitchAppTitle => 'Passez à l’application';

  @override
  String get landingSwitchAppBody =>
      'Consultez les services, publiez une demande ou ouvrez votre back-office professionnel sécurisé.';

  @override
  String get landingNavProfessionals => 'Professionnels';

  @override
  String get landingNavPresentation => 'Présentation';

  @override
  String get landingNavBackOffice => 'Back-office';

  @override
  String get landingBrandSubtitle =>
      'Marketplace sénégalaise de services et back-office professionnel';

  @override
  String get landingHeroBadge => 'Client + Professionnel + BO';

  @override
  String get landingHeroCompactTitle => 'Le bon pro, plus vite.';

  @override
  String get landingHeroWideTitle =>
      'Publiez une demande, comparez les offres et pilotez vos opérations depuis un back-office sécurisé.';

  @override
  String landingHeroBody(
      Object subscribedCount, Object offersCount, Object responseTime) {
    return 'LigueyPro connecte les besoins du quotidien à $subscribedCount professionnel(s) abonné(s), avec $offersCount offre(s) déjà envoyée(s) et un temps de réponse moyen de $responseTime.';
  }

  @override
  String get landingHeroServicesCovered => 'services couverts';

  @override
  String get landingHeroVerifiedPros => 'pros vérifiés';

  @override
  String get landingHeroSubscribedPros => 'pros abonnés';

  @override
  String get landingQuickAccessTitle => 'Entrées rapides';

  @override
  String get landingQuickAccessSubtitle =>
      'Choisissez votre parcours selon votre rôle ou votre objectif du moment.';

  @override
  String get landingAccessBrowseTitle => 'Parcourir l’application';

  @override
  String get landingAccessBrowseSubtitle =>
      'Découvrir les services et publier une demande.';

  @override
  String get landingAccessBecomeProTitle => 'Devenir professionnel';

  @override
  String get landingAccessBecomeProSubtitle =>
      'Découvrir les abonnements et laisser vos coordonnées.';

  @override
  String get landingAccessBackOfficeTitle => 'Ouvrir le back-office';

  @override
  String get landingAccessBackOfficeSubtitle =>
      'Accès protégé aux leads, offres et statistiques.';

  @override
  String get landingAccessPresentationTitle => 'Voir la présentation';

  @override
  String get landingAccessPresentationSubtitle =>
      'Comprendre le fonctionnement de LigueyPro.';

  @override
  String get landingEnterApp => 'Entrer dans l’application';

  @override
  String get landingSecureBo => 'Accéder au BO sécurisé';

  @override
  String get landingNotAvailable => 'N/A';

  @override
  String get proMarketingTitle => 'LigueyPro pour les professionnels';

  @override
  String get proMarketingSubtitle =>
      'Leads, offres, abonnement et back-office sécurisé';

  @override
  String get proMarketingHome => 'Accueil';

  @override
  String get proMarketingHeroBadge => 'Abonnement pro + conversion';

  @override
  String get proMarketingHeroTitle =>
      'Recevez plus d’opportunités qualifiées et répondez plus vite que vos concurrents.';

  @override
  String get proMarketingHeroBody =>
      'LigueyPro permet aux professionnels abonnés de capter des demandes réelles, d’émettre des offres structurées et de piloter leur activité avec des indicateurs simples.';

  @override
  String get proMarketingMetricLeads => 'leads mensuels sur le plan Pro';

  @override
  String get proMarketingMetricSecurity => 'chiffres pour protéger le BO';

  @override
  String get proMarketingMetricWorkflow => 'workflow simple d’acquisition';

  @override
  String get proMarketingWhyTitle => 'Pourquoi s’abonner';

  @override
  String get proMarketingWhySubtitle =>
      'Le modèle LigueyPro remplace le paiement client dans l’application par une logique simple d’abonnement professionnel.';

  @override
  String get proMarketingValueLeadsTitle => 'Recevoir des demandes ciblées';

  @override
  String get proMarketingValueLeadsBody =>
      'Accédez aux demandes liées à votre métier et à votre zone d’intervention.';

  @override
  String get proMarketingValueOffersTitle => 'Envoyer des offres claires';

  @override
  String get proMarketingValueOffersBody =>
      'Répondez avec vos tarifs, délais et un message rassurant pour augmenter votre conversion.';

  @override
  String get proMarketingValuePerformanceTitle => 'Piloter votre performance';

  @override
  String get proMarketingValuePerformanceBody =>
      'Suivez vos offres, vos gains et vos indicateurs dans un back-office sécurisé.';

  @override
  String get proMarketingPlansTitle => 'Plans professionnels';

  @override
  String get proMarketingPlansSubtitle =>
      'Choisissez un niveau d’engagement adapté à votre volume de demandes et à votre ambition commerciale.';

  @override
  String get proMarketingCtaTitle => 'Prêt à activer votre profil pro ?';

  @override
  String get proMarketingCtaBody =>
      'Ajoutez votre profil, choisissez votre abonnement et accédez ensuite à votre back-office sécurisé pour traiter les demandes.';

  @override
  String get proMarketingGetStartedTitle => 'Démarrer en 3 étapes';

  @override
  String get proMarketingGetStartedBody =>
      'Créez votre profil, activez votre abonnement, puis traitez vos demandes depuis le BO.';

  @override
  String get proMarketingStep1Title => 'Ajouter votre profil';

  @override
  String get proMarketingStep1Body =>
      'Renseignez votre service, votre zone et vos coordonnées.';

  @override
  String get proMarketingStep2Title => 'Choisir un plan';

  @override
  String get proMarketingStep2Body =>
      'Activez un abonnement adapté à votre volume de leads.';

  @override
  String get proMarketingStep3Title => 'Piloter vos offres';

  @override
  String get proMarketingStep3Body =>
      'Suivez vos réponses, vos attributions et votre conversion.';

  @override
  String get proMarketingLeaveDetails => 'Laisser mes coordonnées';

  @override
  String get proMarketingSeeSubscriptions => 'Voir les abonnements';

  @override
  String get proMarketingBalanced => 'Le plus équilibré';

  @override
  String proMarketingRequestsPerMonth(Object count) {
    return '$count demandes par mois';
  }

  @override
  String get boAccessLoadingHint => 'Chargement du code d’accès...';

  @override
  String get boAccessInvalidCode =>
      'Code invalide. Vérifiez le code BO et réessayez.';

  @override
  String get boAccessDescription =>
      'Le back-office permet de piloter les demandes, vos offres et le professionnel actif. L’accès est limité à une session sécurisée de 30 minutes.';

  @override
  String get boAccessSession => 'Session 30 min';

  @override
  String get boAccessPrivate => 'Accès privé';

  @override
  String get boAccessUnlockTitle => 'Déverrouiller le BO';

  @override
  String get boAccessCodeLabel => 'Code BO';

  @override
  String get boAccessCodeHint => 'Saisir 6 chiffres';

  @override
  String get boCommonUnlock => 'Déverrouiller';

  @override
  String get categoryAdminLabelRequired =>
      'Renseignez un libellé de catégorie.';

  @override
  String get categoryAdminFirebaseUnavailable =>
      'Firebase n’est pas disponible pour le moment.';

  @override
  String get categoryAdminCreated => 'Catégorie ajoutée.';

  @override
  String get categoryAdminCreateFailed => 'Échec de l’ajout de la catégorie.';

  @override
  String get categoryAdminDeleteTitle => 'Supprimer la catégorie';

  @override
  String get categoryAdminDeleteBody =>
      'Cette action retirera la catégorie de l’accueil et du formulaire de demande.';

  @override
  String get categoryAdminDeleted => 'Catégorie supprimée.';

  @override
  String get categoryAdminDeleteFailed =>
      'Échec de la suppression de la catégorie.';

  @override
  String get categoryAdminUpdated => 'Catégorie mise à jour.';

  @override
  String get categoryAdminUpdateFailed =>
      'Échec de la mise à jour de la catégorie.';

  @override
  String get categoryAdminReorderFailed =>
      'Échec de la mise à jour de l’ordre des catégories.';

  @override
  String get categoryAdminEditTitle => 'Modifier la catégorie';

  @override
  String get categoryAdminLabel => 'Libellé';

  @override
  String get categoryAdminIcon => 'Icône';

  @override
  String get categoryAdminTitle => 'Catégories';

  @override
  String get boCommonBackToBo => 'Retour BO';

  @override
  String get categoryAdminHeroTitle => 'Catégories de services';

  @override
  String get categoryAdminHeroBody =>
      'Gérez les catégories visibles sur l’accueil et dans le formulaire de demande, sans passer par la console Firebase.';

  @override
  String get categoryAdminAddTitle => 'Ajouter une catégorie';

  @override
  String get categoryAdminLabelHint => 'Ex. Climatisation';

  @override
  String get categoryAdminAdding => 'Ajout...';

  @override
  String get categoryAdminAddAction => 'Ajouter la catégorie';

  @override
  String get boCommonMoveUp => 'Monter';

  @override
  String get boCommonMoveDown => 'Descendre';

  @override
  String get boCommonEdit => 'Modifier';

  @override
  String get boCommonDelete => 'Supprimer';

  @override
  String categoryAdminPositionIcon(Object position, Object icon) {
    return 'Position $position • Icône : $icon';
  }

  @override
  String get categoryAdminEmptyTitle => 'Aucune catégorie configurée';

  @override
  String get categoryAdminEmptyBody =>
      'Ajoutez votre première catégorie pour alimenter l’accueil et le formulaire de demande.';

  @override
  String get categoryAdminOfflineTitle => 'Firebase indisponible';

  @override
  String get categoryAdminOfflineBody =>
      'La gestion des catégories nécessite une connexion Firebase active.';

  @override
  String get boCommonCancel => 'Annuler';

  @override
  String get boCommonSave => 'Enregistrer';

  @override
  String get boCommonSaving => 'Enregistrement...';

  @override
  String get requestAdminStatusUpdated => 'Statut de la demande mis à jour.';

  @override
  String get requestAdminEditTitle => 'Modifier la demande';

  @override
  String get requestAdminService => 'Service';

  @override
  String get requestAdminUrgency => 'Urgence';

  @override
  String get requestAdminDescription => 'Description';

  @override
  String get requestAdminLocation => 'Localisation';

  @override
  String get requestAdminPhone => 'Téléphone';

  @override
  String get requestAdminOffersCount => 'Nombre d’offres';

  @override
  String get requestAdminStatus => 'Statut';

  @override
  String get requestAdminOffersStatus => 'Statut des offres';

  @override
  String get requestAdminOffersStatusOpen => 'Ouvert';

  @override
  String get requestAdminOffersStatusAccepted => 'Accepté';

  @override
  String get requestAdminOffersStatusClosed => 'Fermé';

  @override
  String get requestAdminRequiredFields =>
      'Tous les champs principaux doivent être remplis.';

  @override
  String get requestAdminUpdated => 'Demande mise à jour.';

  @override
  String get requestAdminUpdateFailed => 'Échec de la mise à jour.';

  @override
  String get requestAdminDeleteTitle => 'Supprimer la demande';

  @override
  String requestAdminDeleteBody(Object service, Object location) {
    return 'Supprimer la demande $service de $location ?';
  }

  @override
  String get requestAdminDeleted => 'Demande supprimée.';

  @override
  String get requestAdminDeleteFailed => 'Échec de la suppression.';

  @override
  String requestAdminPhoneValue(Object phone) {
    return 'Téléphone : $phone';
  }

  @override
  String requestAdminOffersValue(Object count, Object status) {
    return 'Offres : $count • $status';
  }

  @override
  String get requestAdminRelaunch => 'Relancer';

  @override
  String get requestAdminTitle => 'Demandes BO';

  @override
  String get requestAdminFirebaseUnavailable => 'Firebase indisponible';

  @override
  String get requestAdminHeroEyebrow => 'Gestion des demandes';

  @override
  String requestAdminHeroCount(Object count) {
    return '$count demande(s) enregistrée(s)';
  }

  @override
  String get requestAdminHeroBody =>
      'Modifiez ou supprimez les demandes clients stockées dans /requests.';

  @override
  String get requestAdminEmpty =>
      'Aucune demande n’est encore disponible dans Firebase.';
}
