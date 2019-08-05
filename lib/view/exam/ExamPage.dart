import 'package:edenvidi_paging/edenvidi_paging.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kdygd/Navigate.dart';
import 'package:kdygd/common/Config.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/graphql/exam.dart';
import 'package:kdygd/graphql/question.dart';
import 'package:kdygd/model/Exam.dart';
import 'package:kdygd/model/Question.dart';
import 'package:kdygd/model/Topic.dart';
import 'package:kdygd/view/exam/ExamResultPage.dart';
import 'package:kdygd/view/quiz/QuizPage.dart';

part 'exam.history.dart';
part 'exam.history.list.dart';

class ExamPage extends StatefulWidget {
	final Topic topic;
	const ExamPage({Key key, @required this.topic}) : assert( topic != null ), super(key: key);
	@override
	State<StatefulWidget> createState() => _ExamPageState();
}

class _ExamPageState extends State<ExamPage> {
	@override
	Widget build(BuildContext context) => new Scaffold(
		appBar: new AppBar(
			title: new Text(
				S.of(context).exam,
			),
		),
		body: new Column(
			mainAxisSize: MainAxisSize.max,
			children: <Widget>[
				new FlatButton(
					child: new Text(
						widget.topic.name,
					),
					onPressed: (){},
				),
				new Expanded(
					child: new Center(
						child: new Column(
							children: <Widget>[
								new RaisedButton(
									child: new Text(
										S.of(context).exam,
									),
									onPressed: _onStart,
								),
								new RaisedButton(
									child: new Text(
										S.of(context).history,
									),
									onPressed: _onHistory,
								),
								new RaisedButton(
									child: new Text(
										S.of(context).quiz,
									),
									onPressed: _onQuiz,
								),
							],
						),
					),
				),
			],
		),
	);
	
	void _onQuiz() async {
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: ( _ ) => new QuizPage(
					topic: widget.topic,
				),
			),
		);
	}
	
	void _onHistory() async {
		Navigator.of(context).push(
			new MaterialPageRoute(
				builder: ( _ ) => new _ExamHistoryPage(),
			),
		);
	}
	
	void _onStart() async {
		final indicator = FlushbarHelper.createLoading(message: S.of(context).please_wait, linearProgressIndicator: new LinearProgressIndicator(), duration: null);
		try {
			indicator.show(context);
			final exams = await GraphQLProvider.of(context).value.query( new QueryOptions(
				document: QUERY_DO_EXAMS,
				variables: {
					"length": 30,
					"topic": widget.topic.id,
				},
			) );
			if ( exams.hasErrors ) {
				throw new Exception(
					exams.errors.map( ( error ) => error.toString() ),
				);
			} else {
				final List<Question> questions = new List();
				for ( final raw_data in exams.data["doExam"] as List ) {
					final question = Question.fromJson( raw_data );
					questions.add(question);
				}
				final remote_config = await RemoteConfig.instance;
				final start_time_in_seconds = remote_config.getInt(DEFINITION_TIME_PER_QUESTION_IN_SECONDS);
				await indicator.dismiss();
				Navigate.instance.doExam(context, questions: questions, start_duration: new Duration(seconds: start_time_in_seconds));
			}
		} catch ( _ ) {
			if ( indicator.isShowing() ) await indicator.dismiss();
			FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
		}
	}
}