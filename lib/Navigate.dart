import 'package:fluro/fluro.dart';
import 'package:kdygd/view/SplashScreen.dart';

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
					handlerFunc: (_, __) {
						return new SplashScreen();
					}
			),
		);
	}
}