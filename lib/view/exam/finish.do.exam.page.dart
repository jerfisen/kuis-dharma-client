part of 'DoExam.dart';

class _FinishDoExamPage extends StatefulWidget {
	final List<Tuple2<Question, Answer>> qas;
	const _FinishDoExamPage({Key key, this.qas}) : super(key: key);
	@override
	State<StatefulWidget> createState() => _FinishDoExamPageState();
}

class _FinishDoExamPageState extends State<_FinishDoExamPage> {
	Exam _result;
	dynamic _error;
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: _getContent(),
	);
	
	Widget _getContent() {
		if ( _error == null && _result == null ) return new Center( child: new CircularProgressIndicator(), );
		else if ( _result != null ) {
			return new ListView.builder(
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
			);
		} else {
			return new Center(
				child: new Column(
					crossAxisAlignment: CrossAxisAlignment.center,
					mainAxisAlignment: MainAxisAlignment.center,
					mainAxisSize: MainAxisSize.min,
					children: <Widget>[
						new Text(
							S.of(context).error_occurred,
						),
						new IconButton(
							icon: const Icon(Icons.refresh),
							onPressed: _saveExam,
						),
					],
				),
			);
		}
	}
	
	@override
	void initState() {
		super.initState();
		Future.delayed(Duration.zero, _saveExam);
	}
	
	void _saveExam() async {
		try {
			final result = await GraphQLProvider.of(context).value.mutate( new MutationOptions(
				document: MUTATION_SAVE_EXAMS,
				variables: {
					"works": widget.qas.map( ( qa ) => new ArgsWorks(
						question_id: qa.item1.id,
						answer_id: qa.item2.id,
					).toJson() ).toList(growable: false),
				},
				fetchPolicy: FetchPolicy.noCache,
			) );
			if ( result.hasErrors ) {
				throw new Exception( result.errors.map( ( error ) => error.message ).join("\r\n") );
			} else {
				if ( mounted ) {
					setState(() {
						_result = Exam.fromJson(result.data["saveExam"]);
					});
				}
			}
		} catch ( error ) {
			if ( mounted ) {
				setState( () => _error = error );
			}
		}
	}
}