// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'LigueyPro 2.0';

  @override
  String get splashHeadline => 'YOUR SERVICES,';

  @override
  String get splashTagline => 'CLOSER · SIMPLER';

  @override
  String get splashCopyright => '© 2026 LigueyPro 2.0. All rights reserved.';

  @override
  String get profileTitle => 'My profile';

  @override
  String get profileAccountTitle => 'My account';

  @override
  String get profileAccountSubtitle =>
      'Manage your requests, preferences, and professional space.';

  @override
  String get profileSectionRequests => 'REQUESTS';

  @override
  String get profileNewRequest => 'New request';

  @override
  String get profileMyRequests => 'My requests';

  @override
  String get profileSectionProNetwork => 'PRO NETWORK';

  @override
  String get profileAddProfessional => 'Add a professional';

  @override
  String get profileAllProfessionals => 'All professionals';

  @override
  String get profileSectionApplication => 'APPLICATION';

  @override
  String get profilePresentation => 'App presentation';

  @override
  String get profileSectionSupport => 'SUPPORT';

  @override
  String get profileHelpSupport => 'Help and support';

  @override
  String get profileTerms => 'Terms';

  @override
  String get profileSettingsShort => 'Settings';

  @override
  String get commonNotifications => 'Notifications';

  @override
  String get commonLocation => 'Location';

  @override
  String get commonLanguage => 'Language';

  @override
  String get commonVersion => 'Version';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonSave => 'Save';

  @override
  String get commonLoading => 'Loading...';

  @override
  String get settingsTitle => 'Application settings';

  @override
  String get settingsPreferences => 'Preferences';

  @override
  String get settingsSubtitle => 'Manage the main LigueyPro settings.';

  @override
  String get settingsNotificationsSubtitle =>
      'Receive alerts for new requests.';

  @override
  String get settingsLocationSubtitle =>
      'Use your position to make requests easier.';

  @override
  String get settingsVideoAutoplay => 'Video autoplay';

  @override
  String get settingsVideoAutoplaySubtitle =>
      'Automatically play the presentation video.';

  @override
  String get settingsNotificationsDenied =>
      'Notifications are denied. Allow them in system settings.';

  @override
  String get settingsNotificationsDisableInSystem =>
      'Disable notifications in system settings if needed.';

  @override
  String get settingsLocationDenied =>
      'Location is denied. Allow it in system settings.';

  @override
  String get settingsLocationDisableInSystem =>
      'Disable location in system settings if needed.';

  @override
  String get settingsLanguageUpdated => 'App language updated.';

  @override
  String get settingsLanguageFrenchInterface => 'French interface';

  @override
  String get settingsLanguageEnglishInterface => 'English interface';

  @override
  String get settingsBackOfficeHintUnavailable =>
      'BO code unavailable. Check the Firebase key security/backoffice/access_code.';

  @override
  String settingsBackOfficeHintActive(Object prefix) {
    return 'Active BO code in Firebase: $prefix- *** (6 digits)';
  }

  @override
  String get settingsBackOfficeSecurity => 'Back-office security';

  @override
  String get settingsBackOfficeStatusOpen => 'Unlocked';

  @override
  String get settingsBackOfficeStatusLocked => 'Locked';

  @override
  String get settingsBackOfficeChangeCode => 'Change BO code';

  @override
  String get settingsBackOfficeCodeUnavailable => 'Firebase BO code not loaded';

  @override
  String settingsBackOfficeCodeActive(Object code) {
    return 'Active code: $code';
  }

  @override
  String get settingsBackOfficeLockTitle => 'Lock back office';

  @override
  String get settingsBackOfficeLockSubtitle =>
      'Immediately end the current BO session';

  @override
  String get settingsBackOfficeLockedNow => 'Back office locked immediately.';

  @override
  String get settingsBackOfficeDialogTitle => 'Back-office code';

  @override
  String get settingsBackOfficeDialogDescription =>
      'Set a 6-digit code to protect back-office access.';

  @override
  String get settingsBackOfficeNewCode => 'New code';

  @override
  String get settingsSixDigits => '6 digits';

  @override
  String get settingsBackOfficeCodeInvalid =>
      'The BO code must contain exactly 6 digits.';

  @override
  String get settingsBackOfficeCodeSaved =>
      'Firebase BO code saved. The session has been locked again.';

  @override
  String notificationsHeaderCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notifications available.',
      one: '1 notification available.',
      zero: 'No alerts for the moment.',
    );
    return '$_temp0';
  }

  @override
  String get notificationsManagePermissions => 'Manage permissions';

  @override
  String get notificationsEmptyTitle => 'No notifications to display';

  @override
  String get notificationsEmptyDescription =>
      'New requests and important alerts will appear here in real time.';

  @override
  String get notificationsFirebaseUnavailable =>
      'Notifications are not available until Firebase is initialized.';

  @override
  String get notificationsLoadError =>
      'Unable to load notifications right now.';

  @override
  String get notificationsDefaultRequestTitle => 'New request';

  @override
  String get notificationsDefaultRequestBody => 'A request has been submitted.';

  @override
  String get notificationsDefaultCategory => 'Uncategorized';

  @override
  String get helpSupportHowItWorks => 'How it works';

  @override
  String get helpSupportFindServiceTitle => 'Find a service';

  @override
  String get helpSupportFindServiceDescription =>
      'Choose a category or use search to find the right professional near you.';

  @override
  String get helpSupportCreateRequestTitle => 'Create a request';

  @override
  String get helpSupportCreateRequestDescription =>
      'Describe your need, choose the category, and specify urgency, location, and phone number.';

  @override
  String get helpSupportTrackRequestTitle => 'Track your request';

  @override
  String get helpSupportTrackRequestDescription =>
      'Check My requests to see the status and urgency order of interventions.';

  @override
  String get helpSupportFaqTitle => 'Frequently asked questions';

  @override
  String get helpSupportFaqEditQuestion => 'How can I edit a request?';

  @override
  String get helpSupportFaqEditAnswer =>
      'Go to your requests list and select the relevant request to review or correct the information.';

  @override
  String get helpSupportFaqNoReplyQuestion =>
      'What if I don’t receive a response?';

  @override
  String get helpSupportFaqNoReplyAnswer =>
      'You can relaunch your request, verify the selected urgency, and confirm your phone number to be contacted again.';

  @override
  String get helpSupportFaqContactQuestion => 'How can I contact support?';

  @override
  String get helpSupportFaqContactAnswer =>
      'You can write to us through the in-app support or call the assistance center available in your region.';

  @override
  String get helpSupportNeedHelpTitle => 'Need assistance?';

  @override
  String get helpSupportNeedHelpDescription =>
      'Our team can help you create a request, track it, or resolve a technical issue.';

  @override
  String get cguTitle => 'Terms and conditions of use';

  @override
  String get cguIntro =>
      'Welcome to LigueyPro. By using this application, you accept these terms and conditions.';

  @override
  String get cguSection1Title => '1. Purpose';

  @override
  String get cguSection1Body =>
      'The application aims to connect users with service professionals available in their geographic area.';

  @override
  String get cguSection2Title => '2. Use of the service';

  @override
  String get cguSection2Body =>
      'You agree to provide accurate information, including your location, phone number, and description of your need. You must use the application responsibly and in compliance with the law.';

  @override
  String get cguSection3Title => '3. Requests and professionals';

  @override
  String get cguSection3Body =>
      'Submitted requests are transmitted to available professionals. Availability, pricing, and timelines may vary depending on the provider’s actual conditions and the request itself.';

  @override
  String get cguSection4Title => '4. Responsibilities';

  @override
  String get cguSection4Body =>
      'The application serves only as a matchmaking platform. LigueyPro is not directly responsible for services performed by professionals, achieved results, or any disputes between users and providers.';

  @override
  String get cguSection5Title => '5. Personal data';

  @override
  String get cguSection5Body =>
      'Collected data, including phone number and location, is used to facilitate matchmaking and request tracking. It must be processed in compliance with data protection regulations.';

  @override
  String get cguSection6Title => '6. Changes';

  @override
  String get cguSection6Body =>
      'We may modify these terms at any time. Significant changes will be indicated in the application or through available channels.';

  @override
  String get cguConclusion =>
      'By continuing to use the application, you confirm that you have read and accepted these terms.';

  @override
  String get homeNavHome => 'Home';

  @override
  String get homeNavRequests => 'Requests';

  @override
  String get homeNavPros => 'Pros';

  @override
  String get homeNavProfile => 'Profile';

  @override
  String get homeGreeting => 'Hello 👋';

  @override
  String get homeQuestion => 'What service do you need?';

  @override
  String get homeDefaultHeroTitle => 'Need a pro right away?';

  @override
  String get homeDefaultHeroSubtitle =>
      'Submit your request in less than a minute and get a quick response.';

  @override
  String get homeDefaultHeroPrimaryCta => 'Urgent request';

  @override
  String get homeDefaultHeroSecondaryCta => 'See pros';

  @override
  String get homeMetricVerifiedPros => 'Verified pros';

  @override
  String get homeMetricAverageResponse => 'Average response';

  @override
  String get homeMetricAverageRating => 'Average rating';

  @override
  String get homeMetricNotAvailable => 'N/A';

  @override
  String homeReviewsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reviews',
      one: '1 review',
    );
    return '$_temp0';
  }

  @override
  String get homeCategoriesEmptyTitle => 'No categories available';

  @override
  String get homeCategoriesEmptyDescription =>
      'Add categories under home/categories in Firebase to populate the home screen.';

  @override
  String get homeSearchFallback => 'Search';

  @override
  String get homeSearchHint => 'Search for a service...';

  @override
  String get homeRecentRequestTitle => 'Latest request';

  @override
  String get homeAcceptedOfferTitle => 'Selected offer';

  @override
  String homeAcceptedPrice(Object price) {
    return 'Accepted price: $price';
  }

  @override
  String homeConfirmedEta(Object eta) {
    return 'Confirmed timeline: $eta';
  }

  @override
  String get homeTrackRequest => 'Track my request';

  @override
  String get homeNewRequest => 'New request';

  @override
  String get homePopularServices => 'Popular services';

  @override
  String get homeNeedHelpTitle => 'Need help?';

  @override
  String get homeNeedHelpDescription =>
      'Describe your problem. LigueyPro AI helps you find the right professional.';

  @override
  String get homeSeePresentation => 'See presentation';

  @override
  String get homeStatusAccepted => 'Accepted';

  @override
  String get homeStatusAwaitingOffers => 'Awaiting offers';

  @override
  String get homeStatusInProgress => 'In progress';

  @override
  String get homeStatusCompleted => 'Completed';

  @override
  String get homeStatusPending => 'Pending';

  @override
  String get presentationTitle => 'Application presentation';

  @override
  String get presentationSubtitle => 'Find the right service near you';

  @override
  String get presentationVideoLabel => 'Presentation video';

  @override
  String get presentationWhyTitle => 'Why LigueyPro 2.0?';

  @override
  String get presentationFeatureFastSearchTitle => 'Fast search';

  @override
  String get presentationFeatureFastSearchDescription =>
      'Find a service that fits your need in seconds.';

  @override
  String get presentationFeatureReliableProsTitle => 'Reliable professionals';

  @override
  String get presentationFeatureReliableProsDescription =>
      'Browse reviews, ratings, and available profiles.';

  @override
  String get presentationFeatureSimpleTrackingTitle => 'Simple tracking';

  @override
  String get presentationFeatureSimpleTrackingDescription =>
      'Track your requests and receive useful notifications.';

  @override
  String get requestPageTitle => 'New request';

  @override
  String get requestPageDescribeNeed => 'Describe your need';

  @override
  String get requestNeedDescription => 'Please describe your need.';

  @override
  String get requestNeedPhone => 'Please enter your phone number.';

  @override
  String get requestNoServiceAvailable => 'No service is available right now.';

  @override
  String get requestDialogSentTitle => 'Request sent';

  @override
  String get requestDialogSentBody =>
      'Your request has been published. Subscribed professionals can now receive it and send you their offers.';

  @override
  String get requestDialogViewMyRequests => 'See my requests';

  @override
  String get requestSaveFailed => 'Failed to save request. Please try again.';

  @override
  String get requestFirebaseNoService => 'No service available in Firebase.';

  @override
  String get requestServiceTypeLabel => 'Service type';

  @override
  String get requestSummaryTitle => 'Summary of your request';

  @override
  String requestSummaryService(Object service) {
    return 'Service: $service';
  }

  @override
  String requestSummaryUrgency(Object urgency) {
    return 'Urgency: $urgency';
  }

  @override
  String get requestSummaryNoService => 'Unavailable';

  @override
  String get requestSummaryImproveMatching =>
      'Add a clear description to improve matching.';

  @override
  String get requestDirectPaymentNotice =>
      'Direct payment: the client then pays the professional outside the app after receiving offers.';

  @override
  String get requestUrgencyTitle => 'Urgency';

  @override
  String get requestDescriptionTitle => 'Description';

  @override
  String get requestDescriptionHint =>
      'Example: My air conditioner is no longer cooling…';

  @override
  String get requestPhoneLabel => 'Phone number';

  @override
  String get requestPhoneHint => '+221 77 123 45 67';

  @override
  String get requestLocationLabel => 'Location';

  @override
  String get requestLocationHint => 'Your address or neighborhood';

  @override
  String get requestPublish => 'Publish request';

  @override
  String get requestDefaultLocation => 'Dakar, Senegal';

  @override
  String get requestUnknownLocation => 'Location not provided';

  @override
  String get requestsMyTitle => 'My requests';

  @override
  String get requestsAllTypes => 'All types';

  @override
  String get requestsAllCategories => 'All categories';

  @override
  String get requestsFilterTitle => 'Filters';

  @override
  String get requestsFilterTypeLabel => 'Request type';

  @override
  String get requestsFilterCategoryLabel => 'Category';

  @override
  String get requestsFilterDateLabel => 'Sort by date';

  @override
  String get requestsSortNewest => 'Newest first';

  @override
  String get requestsSortOldest => 'Oldest first';

  @override
  String get requestsLoading => 'Loading requests...';

  @override
  String get requestsStatusAccepted => 'Accepted';

  @override
  String get requestsStatusAwaitingOffers => 'Awaiting offers';

  @override
  String get requestsStatusEnRoute => 'On the way';

  @override
  String get requestsStatusInProgress => 'In progress';

  @override
  String get requestsStatusCompleted => 'Completed';

  @override
  String get requestsStatusCancelled => 'Cancelled';

  @override
  String get requestsStatusPending => 'Pending';

  @override
  String get requestsOffersAccepted => 'Offer accepted';

  @override
  String get requestsOffersClosed => 'Bidding closed';

  @override
  String get requestsOffersOpen => 'Offers open';

  @override
  String requestsCreatedOn(Object date) {
    return 'Created on $date';
  }

  @override
  String requestsOffersCountSummary(Object status, Object count) {
    return '$status • $count offer(s)';
  }

  @override
  String get requestsDirectPaymentAfterOffer =>
      'Direct payment between client and professional after choosing the offer.';

  @override
  String get requestsChosenProfessional => 'Selected professional';

  @override
  String requestsAcceptedPrice(Object price) {
    return 'Accepted price: $price';
  }

  @override
  String requestsConfirmedEta(Object eta) {
    return 'Confirmed timeline: $eta';
  }

  @override
  String get requestsViewProfile => 'View profile';

  @override
  String get requestsViewOffers => 'View offers';

  @override
  String get requestsEmptyTitle => 'No request sent';

  @override
  String get requestsEmptyMessage =>
      'Your requests will appear here with their status, offers, and history.';

  @override
  String get requestsNoFilterResultsTitle => 'No result for these filters';

  @override
  String get requestsNoFilterResultsMessage =>
      'Change the type, category, or sorting to display other requests.';

  @override
  String get requestsNoRequestsAvailable => 'No request available right now.';

  @override
  String get requestOffersTitle => 'Received offers';

  @override
  String requestOffersAcceptedMessage(Object name) {
    return 'Offer from $name accepted. Payment is then made directly.';
  }

  @override
  String get requestOffersEmptyTitle => 'No offers received yet';

  @override
  String get requestOffersEmptyMessage =>
      'Subscribed professionals will see your request and will soon be able to propose their prices and timelines.';

  @override
  String get requestOffersBadgeAccepted => 'Offer accepted';

  @override
  String get requestOffersBadgeHighlighted => 'Highlighted offer';

  @override
  String get requestOffersCallPro => 'Call the pro';

  @override
  String get requestOffersContact => 'Contact';

  @override
  String get requestOffersRetained => 'Selected offer';

  @override
  String get requestOffersAlreadyAssigned => 'Already assigned';

  @override
  String get requestOffersValidating => 'Validating...';

  @override
  String get requestOffersChooseThis => 'Choose this offer';

  @override
  String get serviceSearchTitle => 'Search';

  @override
  String get serviceSearchAdd => 'Add';

  @override
  String get serviceSearchNearby => 'Nearby professionals';

  @override
  String serviceSearchResultsFor(Object query) {
    return 'Results for \"$query\"';
  }

  @override
  String get serviceSearchFilterDescription =>
      'Filter the most reliable, available, and top-rated profiles.';

  @override
  String get serviceSearchFilterAll => 'All';

  @override
  String get serviceSearchFilterVerified => 'Verified';

  @override
  String get serviceSearchFilterAvailable => 'Available';

  @override
  String get serviceSearchFilterTopRated => 'Top rated';

  @override
  String get serviceSearchBadgeVerified => 'Verified';

  @override
  String get serviceSearchBadgeAvailable => 'Available';

  @override
  String get serviceSearchSee => 'View';

  @override
  String get serviceSearchEmptyTitle => 'No professional found';

  @override
  String get serviceSearchEmptyMessage =>
      'No profile matches this search in Firebase right now.';

  @override
  String get serviceSearchDefaultPrice => 'To be confirmed';

  @override
  String get serviceSearchDefaultResponseTime => 'Quick response';

  @override
  String get addProfessionalInfoTitle => 'Professional information';

  @override
  String get addProfessionalNoService => 'No service available right now.';

  @override
  String get addProfessionalFillAll => 'Please fill in all fields.';

  @override
  String get addProfessionalSuccess => 'Professional added successfully.';

  @override
  String get addProfessionalSaveFailed =>
      'Failed to add professional. Please try again.';

  @override
  String get addProfessionalNameLabel => 'Professional name';

  @override
  String get addProfessionalServiceLabel => 'Service';

  @override
  String get addProfessionalLocationLabel => 'Service area';

  @override
  String get addProfessionalPriceLabel => 'Price / Pricing';

  @override
  String get addProfessionalPhoneLabel => 'Phone';

  @override
  String get addProfessionalPhoneHint => '+221 77 000 00 00';

  @override
  String get addProfessionalResponseLabel => 'Estimated response time';

  @override
  String get addProfessionalResponseHint => 'Example: Replies within 15 min';

  @override
  String get addProfessionalAvailableNowTitle => 'Available immediately';

  @override
  String get addProfessionalAvailableNowSubtitle =>
      'Shown as available in results.';

  @override
  String get addProfessionalSave => 'Save professional';

  @override
  String get professionalPageTitle => 'Professional profile';

  @override
  String get professionalRequestService => 'Request a service';

  @override
  String get professionalWhatsappUnavailable =>
      'WhatsApp is not available on this device.';

  @override
  String get professionalReviewNoComment => 'No comment';

  @override
  String get professionalNoReviewsYet => 'No reviews yet';

  @override
  String get professionalJustNow => 'just now';

  @override
  String professionalMinutesAgo(Object minutes) {
    return '$minutes min ago';
  }

  @override
  String professionalHoursAgo(Object hours) {
    return '$hours h ago';
  }

  @override
  String professionalDaysAgo(Object days) {
    return '$days d ago';
  }

  @override
  String get professionalTrust => 'Trust';

  @override
  String get professionalTrustVerified => 'Verified badge';

  @override
  String get professionalTrustStandard => 'Standard profile';

  @override
  String get professionalInterventions => 'Jobs';

  @override
  String professionalInterventionsCount(Object count) {
    return '$count completed';
  }

  @override
  String get professionalResponse => 'Response';

  @override
  String get professionalChooseRating => 'Please choose a rating.';

  @override
  String get professionalNotFoundForRating =>
      'Professional not found to save the rating.';

  @override
  String professionalThanksForRating(Object rating) {
    return 'Thanks for your $rating/5 rating.';
  }

  @override
  String get professionalRatingSaveFailed =>
      'Failed to save rating. Please try again.';

  @override
  String get professionalNotFoundTitle => 'Profile not found';

  @override
  String get professionalNotFoundMessage =>
      'This professional is not in Firebase or is no longer available.';

  @override
  String get professionalLoading => 'Loading...';

  @override
  String get professionalDefaultBadge => 'Professional';

  @override
  String get professionalVerifiedBadge => 'Verified profile';

  @override
  String get professionalSubscribedBadge => 'Pro subscriber';

  @override
  String get professionalAvailableBadge => 'Available now';

  @override
  String professionalSubscriptionInfo(Object plan) {
    return 'This professional is subscribed to the $plan plan and can receive your requests and send you offers.';
  }

  @override
  String get professionalInfoSection => 'Information';

  @override
  String get professionalLocationSubtitle => 'Service area';

  @override
  String get professionalServiceSubtitle => 'Main service';

  @override
  String get professionalPriceSubtitle => 'Pricing indication';

  @override
  String get professionalCall => 'Call';

  @override
  String get professionalWhatsapp => 'WhatsApp';

  @override
  String get professionalRecentReviews => 'Recent reviews';

  @override
  String get professionalNoRecentReviews =>
      'No recent review available for this professional.';

  @override
  String get professionalRateTitle => 'Rate this professional';

  @override
  String get professionalReviewLabel => 'Your review';

  @override
  String get professionalReviewHint => 'Describe your experience...';

  @override
  String get professionalValidateRating => 'Submit rating';

  @override
  String get professionalUnknownLocation => 'Location not provided';

  @override
  String get professionalUnknownPrice => 'Price to be confirmed';

  @override
  String get professionalUnknownService => 'Service not provided';

  @override
  String get professionalUnknownResponse => 'Response time not provided';

  @override
  String get proSubscriptionTitle => 'Pro subscription';

  @override
  String get proSubscriptionActivated =>
      'Simulated Pro subscription activated. Then connect your real payment method.';

  @override
  String get proSubscriptionHeroTitle => 'Receive requests and send offers';

  @override
  String get proSubscriptionHeroBody =>
      'The subscription replaces in-app customer payment. Professionals pay to receive opportunities and answer with their offers.';

  @override
  String proSubscriptionLeadsIncluded(Object count) {
    return '$count requests included per month';
  }

  @override
  String proSubscriptionSelectedPlan(Object plan) {
    return 'Selected plan: $plan. Subscribed professionals can receive requests and send offers without in-app customer payment.';
  }

  @override
  String proSubscriptionChoosePlan(Object plan) {
    return 'Choose $plan';
  }

  @override
  String get landingWhyTitle => 'Why LigueyPro';

  @override
  String get landingWhySubtitle =>
      'A local marketplace designed to accelerate the connection between clients and subscribed professionals.';

  @override
  String get landingFeatureExpressTitle => 'Express request';

  @override
  String get landingFeatureExpressBody =>
      'The client publishes their need in seconds with urgency, area, and phone number.';

  @override
  String get landingFeatureOffersTitle => 'Comparable offers';

  @override
  String get landingFeatureOffersBody =>
      'Subscribed pros reply with price, timeline, and a personalized message.';

  @override
  String get landingFeatureBackOfficeTitle => 'Secure back office';

  @override
  String get landingFeatureBackOfficeBody =>
      'The back office helps manage requests, offers, and commercial performance.';

  @override
  String get landingMetricsTitle => 'Key metrics';

  @override
  String get landingMetricsSubtitle =>
      'Real figures from Firebase reflecting the volume and quality of LigueyPro activity.';

  @override
  String get landingMetricActivePros => 'Active professionals';

  @override
  String get landingMetricPublishedRequests => 'Published requests';

  @override
  String get landingMetricSentOffers => 'Sent offers';

  @override
  String get landingMetricAverageRating => 'Average rating';

  @override
  String landingMetricAverageRatingWithReviews(Object count) {
    return 'Average rating ($count reviews)';
  }

  @override
  String get landingSwitchAppTitle => 'Move to the app';

  @override
  String get landingSwitchAppBody =>
      'Browse services, publish a request, or open your secure professional back office.';

  @override
  String get landingNavProfessionals => 'Professionals';

  @override
  String get landingNavPresentation => 'Presentation';

  @override
  String get landingNavBackOffice => 'Back office';

  @override
  String get landingBrandSubtitle =>
      'Senegalese services marketplace and professional back office';

  @override
  String get landingHeroBadge => 'Client + Professional + Back office';

  @override
  String get landingHeroCompactTitle => 'The right pro, faster.';

  @override
  String get landingHeroWideTitle =>
      'Publish a request, compare offers, and run your operations from a secure back office.';

  @override
  String landingHeroBody(
      Object subscribedCount, Object offersCount, Object responseTime) {
    return 'LigueyPro connects everyday needs to $subscribedCount subscribed professional(s), with $offersCount offer(s) already sent and an average response time of $responseTime.';
  }

  @override
  String get landingHeroServicesCovered => 'services covered';

  @override
  String get landingHeroVerifiedPros => 'verified pros';

  @override
  String get landingHeroSubscribedPros => 'subscribed pros';

  @override
  String get landingQuickAccessTitle => 'Quick access';

  @override
  String get landingQuickAccessSubtitle =>
      'Choose your path depending on your role or current objective.';

  @override
  String get landingAccessBrowseTitle => 'Browse the app';

  @override
  String get landingAccessBrowseSubtitle =>
      'Discover services and publish a request.';

  @override
  String get landingAccessBecomeProTitle => 'Become a professional';

  @override
  String get landingAccessBecomeProSubtitle =>
      'Discover subscriptions and leave your contact details.';

  @override
  String get landingAccessBackOfficeTitle => 'Open the back office';

  @override
  String get landingAccessBackOfficeSubtitle =>
      'Protected access to leads, offers, and statistics.';

  @override
  String get landingAccessPresentationTitle => 'See the presentation';

  @override
  String get landingAccessPresentationSubtitle =>
      'Understand how LigueyPro works.';

  @override
  String get landingEnterApp => 'Enter the app';

  @override
  String get landingSecureBo => 'Access the secure back office';

  @override
  String get landingNotAvailable => 'N/A';

  @override
  String get proMarketingTitle => 'LigueyPro for professionals';

  @override
  String get proMarketingSubtitle =>
      'Leads, offers, subscription, and secure back office';

  @override
  String get proMarketingHome => 'Home';

  @override
  String get proMarketingHeroBadge => 'Pro subscription + conversion';

  @override
  String get proMarketingHeroTitle =>
      'Receive more qualified opportunities and respond faster than your competitors.';

  @override
  String get proMarketingHeroBody =>
      'LigueyPro helps subscribed professionals capture real requests, send structured offers, and manage their activity with simple metrics.';

  @override
  String get proMarketingMetricLeads => 'monthly leads on the Pro plan';

  @override
  String get proMarketingMetricSecurity => 'digits protecting the back office';

  @override
  String get proMarketingMetricWorkflow => 'simple acquisition workflow';

  @override
  String get proMarketingWhyTitle => 'Why subscribe';

  @override
  String get proMarketingWhySubtitle =>
      'The LigueyPro model replaces in-app client payment with a simple professional subscription model.';

  @override
  String get proMarketingValueLeadsTitle => 'Receive targeted requests';

  @override
  String get proMarketingValueLeadsBody =>
      'Access requests related to your trade and your service area.';

  @override
  String get proMarketingValueOffersTitle => 'Send clear offers';

  @override
  String get proMarketingValueOffersBody =>
      'Reply with your prices, timelines, and a reassuring message to improve conversion.';

  @override
  String get proMarketingValuePerformanceTitle => 'Track your performance';

  @override
  String get proMarketingValuePerformanceBody =>
      'Follow your offers, revenue, and indicators in a secure back office.';

  @override
  String get proMarketingPlansTitle => 'Professional plans';

  @override
  String get proMarketingPlansSubtitle =>
      'Choose an engagement level that fits your request volume and commercial ambition.';

  @override
  String get proMarketingCtaTitle => 'Ready to activate your pro profile?';

  @override
  String get proMarketingCtaBody =>
      'Add your profile, choose your subscription, and then access your secure back office to process requests.';

  @override
  String get proMarketingGetStartedTitle => 'Get started in 3 steps';

  @override
  String get proMarketingGetStartedBody =>
      'Create your profile, activate your subscription, then handle your requests from the back office.';

  @override
  String get proMarketingStep1Title => 'Add your profile';

  @override
  String get proMarketingStep1Body =>
      'Enter your service, your area, and your contact details.';

  @override
  String get proMarketingStep2Title => 'Choose a plan';

  @override
  String get proMarketingStep2Body =>
      'Activate a subscription matching your lead volume.';

  @override
  String get proMarketingStep3Title => 'Manage your offers';

  @override
  String get proMarketingStep3Body =>
      'Track your replies, assignments, and conversion.';

  @override
  String get proMarketingLeaveDetails => 'Leave my contact details';

  @override
  String get proMarketingSeeSubscriptions => 'See subscriptions';

  @override
  String get proMarketingBalanced => 'Most balanced';

  @override
  String proMarketingRequestsPerMonth(Object count) {
    return '$count requests per month';
  }

  @override
  String get boAccessLoadingHint => 'Loading access code...';

  @override
  String get boAccessInvalidCode =>
      'Invalid code. Check the back-office code and try again.';

  @override
  String get boAccessDescription =>
      'The back office lets you manage requests, your offers, and the active professional. Access is limited to a secure 30-minute session.';

  @override
  String get boAccessSession => '30 min session';

  @override
  String get boAccessPrivate => 'Private access';

  @override
  String get boAccessUnlockTitle => 'Unlock back office';

  @override
  String get boAccessCodeLabel => 'Back-office code';

  @override
  String get boAccessCodeHint => 'Enter 6 digits';

  @override
  String get boCommonUnlock => 'Unlock';

  @override
  String get categoryAdminLabelRequired => 'Enter a category label.';

  @override
  String get categoryAdminFirebaseUnavailable =>
      'Firebase is not available right now.';

  @override
  String get categoryAdminCreated => 'Category added.';

  @override
  String get categoryAdminCreateFailed => 'Failed to add category.';

  @override
  String get categoryAdminDeleteTitle => 'Delete category';

  @override
  String get categoryAdminDeleteBody =>
      'This action will remove the category from the home screen and request form.';

  @override
  String get categoryAdminDeleted => 'Category deleted.';

  @override
  String get categoryAdminDeleteFailed => 'Failed to delete category.';

  @override
  String get categoryAdminUpdated => 'Category updated.';

  @override
  String get categoryAdminUpdateFailed => 'Failed to update category.';

  @override
  String get categoryAdminReorderFailed => 'Failed to update category order.';

  @override
  String get categoryAdminEditTitle => 'Edit category';

  @override
  String get categoryAdminLabel => 'Label';

  @override
  String get categoryAdminIcon => 'Icon';

  @override
  String get categoryAdminTitle => 'Categories';

  @override
  String get boCommonBackToBo => 'Back to BO';

  @override
  String get categoryAdminHeroTitle => 'Service categories';

  @override
  String get categoryAdminHeroBody =>
      'Manage categories visible on the home screen and in the request form without using the Firebase console.';

  @override
  String get categoryAdminAddTitle => 'Add a category';

  @override
  String get categoryAdminLabelHint => 'Example: Air conditioning';

  @override
  String get categoryAdminAdding => 'Adding...';

  @override
  String get categoryAdminAddAction => 'Add category';

  @override
  String get boCommonMoveUp => 'Move up';

  @override
  String get boCommonMoveDown => 'Move down';

  @override
  String get boCommonEdit => 'Edit';

  @override
  String get boCommonDelete => 'Delete';

  @override
  String categoryAdminPositionIcon(Object position, Object icon) {
    return 'Position $position • Icon: $icon';
  }

  @override
  String get categoryAdminEmptyTitle => 'No category configured';

  @override
  String get categoryAdminEmptyBody =>
      'Add your first category to feed the home screen and request form.';

  @override
  String get categoryAdminOfflineTitle => 'Firebase unavailable';

  @override
  String get categoryAdminOfflineBody =>
      'Category management requires an active Firebase connection.';

  @override
  String get boCommonCancel => 'Cancel';

  @override
  String get boCommonSave => 'Save';

  @override
  String get boCommonSaving => 'Saving...';

  @override
  String get requestAdminStatusUpdated => 'Request status updated.';

  @override
  String get requestAdminEditTitle => 'Edit request';

  @override
  String get requestAdminService => 'Service';

  @override
  String get requestAdminUrgency => 'Urgency';

  @override
  String get requestAdminDescription => 'Description';

  @override
  String get requestAdminLocation => 'Location';

  @override
  String get requestAdminPhone => 'Phone';

  @override
  String get requestAdminOffersCount => 'Number of offers';

  @override
  String get requestAdminStatus => 'Status';

  @override
  String get requestAdminOffersStatus => 'Offers status';

  @override
  String get requestAdminOffersStatusOpen => 'Open';

  @override
  String get requestAdminOffersStatusAccepted => 'Accepted';

  @override
  String get requestAdminOffersStatusClosed => 'Closed';

  @override
  String get requestAdminRequiredFields => 'All main fields must be filled in.';

  @override
  String get requestAdminUpdated => 'Request updated.';

  @override
  String get requestAdminUpdateFailed => 'Update failed.';

  @override
  String get requestAdminDeleteTitle => 'Delete request';

  @override
  String requestAdminDeleteBody(Object service, Object location) {
    return 'Delete the $service request from $location?';
  }

  @override
  String get requestAdminDeleted => 'Request deleted.';

  @override
  String get requestAdminDeleteFailed => 'Deletion failed.';

  @override
  String requestAdminPhoneValue(Object phone) {
    return 'Phone: $phone';
  }

  @override
  String requestAdminOffersValue(Object count, Object status) {
    return 'Offers: $count • $status';
  }

  @override
  String get requestAdminRelaunch => 'Relaunch';

  @override
  String get requestAdminTitle => 'Back-office requests';

  @override
  String get requestAdminFirebaseUnavailable => 'Firebase unavailable';

  @override
  String get requestAdminHeroEyebrow => 'Request management';

  @override
  String requestAdminHeroCount(Object count) {
    return '$count request(s) recorded';
  }

  @override
  String get requestAdminHeroBody =>
      'Edit or delete client requests stored in /requests.';

  @override
  String get requestAdminEmpty => 'No request is available in Firebase yet.';
}
