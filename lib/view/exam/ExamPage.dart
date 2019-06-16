import 'package:flutter/material.dart';
import 'package:kdygd/model/Topic.dart';

class ExamPage extends StatefulWidget {
	final Topic topic;
	const ExamPage({Key key, @required this.topic}) : assert( topic != null ), super(key: key);
	@override
	State<StatefulWidget> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new Center(
			child: new Text(
				"Exam",
			),
		),
	);
}