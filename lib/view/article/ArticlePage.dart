
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kdygd/model/Article.dart';
import 'package:zefyr/zefyr.dart';

class ArticlePage extends StatelessWidget {
	final Article article;
	const ArticlePage({Key key, @required this.article}) : assert( article != null ), super(key: key);
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new NestedScrollView(
			headerSliverBuilder: ( _, __ ) => <Widget>[
				new SliverAppBar(
					title: new Text(
						article.title,
					),
				),
			],
			body: new Padding(
				padding: const EdgeInsets.all(10.0),
				child: new ZefyrView(
					document: article.content,
					imageDelegate: new _ArticlePageImageDelegate(),
				),
			),
		),
	);
}

class _ArticlePageImageDelegate extends ZefyrDefaultImageDelegate {
	@override
	Widget buildImage(BuildContext context, String imageSource) => new CachedNetworkImage(
		imageUrl: imageSource,
	);
}