part of 'DoExam.dart';

class _FinishDoExamPage extends StatefulWidget {
	final List<Answer> answers;
	const _FinishDoExamPage({Key key, this.answers}) : super(key: key);
	@override
	State<StatefulWidget> createState() => _FinishDoExamPageState();
}

class _FinishDoExamPageState extends State<_FinishDoExamPage> {
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new ListView.builder(
			itemCount: widget.answers.length + 1,
			itemBuilder: ( _, final int index ) {
				if ( index == 0 ) return new Card(
					child: new Center(
						child: new Text(
							"Skor 50",
						),
					),
				);
			},
		),
	);
}