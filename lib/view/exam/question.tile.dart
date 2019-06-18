part of 'DoExam.dart';

class QuestionTile extends StatelessWidget {
	final Question question;
	const QuestionTile({ Key key, @required this.question}) : assert( question != null ), super(key: key);
	@override
	Widget build(BuildContext context) => new Card(
		elevation: CARD_ELEVATION,
		child: new Padding(
			padding: const EdgeInsets.all(10.0),
			child: question.media_content.isEmpty ? _withoutMedia() : _withMedia(context),
		),
	);
	
	Widget _withoutMedia() => new Column(
		children: <Widget>[
			new Text(
				question.text_content,
				style: const TextStyle(
					fontSize: 25.0,
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
						imageUrl: question.media_content[index],
						fit: BoxFit.fill,
						placeholder: ( _, __ ) => new Center(
							child: new Text(
								S.of(context).image_not_found,
							),
						),
					),
					itemCount: question.media_content.length,
				),
			),
			new Text(
				question.text_content,
				style: const TextStyle(
					fontSize: 21.0,
				),
			),
		],
	);
}