import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/graphql/topic.dart';
import 'package:kdygd/model/Topic.dart';
import 'package:flutter_tags/selectable_tags.dart';

class SelectTopicPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => _SelectTopicPageState();
}

class _SelectTopicPageState extends State<SelectTopicPage> {
	final List<Topic> _topics = new List();
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new NestedScrollView(
			headerSliverBuilder: ( _, __ ) => <Widget>[
				new SliverAppBar(
					title: new Text(
						S.of(context).topics,
					),
				),
			],
			body: new SelectableTags(
				tags: _topics.map( ( topic ) => new Tag(
					id: int.tryParse( topic.id ) ?? 0,
					title: topic.name,
					active: true,
				) ).toList(growable: false),
				onPressed: _onTagSelected,
				fontSize: 18.0,
				activeColor: Theme.of(context).chipTheme.selectedColor,
				color: Theme.of(context).chipTheme.backgroundColor,
				singleItem: true,
			),
		),
	);
	
	void _onTagSelected( Tag tag ) {
		Navigator.of(context).pop( _topics.firstWhere( (topic ) => int.tryParse( topic.id ) == tag.id, orElse: () => null ) );
	}
	
	@override
	void initState() {
		super.initState();
		new Future.delayed(Duration.zero, _loadTopics);
	}
	
	void _loadTopics() async {
		final result = await GraphQLProvider.of(context).value.query( new QueryOptions(
				document: QUERY_TOPICS,
				variables: {
					"per_page": 100,
					"page": 1,
				},
				fetchPolicy: FetchPolicy.networkOnly
		) );
		if ( result.hasErrors ) {
			FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
		} else {
			final topics = Topics.fromJson( result.data["topics"] );
			if ( mounted ) setState(() {
				_topics.addAll( topics.list );
			});
		}
	}
}