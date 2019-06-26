import 'package:json_annotation/json_annotation.dart';
import 'package:zefyr/zefyr.dart';

part 'Article.g.dart';

@JsonSerializable( explicitToJson: true )
class Article {
	@JsonKey(ignore: true)
	String id;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: false)
	String topic_id;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: false)
	String title;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: false, fromJson: _contentFromJson, toJson: _contentToJson )
	NotusDocument content;
	
	Article({ this.id, this.topic_id, this.title, this.content });
	
	factory Article.fromJson( final Map<String, dynamic> json ) => _$ArticleFromJson(json);
	
	Map<String, dynamic> toJson() => _$ArticleToJson(this);
	
	static _contentFromJson( data ) => new NotusDocument.fromJson(data);
	static _contentToJson( final NotusDocument data ) => ( data.toJson() as List ).map( ( op ) => op.toJson() ).toList(growable: false);
}