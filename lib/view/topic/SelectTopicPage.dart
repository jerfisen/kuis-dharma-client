import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/graphql/topic.dart';
import 'package:kdygd/model/Topic.dart';
import 'package:rxdart/rxdart.dart';

class SelectTopicPage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => _SelectTopicPageState();
}

class _SelectTopicPageState extends State<SelectTopicPage> {
	BehaviorSubject<List<Topic>> _topics_subject;
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
			body: new Padding(
				padding: const EdgeInsets.symmetric(horizontal: 20.0),
				child: new SingleChildScrollView(
					child: new StreamBuilder<List<Topic>>(
						stream: _topics_subject.stream,
						initialData: const [],
						builder: ( _, snapshot ) => new Wrap(
							spacing: 10.0,
							runSpacing: 10.0,
							runAlignment: WrapAlignment.center,
							children: snapshot.data.map( ( final Topic topic ) => new ActionChip(
								onPressed: () => Navigator.of(context).pop(topic),
								label: new Text(
									topic.name,
								),
							) ).toList(),
						),
					),
				),
			),
		),
	);
	
	@override
	void initState() {
		_topics_subject = new BehaviorSubject.seeded([]);
		super.initState();
		new Future.delayed(Duration.zero, _loadTopics);
	}
	
	@override
	void dispose() {
		if ( _topics_subject != null && !_topics_subject.isClosed ) _topics_subject.close();
		super.dispose();
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
			if ( mounted ) setState(() {
				_topics_subject.add( ( result.data["topics"]["list"] as List ).map( ( data ) => Topic.fromJson( data ) ).toList() );
			});
		}
	}
}