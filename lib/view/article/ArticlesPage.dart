import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kdygd/Navigate.dart';
import 'package:kdygd/common/Config.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/model/Article.dart';
import 'package:kdygd/model/Topic.dart';
import 'package:kdygd/repository/ArticleRepository.dart';
import 'package:zefyr/zefyr.dart';

part 'article.tile.dart';

class LearnPage extends StatefulWidget {
	final Topic topic;
	const LearnPage({Key key, @required this.topic}) : assert( topic != null ), super(key: key);
	@override
	State<StatefulWidget> createState() => _LearnPageState();
}

class _LearnPageState extends State<LearnPage> {
	int _length = 25;
	Stream<List<Article>> _article_stream;
	@override
	Widget build(BuildContext context) => new Scaffold(
		floatingActionButton: new FloatingActionButton(
			child: const Icon(Icons.add),
			onPressed: () => Navigate.instance.createArticle(context, widget.topic),
		),
		body: new NestedScrollView(
			headerSliverBuilder: ( _, __ ) => <Widget>[
				new SliverAppBar(
					title: new Text(
						S.of(context).article,
					),
				),
			],
			body: new StreamBuilder<List<Article>>(
				stream: _article_stream,
				initialData: const [],
				builder: ( _ , snapshot ) {
					if ( snapshot.hasData ) {
						return new ListView.builder(
							itemCount: snapshot.data.length,
							padding: const EdgeInsets.all(10.0),
							itemBuilder: ( _, final int index ) => new Padding(
								padding: const EdgeInsets.symmetric(vertical: 5.0),
								child: new InkWell(
									child: new _ArticleTile(
										article: snapshot.data[index],
									),
									onTap: () => Navigate.instance.viewArticle(context, snapshot.data[index]),
								),
							),
						);
					} else {
						return new Column(
							crossAxisAlignment: CrossAxisAlignment.center,
							mainAxisAlignment: MainAxisAlignment.center,
							mainAxisSize: MainAxisSize.min,
							children: <Widget>[
								new Text(
									S.of(context).error_occurred,
								),
							],
						);
					}
				},
			),
		),
	);
	
	@override
	void initState() {
		_article_stream = ArticleRepository.stream(widget.topic, _length);
		super.initState();
	}
}