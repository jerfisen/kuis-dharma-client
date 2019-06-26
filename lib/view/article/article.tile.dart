part of 'LearnPage.dart';

class _ArticleTile extends StatelessWidget {
	final Article article;
	const _ArticleTile({Key key, @required this.article}) : assert( article != null ), super(key: key);
	@override
	Widget build(BuildContext context) => new Card(
		elevation: CARD_ELEVATION,
		child: new Padding(
			padding: const EdgeInsets.all(10.0),
			child: new Column(
				children: <Widget>[
					new Text(
						article.title,
						style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
					),
					new Divider(
						height: 10.0,
					),
					new ZefyrView(
						document: _getDocument(),
						imageDelegate: new _ArticleTileImageDelegate(),
					),
				],
			),
		),
	);
	
	NotusDocument _getDocument() {
		final raw_data = article.content.toJson() as List;
		final data = raw_data.length > 1 ? ( raw_data.take(1).toList()..add( raw_data.last ) ).map( ( op ) => op.toJson() ).toList(growable: false) : raw_data.map( ( op ) => op.toJson() ).toList(growable: false);
		final document = new NotusDocument.fromJson( data );
		return document;
	}
}

class _ArticleTileImageDelegate extends ZefyrDefaultImageDelegate {
	@override
	Widget buildImage(BuildContext context, String imageSource) => new CachedNetworkImage(
		imageUrl: imageSource,
	);
}