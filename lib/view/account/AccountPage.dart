import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
	@override 
	Widget build(BuildContext context) => new Scaffold(
		body: new Center(
			child: new Text("Account Page"),
		),
	);
}