import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kdygd/Navigate.dart';
import 'package:kdygd/common/Session.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() {
	Crashlytics.instance.enableInDevMode = true;
	FlutterError.onError = ( FlutterErrorDetails details ) => Crashlytics.instance.onError(details);
	runApp(KDYGD());
}

class KDYGD extends StatelessWidget {
	final GlobalKey<NavigatorState> _navigator_state = new GlobalKey();
	KDYGD() {
		Session.instance.init(_navigator_state);
	}
	
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Flutter Demo',
			navigatorKey: _navigator_state,
			localizationsDelegates: [
				S.delegate,
				GlobalWidgetsLocalizations.delegate,
				GlobalMaterialLocalizations.delegate,
			],
			supportedLocales: S.delegate.supportedLocales,
			localeResolutionCallback: S.delegate.resolution( fallback: const Locale('in', 'ID') ),
			theme: ThemeData(
				// This is the theme of your application.
				//
				// Try running your application with "flutter run". You'll see the
				// application has a blue toolbar. Then, without quitting the app, try
				// changing the primarySwatch below to Colors.green and then invoke
				// "hot reload" (press "r" in the console where you ran "flutter run",
				// or simply save your changes to "hot reload" in a Flutter IDE).
				// Notice that the counter didn't reset back to zero; the application
				// is not restarted.
				primarySwatch: Colors.blue,
			),
			onGenerateRoute: Navigate.instance.generator,
		);
	}
}