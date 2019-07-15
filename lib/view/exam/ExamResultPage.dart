import 'package:flutter/material.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/model/Exam.dart';
import 'package:kdygd/view/exam/ExamResultWidget.dart';

class ExamResultPage extends StatelessWidget {
	final Exam result;
	const ExamResultPage({Key key, this.result}) : super(key: key);
	@override
	Widget build(BuildContext context) => new Scaffold(
		appBar: new AppBar(
			title: new Text(
				S.of(context).history,
			),
		),
		body: new ExamResultWidget(
			exam: result,
		),
	);
}
