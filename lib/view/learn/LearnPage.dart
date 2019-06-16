import 'package:flutter/material.dart';
import 'package:kdygd/model/Topic.dart';

class LearnPage extends StatefulWidget {
	final Topic topic;
	const LearnPage({Key key, @required this.topic}) : assert( topic != null ), super(key: key);
	@override
	State<StatefulWidget> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new Center(
			child: new Text(
				"Learn",
			),
		),
	);
}