import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:kdygd/model/Article.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kdygd/model/Topic.dart';

class QuizRepository {
	static Future<void> save( final Article article ) async => await Firestore.instance.collection("articles").add( article.toJson() );
	static Future<void> update( final Article article ) async => await Firestore.instance.document("articles/${ article.id }").setData( article.toJson().remove("id") );
	
	static Stream<List<Article>> stream( final Topic topic, int length ) {
		return Firestore.instance.collection("quiz").where("date", isEqualTo: topic.id ).limit(length).snapshots().transform( new StreamTransformer.fromHandlers(
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
	
	static Future<int> getSeed( DateTime date ) async {
		try {
			final snapshot = await Firestore.instance.collection("quiz").where("date", isGreaterThan: new DateTime.now() ).getDocuments();
			if ( snapshot.documents.isNotEmpty ) {
				return snapshot.documents.first.data["seed"];
			}
			else return null;
		} catch ( error ) {
			throw error;
		}
	}
	
	static Future<bool> exists( DateTime date ) async {
		try {
			final snapshot = await Firestore.instance.collection("quiz").where("date", isGreaterThan: new DateTime.now() ).getDocuments();
			return snapshot.documents.isNotEmpty;
		} catch ( error ) {
			throw error;
		}
	}
	
	static Future<DateTime> isAlreadyRegistered() async {
		try {
			final snapshot = await Firestore.instance.collection("quiz").where("date", isGreaterThan: new DateTime.now() ).getDocuments();
			if ( snapshot.documents.isEmpty ) return null;
			if ( snapshot.documents.first.data.containsKey("audiences") ) {
				if ( ( snapshot.documents.first.data["audiences"] as List ).contains( ( await FirebaseAuth.instance.currentUser() ).uid ) ) {
					return ( snapshot.documents.first.data["date"] as Timestamp ).toDate();
				}
				else return null;
			} else return null;
		} catch ( error ) {
			throw error;
		}
	}
	
	static Stream<DateTime> isAlreadyRegisteredStream() => Firestore.instance.collection("quiz").where("date", isGreaterThan: new DateTime.now() ).snapshots().transform( new StreamTransformer.fromHandlers(
		handleData:  ( QuerySnapshot snapshot, EventSink<DateTime> sink ) async {
			try {
				if ( snapshot.documents.isEmpty ) sink.add(null);
				else {
					if ( snapshot.documents.first.data.containsKey("audiences") ) {
						sink.add(null);
						if ( ( snapshot.documents.first.data["audiences"] as List ).contains( ( await FirebaseAuth.instance.currentUser() ).uid ) ) {
							sink.add( ( snapshot.documents.first.data["date"] as Timestamp ).toDate() );
						}
						else sink.add( null );
					} else sink.add(null);
				}
			} catch ( error, st ) {
				sink.addError(error, st);
				print(error);
			}
		},
	) );
	
	static Future<void> register( final DateTime date, [ final int seed = -1 ] ) async {
		final snapshot = await Firestore.instance.collection("quiz").where("date", isEqualTo: date ).getDocuments();
		if ( snapshot.documents.isEmpty ) {
			print("empty");
			await Firestore.instance.collection("quiz").add({
				"date": date,
				"audience_count": 1,
				"seed": seed,
				"audiences": <String>[
					( await FirebaseAuth.instance.currentUser() ).uid,
				],
			});
		} else {
			final doc = snapshot.documents.first;
			final audiences = new List();
			audiences.addAll( doc.data["audiences"] );
			audiences.add( ( await FirebaseAuth.instance.currentUser() ).uid );
			await Firestore.instance.document("quiz/${doc.documentID}").updateData({
				"audience_count": doc.data["audience_count"] + 1,
				"audiences": audiences,
			});
		}
	}
	
	static Stream<int> streamAudience( final DateTime date ) => Firestore.instance.collection("quiz").where("date", isEqualTo: date ).snapshots().transform( new StreamTransformer.fromHandlers(
		handleData:  ( QuerySnapshot snapshot, EventSink<int> sink ) {
			try {
				sink.add( snapshot.documents.isEmpty ? 0 : snapshot.documents.first.data["audience_count"] );
			} catch ( error, st ) {
				sink.addError(error, st);
			}
		},
	) );
}