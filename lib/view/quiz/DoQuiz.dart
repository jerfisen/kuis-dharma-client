import 'dart:async';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kdygd/common/Config.dart';
import 'package:kdygd/graphql/exam.dart';
import 'package:kdygd/model/Exam.dart';
import 'package:kdygd/view/exam/DoExam.dart';
import 'package:tuple/tuple.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/model/Question.dart';

part 'finish.do.quiz.page.dart';

class DoQuizPage extends StatefulWidget {
	final List<Question> questions;
	final Duration start_duration;
	final DateTime quiz_date_time;
	const DoQuizPage({Key key, @required this.questions, @required this.start_duration, @required this.quiz_date_time }) : super(key: key);
	@override
	State<StatefulWidget> createState() => _DoQuizPageState();
}

class _DoQuizPageState extends State<DoQuizPage> {
	PageController _page_controller;
	Duration _current;
	Timer _timer;
	int _index = -1;
	List<Tuple2<Question, Answer>> _qas;
	@override
	Widget build(BuildContext context) => new WillPopScope(
		onWillPop: () => Future.value(false),
		child: new Scaffold(
			body: new NestedScrollView(
				headerSliverBuilder: ( _, __ ) => <Widget>[
					new SliverAppBar(
						automaticallyImplyLeading: false,
						title: new Text(
							_index > -1 ? S.of(context).question( ( _index + 1 ).toString() ) : S.of(context).exam,
						),
					),
				],
				body: new PageView.builder(
					controller: _page_controller,
					physics: NeverScrollableScrollPhysics(),
					itemBuilder: ( _, int position ) {
						return new ListView(
							children: <List<Widget>>[
								<Widget>[
									new Center(
										child: new Text(
											_getReadableTime(),
											textAlign: TextAlign.center,
											style: const TextStyle(
												fontSize: 25.0,
												fontWeight: FontWeight.w700,
											),
										),
									),
									new SizedBox(
										height: 10.0,
									),
								],
								<Widget>[
									new QuestionTile(
										question: widget.questions[position],
									),
									new SizedBox(
										height: 35.0,
									),
								],
								<Widget>[
									new Padding(
										padding: const EdgeInsets.only(left: 5.0),
										child: new Text(
											S.of(context).choose_answer,
											style: new TextStyle(
												color: Theme.of(context).accentColor,
												fontSize: 16.0,
											),
										),
									),
									new SizedBox(
										height: 5.0,
									),
								],
								widget.questions[position].answers.map( ( final answer ) => [
									new AnswerTile(
										answer: answer,
										state: answer == _qas[position].item2 ? AnswerState.RIGHT : AnswerState.NEUTER,
										onTap: () {
											if ( mounted ) setState( () => _qas[position] = new Tuple2(_qas[position].item1, answer) ); else _qas[position] = new Tuple2(_qas[position].item1, answer);
											if ( _timer != null && _timer.isActive ) _timer.cancel();
											_nextPage();
										},
									),
									new SizedBox(
										height: 15.0,
									),
								] ).expand( ( list ) => list ).toList(growable: false),
							].expand( (  list ) => list ).toList(growable: false),
						);
					},
					itemCount: widget.questions.length,
				),
			),
		),
	);
	
	@override
	void initState() {
		_page_controller = new PageController();
		_current = widget.start_duration;
		_qas = new List<Tuple2<Question, Answer>>.generate(widget.questions.length, ( final int index ) => new Tuple2<Question, Answer>( widget.questions[index], null ) );
		super.initState();
		_index = 0;
		new Future.delayed(Duration.zero, _startCountDown);
	}
	
	@override
	void dispose() {
		_page_controller.dispose();
		if ( _timer != null && _timer.isActive ) _timer.cancel();
		super.dispose();
	}
	
	String _getReadableTime() {
		final seconds = _current.inSeconds;
		final double minute = seconds / 60.0;
		final rest_of_seconds = seconds - minute.floor() * 60;
		return "${ minute.floor() < 10 ? "0${minute.floor()}" : minute.floor() }:${ rest_of_seconds < 10 ? "0$rest_of_seconds" : rest_of_seconds }";
	}
	
	void _startCountDown() {
		_current = widget.start_duration;
		_timer = new Timer.periodic(
			const Duration(seconds: 1),
				( Timer timer ) => setState((){
				if ( _current.inSeconds < 1 ) {
					_timer.cancel();
					_nextPage();
				} else {
					_current = new Duration( seconds: _current.inSeconds - 1 );
				}
			}),
		);
	}
	
	void _nextPage() {
		if ( _page_controller.page.toInt() < widget.questions.length - 1 ) {
			_page_controller.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeInOutQuint);
			if ( mounted ) setState( () => ++_index );
			_startCountDown();
		} else {
			Navigator.of(context).pushReplacement(
				new MaterialPageRoute(
					builder: ( _ ) => new _FinishDoQuizPage(
						qas: _qas,
						quiz_date_time: widget.quiz_date_time,
					),
				),
			);
		}
	}
	
}