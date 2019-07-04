import 'package:flutter/material.dart';
import 'package:kdygd/common/Config.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/view/exam/DoExam.dart';
import 'package:kdygd/model/Exam.dart';

class ExamResultWidget extends StatelessWidget {
	final ExamResult exam_result;
	const ExamResultWidget({Key key, @required this.exam_result}) : assert( exam_result != null ), super(key: key);
	@override
	Widget build(BuildContext context) => new ListView.builder(
		itemCount: exam_result.works.length + 2,
		itemBuilder: ( _, final int index ) {
			if ( index == 0 ) return new Card(
				elevation: CARD_ELEVATION,
				color: Theme.of(context).accentColor,
				child: new Padding(
					padding: const EdgeInsets.all(20.0),
					child: new Center(
						child: new Text(
							"Skor ${ exam_result.skor.toStringAsFixed(2) }",
							style: Theme.of(context).primaryTextTheme.title,
						),
					),
				),
			);
			else if ( index == 1 ) return new Card(
				elevation: CARD_ELEVATION,
				child: new Padding(
					padding: const EdgeInsets.all(10.0),
					child: new Row(
						children: <Widget>[
							new Column(
								children: <Widget>[
									new Text(
										S.of(context).right,
									),
									new SizedBox(
										height: 5.0,
									),
									new Text(
										S.of(context).wrong,
									),
								],
							),
							new SizedBox(
								width: 15.0,
							),
							new Column(
								children: <Widget>[
									new Container(
										height: 15.0,
										width: 15.0,
										color: Theme.of(context).accentColor,
									),
									new SizedBox(
										height: 5.0,
									),
									new Container(
										height: 15.0,
										width: 15.0,
										color: Theme.of(context).errorColor,
									),
								],
							),
						],
					),
				),
			);
			else {
				return new Card(
					elevation: CARD_ELEVATION,
					child: new Padding(
						padding: const EdgeInsets.all(10.0),
						child: new Column(
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: <Widget>[
								new Text(
									S.of(context).question( ( index - 1 ).toString() ),
									style: const TextStyle(
										fontSize: 18.0,
										fontWeight: FontWeight.w700,
									),
								),
								new SizedBox(
									height: 10.0,
								),
								new AnswerTile(
									answer: exam_result.works[index - 2].question,
									onTap: (){},
								),
								new AnswerTile(
									answer: exam_result.works[index - 2].selected_answer,
									onTap: (){},
									state: exam_result.works[ index - 2 ].selected_answer == exam_result.works[ index - 2 ].correct_answer ? AnswerState.RIGHT : AnswerState.WRONG,
								),
								exam_result.works[ index - 2 ].selected_answer != exam_result.works[ index - 2 ].correct_answer ? new AnswerTile(
									answer: exam_result.works[index - 2].correct_answer,
									onTap: (){},
									state: AnswerState.RIGHT,
								) : null,
							].where( ( widget ) => widget != null ).toList(growable: false),
						),
					),
				);
			}
		},
	);
}