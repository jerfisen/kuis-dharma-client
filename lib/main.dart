import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:kdygd/Navigate.dart';
import 'package:kdygd/common/Config.dart';
import 'package:kdygd/common/LanguageBloc.dart';
import 'package:kdygd/common/Session.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

void main() {
	Crashlytics.instance.enableInDevMode = true;
	FlutterError.onError = Crashlytics.instance.recordFlutterError;
	runApp(KDYGD());
}

class KDYGD extends StatelessWidget {
	final GlobalKey<NavigatorState> _navigator_state = new GlobalKey();
	KDYGD() {
		Session.instance.init(_navigator_state);
		new Future.delayed( Duration.zero, _initRemoteConfig );
	}
	
	void _initRemoteConfig() async {
		final RemoteConfig remote_config = await RemoteConfig.instance;
		await remote_config.setDefaults({
			DEFINITION_TIME_PER_QUESTION_IN_SECONDS: DEFAULT_TIMER_PER_QUESTION_IN_SECONDS,
		});
		await remote_config.fetch();
		await remote_config.activateFetched();
	}
	
	// This widget is the root of your application.
	@override
	Widget build(BuildContext context) {
		final HttpLink http_link = new HttpLink(
			uri: "$DEFAULT_SERVER_URL/graphql",
		);
		final AuthLink auth_link = new AuthLink(
			getToken: () async {
				final user = await FirebaseAuth.instance.currentUser();
				if ( user == null ) return null;
				else return "bearer ${ await user.getIdToken() }";
			}
		);
		ValueNotifier<GraphQLClient> client = new ValueNotifier(
			new GraphQLClient(
				cache: InMemoryCache(),
				link: auth_link.concat( http_link as Link ),
			),
		);
		return new GraphQLProvider(
			client: client,
			child: new StreamBuilder<Locale>(
				stream: Language.instance.locale_stream,
				builder: ( _, snapshot ) => MaterialApp(
					title: 'Flutter Demo',
					navigatorKey: _navigator_state,
					localizationsDelegates: [
						S.delegate,
						GlobalWidgetsLocalizations.delegate,
						GlobalMaterialLocalizations.delegate,
					],
					supportedLocales: S.delegate.supportedLocales,
					localeResolutionCallback: S.delegate.resolution( fallback: const Locale('in', 'ID') ),
					locale: snapshot.data ?? const Locale('in', 'ID'),
					theme: _getThemeData(),
					onGenerateRoute: Navigate.instance.generator,
				),
			),
		);
	}
	
	ThemeData _getThemeData() => new ThemeData(
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
	);
	
}