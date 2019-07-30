import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:kdygd/model/Article.dart';
import 'package:kdygd/model/Question.dart';
import 'package:kdygd/model/Topic.dart';
import 'package:kdygd/view/MainPage.dart';
import 'package:kdygd/view/SplashScreen.dart';
import 'package:kdygd/view/exam/DoExam.dart';
import 'package:kdygd/view/article/ArticleEditor.dart';
import 'package:kdygd/view/article/ArticlePage.dart';
import 'package:kdygd/view/quiz/DoQuiz.dart';
import 'package:kdygd/view/topic/SelectTopicPage.dart';

class Navigate {
	static final Navigate _navigator = new Navigate._internal();
	static Navigate get instance => _navigator;
	final Router _router = new Router();
	
	get generator => _router.generator;
	
	Navigate._internal() {
		if(_router.match('/') != null) return;
		_router.define(
			'/',
			handler: new Handler(
				handlerFunc: (_, __) => new SplashScreen(),
			),
		);
		
		_router.define(
			'/home',
			handler: new Handler(
				handlerFunc: ( _, __ ) => new MainPage(),
			),
		);
		
		_router.define(
			'/topic/select',
			handler: new Handler(
				handlerFunc: ( _, __ ) => new SelectTopicPage(),
			),
		);
		_router.define(
			'topic/:topic/article/create',
			handler: new Handler(
				handlerFunc: ( final BuildContext context, final Map<String, dynamic> params ) => new ArticleEditor(
					article: new Article(
						topic_id: params["topic"][0],
						content: null,
					),
				),
			),
		);
	}
	
	Future<void> home( final BuildContext context, { final bool clear_stack = false, final bool replace = false } ) => _router.navigateTo(context, '/home', clearStack: clear_stack, replace: replace);
	Future selectTopic( final BuildContext context ) => _router.navigateTo(context, '/topic/select');
	Future<void> doExam( final BuildContext context, { @required final List<Question> questions, @required final Duration start_duration } ) => Navigator.of(context).push( new MaterialPageRoute(
		builder: ( _ ) => new DoExamPage(questions: questions, start_duration: start_duration,),
	) );
	Future<void> createArticle( final BuildContext context, Topic topic ) => _router.navigateTo(context, 'topic/${topic.id}/article/create');
	Future<void> viewArticle( final BuildContext context, Article article ) => Navigator.of(context).push( new MaterialPageRoute(
		builder: ( _ ) => new ArticlePage(
			article: article,
		),
	) );
	Future<void> doQuiz( final BuildContext context, { @required final List<Question> questions, @required final Duration start_duration, @required final DateTime quiz_date_time, } ) => Navigator.of(context).push( new MaterialPageRoute(
		builder: ( _ ) => new DoQuizPage(questions: questions, start_duration: start_duration, quiz_date_time: quiz_date_time, ),
	) );
}