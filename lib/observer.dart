import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'flutter_umeng_analytics.dart';

typedef String PageNameGenerator(PageRoute<dynamic> pageRoute);

String kDefaultPageNameGenerator(PageRoute<dynamic> pageRoute) =>
    pageRoute.settings?.name;

/// A [Navigator] observer that send page view events to UMeng Analytics when
/// [PageRoute] changes.
///
/// To track page views automatically, add this class to [Navigator.observers]
/// or if you are using [MaterialApp], add this to
/// [MaterialApp.navigatorObservers]:
///
/// ```dart
/// new MaterialApp(
///   navigatorObservers: [
///     new UMengAnalyticsRouteObserver(),
///   ],
/// );
/// ```
///
/// You can customize page name using `pageNameGenerator`, the related
/// [RouteSettings.name] is used as page name by default.
class UMengAnalyticsRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final PageNameGenerator pageNameGenerator;

  UMengAnalyticsRouteObserver({
    this.pageNameGenerator = kDefaultPageNameGenerator,
  });

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      final pageName = pageNameGenerator(route);
      if (pageName != null && pageName.isNotEmpty) {
        UMengAnalytics.beginPageView(pageName);
      }
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute && route is PageRoute) {
      final pageName = pageNameGenerator(previousRoute);
      if (pageName != null && pageName.isNotEmpty) {
        UMengAnalytics.endPageView(pageName);
      }
    }
  }
}
