import 'package:fluro/fluro.dart';
import 'package:flutter/widgets.dart';
import 'package:kdygd/view/MainPage.dart';
import 'package:kdygd/view/SplashScreen.dart';
import 'package:kdygd/view/topic/SelectTopicPage.dart';

class Navigate {
	static final Navigate _navigator = new Navigate._internal();
	static Navigate get instance => _navigator;
	final Router _router = new Router();
	
	get generator => _router.generator;
	
	Navigate._internal() {
		if(_router.match('/') != null) return;
		_router.define(
			'/',
			handler: new Handler(
				handlerFunc: (_, __) => new SplashScreen(),
			),
		);
		
		_router.define(
			'/home',
			handler: new Handler(
				handlerFunc: ( _, __ ) => new MainPage(),
			),
		);
		
		_router.define(
			'/topic/select',
			handler: new Handler(
				handlerFunc: ( _, __ ) => new SelectTopicPage(),
			),
		);
	}
	
	Future<void> home( final BuildContext context, { final bool clear_stack = false, final bool replace = false } ) => _router.navigateTo(context, '/home', clearStack: clear_stack, replace: replace);
	Future selectTopic( final BuildContext context ) => _router.navigateTo(context, '/topic/select');
}