import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new Center(
			child: new Text("Main Page"),
		),
	);
}