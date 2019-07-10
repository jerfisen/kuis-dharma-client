part of 'DoExam.dart';

enum AnswerState {
	NEUTER,
	RIGHT,
	WRONG
}

class AnswerTile extends StatelessWidget {
	final Answer answer;
	final AnswerState state;
	final VoidCallback onTap;
	const AnswerTile({ Key key, @required this.answer, this.state = AnswerState.NEUTER, @required this.onTap}) : assert( onTap != null ), super(key: key);
	@override
	Widget build(BuildContext context) => new InkWell(
		child: new Card(
			elevation: CARD_ELEVATION,
			color: state == AnswerState.NEUTER ? null : state == AnswerState.RIGHT ? Theme.of(context).accentColor : Theme.of(context).errorColor,
			child: new Padding(
				padding: const EdgeInsets.all(10.0),
				child: answer == null || answer.media_content.isEmpty ? _withoutMedia( context ) : _withMedia( context ),
			),
		),
		onTap: onTap,
	);
	
	Widget _withoutMedia( BuildContext context ) => new Column(
		children: <Widget>[
			new Text(
				answer == null ? S.of(context).not_answered : answer.text_content,
				style: new TextStyle(
					fontSize: 21.0,
					color: state == AnswerState.NEUTER ? null : Theme.of(context).primaryTextTheme.title.color,
				),
			),
		],
	);
	
	Widget _withMedia( BuildContext context ) => new Column(
		children: <Widget>[
			new Container(
				height: 250,
				child: new Swiper(
					itemBuilder: ( _, final int index ) => CachedNetworkImage(
						imageUrl: answer.media_content[index],
						fit: BoxFit.fill,
						placeholder: ( _, __ ) => new Center(
							child: new Text(
								S.of(context).image_not_found,
							),
						),
					),
					itemCount: answer.media_content.length,
				),
			),
			new Text(
				answer.text_content,
				style: new TextStyle(
					fontSize: 16.0,
					color: state == AnswerState.NEUTER ? null : Theme.of(context).primaryTextTheme.title.color,
				),
			),
		],
	);
}