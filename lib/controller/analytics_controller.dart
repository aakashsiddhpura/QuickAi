import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';

class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  Future<void> setCurrentScreen({String? screenName, String? screenClassOverride}) async {
    analytics.logEvent(name: screenName!);
  }

  void logEvent(String eventName, Map<String, dynamic>? parameters) {
    analytics.logEvent(name: eventName, parameters: parameters);
  }
}
