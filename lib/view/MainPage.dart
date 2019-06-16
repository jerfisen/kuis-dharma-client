import 'package:flutter/material.dart';
import 'package:kdygd/Navigate.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/model/Topic.dart';
import 'package:kdygd/view/account/AccountPage.dart';
import 'package:kdygd/view/common/AccountIcon.dart';
import 'package:kdygd/view/exam/ExamPage.dart';
import 'package:kdygd/view/learn/LearnPage.dart';

const _ICON_SIZE = 35.0;

enum MainPageContent {
	LEARNING,
	EXAM,
	ACCOUNT
}

class MainPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
	MainPageContent _current_content = MainPageContent.LEARNING;
	Topic _topic;
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: _getBody(),
		bottomNavigationBar: new BottomNavigationBar(
			onTap: ( final int new_index ) => setState( () => _current_content = MainPageContent.values[new_index] ),
			items: <BottomNavigationBarItem>[
				new BottomNavigationBarItem(
					icon: Image.asset("images/learn.png", height: _ICON_SIZE, width: _ICON_SIZE,),
					title: Text(S.of(context).learn),
				),
				new BottomNavigationBarItem(
					icon: Image.asset("images/exam.png", height: _ICON_SIZE, width: _ICON_SIZE,),
					title: Text(S.of(context).exam),
				),
				new BottomNavigationBarItem(
					icon: AccountIcon( size: _ICON_SIZE, ),
					title: Text(S.of(context).profile),
				),
			],
		),
	);
	
	Widget _getBody() {
		switch( _current_content ) {
			case MainPageContent.LEARNING: return LearnPage( topic: _topic, );
			case MainPageContent.EXAM: return ExamPage( topic: _topic, );
			case MainPageContent.ACCOUNT: return new AccountPage();
		}
	}
	
	@override
	void initState() {
		super.initState();
		new Future.delayed(Duration.zero, _selectTopic, );
	}
	
	void _selectTopic() async {
		_topic = await Navigate.instance.selectTopic(context);
	}
	
	
	
}