import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kdygd/Navigate.dart';
import 'package:kdygd/common/Config.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/graphql/question.dart';
import 'package:kdygd/model/Question.dart';
import 'package:kdygd/model/Topic.dart';
import 'package:edenvidi_progress_indicator/edenvidi_progress_indicator.dart';

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
						child: new RaisedButton(
							child: new Text(
								S.of(context).start,
							),
							onPressed: _onStart,
						),
					),
				),
			],
		),
	);
	
	void _onStart() async {
		ProgressDialog indicator = new ProgressDialog(context: context, message: S.of(context).please_wait);
		try {
			indicator.show();
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
				indicator.hide();
				Navigate.instance.doExam(context, questions: questions, start_duration: new Duration(seconds: start_time_in_seconds));
			}
		} catch ( _ ) {
			if ( indicator.isShowing ) indicator.hide();
			FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
		}
	}
}