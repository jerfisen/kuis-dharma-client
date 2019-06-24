part of 'DoExam.dart';

class _FinishDoExamPage extends StatefulWidget {
	final List<Answer> answers;
	const _FinishDoExamPage({Key key, this.answers}) : super(key: key);
	@override
	State<StatefulWidget> createState() => _FinishDoExamPageState();
}

class _FinishDoExamPageState extends State<_FinishDoExamPage> {
	ExamResult _result;
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: _result == null ? new Center(
			child: new CircularProgressIndicator(),
		) : new ListView.builder(
			itemCount: _result.works.length + 2,
			itemBuilder: ( _, final int index ) {
				if ( index == 0 ) return new Card(
					elevation: CARD_ELEVATION,
					color: Theme.of(context).accentColor,
					child: new Padding(
						padding: const EdgeInsets.all(20.0),
						child: new Center(
							child: new Text(
								"Skor ${ _result.skor.toStringAsFixed(2) }",
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
										answer: _result.works[index - 2].question,
										onTap: (){},
									),
									new AnswerTile(
										answer: _result.works[index - 2].selected_answer,
										onTap: (){},
										state: _result.works[ index - 2 ].selected_answer == _result.works[ index - 2 ].correct_answer ? AnswerState.RIGHT : AnswerState.WRONG,
									),
									_result.works[ index - 2 ].selected_answer != _result.works[ index - 2 ].correct_answer ? new AnswerTile(
										answer: _result.works[index - 2].correct_answer,
										onTap: (){},
										state: AnswerState.RIGHT,
									) : null,
								].where( ( widget ) => widget != null ).toList(growable: false),
							),
						),
					);
				}
			},
		),
	);
	
	@override
	void initState() {
		super.initState();
		Future.delayed(Duration.zero, _saveExam);
	}
	
	void _saveExam() async {
		final loading_indicator = FlushbarHelper.createLoading(message: S.of(context).please_wait, linearProgressIndicator: new LinearProgressIndicator(), duration: null);
		try {
			loading_indicator.show(context);
			final result = await ExamRepository.save( new ArgSaveExam(
				widget.answers.map( ( answer ) => answer.id ).toList(growable: false),
			) );
			await loading_indicator.dismiss();
			print( result.toJson() );
			if ( mounted ) setState( () => _result = result );
		} catch ( error ) {
			await loading_indicator.dismiss();
			FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
		} finally {
			if ( loading_indicator.isShowing() ) await loading_indicator.dismiss();
		}
	}
}