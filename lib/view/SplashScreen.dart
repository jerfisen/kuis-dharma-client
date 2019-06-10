import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
	@override
	Widget build(BuildContext context) => new Material(
		color: Theme.of(context).primaryColor,
		child: new Center(
			child: new Image.asset( "images/logo.jpg" ),
		),
	);
}