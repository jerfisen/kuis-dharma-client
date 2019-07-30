import 'dart:async';
import 'dart:math';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kdygd/Navigate.dart';
import 'package:kdygd/common/Config.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/graphql/question.dart';
import 'package:kdygd/model/Question.dart';
import 'package:kdygd/model/Topic.dart';
import 'package:kdygd/repository/QuizRepository.dart';

class QuizPage extends StatefulWidget {
	final Topic topic;
	const QuizPage({Key key, this.topic}) : super(key: key);
	@override
	_QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
	DateTime _date_time_10, _date_time_11;
	Stream<int> _audience_count_of_10_stream;
	Stream<int> _audience_count_of_11_stream;
	
	DateTime _registered_quiz_date_time;
	bool _loading = true;
	Duration _current;
	Timer _timer;
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new NestedScrollView(
			headerSliverBuilder: ( _, __ ) => <Widget>[
				new SliverAppBar(
					title: new Text(
						S.of(context).quiz,
					),
				),
			],
			body: _loading ? new Center(
				child: new CircularProgressIndicator(),
			) : _registered_quiz_date_time == null ? _unregisteredWidget() : _registeredWidget(_registered_quiz_date_time),
		),
	);
	
	Widget _registeredWidget( final DateTime date ) => new Center(
		child: new Column(
			mainAxisSize: MainAxisSize.min,
			children: <Widget>[
				new Text(
					S.of(context).already_registered( new DateFormat("dd MMMM yyyy 'pukul' hh:mm", "id").format( date.toLocal() ) ),
					textAlign: TextAlign.center,
					style: const TextStyle(
						fontWeight: FontWeight.w700,
						fontSize: 24,
					),
				),
				new SizedBox(height: 20.0,),
				_current.inSeconds > 1 ? new Text(
					_getReadableTime(),
					style: const TextStyle(
						fontWeight: FontWeight.w700,
						fontSize: 24,
					),
				) : new RaisedButton(
					child: new Text(
						S.of(context).start,
					),
					onPressed: _onStart,
				),
			],
		),
	);
	
	Widget _unregisteredWidget() => new Column(
		mainAxisSize: MainAxisSize.min,
		children: <Widget>[
			new InkWell(
				child: new Card(
					elevation: CARD_ELEVATION,
					child: new Padding(
						padding: const EdgeInsets.all(10.0),
						child: new Column(
							children: <Widget>[
								new Text(
									new DateFormat("'Pukul' hh:mm", "id").format( _date_time_10 ),
									style: const TextStyle(
										fontSize: 24.0,
									),
								),
								new StreamBuilder<int>(
									stream: _audience_count_of_10_stream,
									initialData: 0,
									builder: ( _, snapshot ) => new Text(
										S.of(context).quiz_audience( snapshot.data.toString() ),
										style: const TextStyle(
											fontSize: 24.0,
										),
									),
								),
							],
						),
					),
				),
				onTap: () async => _register( _date_time_10 ),
			),
			new SizedBox(height: 10.0,),
			new InkWell(
				child: new Card(
					elevation: CARD_ELEVATION,
					child: new Padding(
						padding: const EdgeInsets.all(10.0),
						child: new Column(
							children: <Widget>[
								new Text(
									new DateFormat("'Pukul' hh:mm", "id").format( _date_time_11 ),
									style: const TextStyle(
										fontSize: 24.0,
									),
								),
								new StreamBuilder<int>(
									stream: _audience_count_of_11_stream,
									initialData: 0,
									builder: ( _, snapshot ) => new Text(
										S.of(context).quiz_audience( snapshot.data.toString() ),
										style: const TextStyle(
											fontSize: 24.0,
										),
									),
								),
							],
						),
					),
				),
				onTap: () async => _register( _date_time_11 ),
			),
		],
	);
	
	@override
	void initState() {
		if ( DateTime.now().hour < 9 ) {
			_date_time_10 = new DateTime( DateTime.now().year, DateTime.now().month, DateTime.now().day, 10 );
			_date_time_11 = new DateTime( DateTime.now().year, DateTime.now().month, DateTime.now().day, 11 );
		} else {
			_date_time_10 = new DateTime( DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 10 );
			_date_time_11 = new DateTime( DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 11 );
		}
		_audience_count_of_10_stream = QuizRepository.streamAudience( new DateTime( DateTime.now().year, DateTime.now().month, DateTime.now().day, 10 ) );
		_audience_count_of_11_stream = QuizRepository.streamAudience( new DateTime( DateTime.now().year, DateTime.now().month, DateTime.now().day, 11 ) );
		super.initState();
		new Future.delayed(Duration.zero, _loadRegisteredQuiz);
	}
	
	@override
	void dispose() {
		if ( _timer != null && _timer.isActive ) _timer.cancel();
		super.dispose();
	}
	
	void _loadRegisteredQuiz() async {
		_registered_quiz_date_time = await QuizRepository.isAlreadyRegistered();
		if ( _registered_quiz_date_time != null ) {
			_startCountDown();
		}
		if ( mounted ) setState( () => _loading = false );
	}
	
	void _startCountDown() {
		_current = new Duration( seconds: ( _registered_quiz_date_time.millisecondsSinceEpoch / 1000 - new DateTime.now().millisecondsSinceEpoch / 1000 ).toInt() );
		_timer = new Timer.periodic(
			const Duration(seconds: 1),
				( Timer timer ) => setState((){
				if ( _current.inSeconds < 1 ) {
					_timer.cancel();
				} else {
					_current = new Duration( seconds: _current.inSeconds - 1 );
				}
			}),
		);
	}
	
	String _getReadableTime() {
		final seconds = _current?.inSeconds ?? 0;
		final hour = ( seconds / 3600.0 ).floor();
		final minute = ( seconds % 3600 ) / 60;
		final rest_of_seconds = ( seconds % 3600 ) % 60;
		return "${ hour.floor() < 10 ? "0${ hour.floor() }" : hour.floor() }:${ minute.floor() < 10 ? "0${minute.floor()}" : minute.floor() }:${ rest_of_seconds < 10 ? "0$rest_of_seconds" : rest_of_seconds }";
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
					"seed": await QuizRepository.getSeed( _registered_quiz_date_time ),
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
				Navigate.instance.doQuiz(context, questions: questions, start_duration: new Duration(seconds: start_time_in_seconds), quiz_date_time: _registered_quiz_date_time);
			}
		} catch ( _ ) {
			if ( indicator.isShowing() ) await indicator.dismiss();
			FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
		}
	}
	
	void _register( final DateTime date ) async {
		try {
			if ( mounted ) setState( () => _loading = true );
			final exists = await QuizRepository.exists(date);
			if ( !exists ) {
				final count_result = await GraphQLProvider.of(context).value.query(new QueryOptions(
					document: QUERY_DO_COUNT_QUESTIONS,
					variables: {
						"topic": widget.topic.id,
					},
				));
				if ( count_result.hasErrors ) {
					throw new Exception( count_result.errors.map( ( error ) => error.message ).join("\r\n") );
				} else {
					final count = count_result.data["countQuestions"] as int;
					final seed = new Random.secure().nextInt(count);
					await QuizRepository.register( date, seed );
				}
			} else {
				await QuizRepository.register( date );
			}
			new Future.delayed(Duration.zero, _loadRegisteredQuiz);
		} catch ( error ) {
			FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
		}
	}
}