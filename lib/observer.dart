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
  String _lastPage;

  UMengAnalyticsRouteObserver({
    this.pageNameGenerator = kDefaultPageNameGenerator,
  });

  _pageBegin(PageRoute route) {
    final pageName = pageNameGenerator(route);
    if (pageName == null || pageName.isEmpty) return;

    if (_lastPage != null) {
      UMengAnalytics.endPageView(_lastPage);
    }
    _lastPage = pageName;

    UMengAnalytics.beginPageView(pageName);
  }

  @override
  void didPush(Route route, Route previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute) {
      _pageBegin(route);
    }
  }

  @override
  void didPop(Route route, Route previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute is PageRoute) {
      _pageBegin(previousRoute);
    }
  }
}
