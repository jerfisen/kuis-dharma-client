import 'dart:async';

import 'package:kdygd/model/Article.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kdygd/model/Topic.dart';

class ArticleRepository {
	static Future<void> save( final Article article ) async => await Firestore.instance.collection("articles").add( article.toJson() );
	static Future<void> update( final Article article ) async => await Firestore.instance.document("articles/${ article.id }").setData( article.toJson().remove("id") );
	
	static Stream<List<Article>> stream( final Topic topic, int length ) {
		return Firestore.instance.collection("articles").where("topic_id", isEqualTo: topic.id ).limit(length).snapshots().transform( new StreamTransformer.fromHandlers(
			handleData:  ( QuerySnapshot snapshot, EventSink<List<Article>> sink ) {
				try {
					final list = new List<Article>();
					for ( final doc in snapshot.documents ) list.add( Article.fromJson( doc.data )..id = doc.documentID );
					sink.add(list);
				} catch ( error, st ) {
					sink.addError(error, st);
				}
			},
		) );
	}
}