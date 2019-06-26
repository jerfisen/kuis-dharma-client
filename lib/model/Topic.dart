import 'package:json_annotation/json_annotation.dart';

part 'Topic.g.dart';

@JsonSerializable()
class Topic {
	@JsonKey(nullable: false, required: true, disallowNullValue: true)
	final String id;
	
	@JsonKey(nullable: false, required: true, disallowNullValue: true)
	final String name;
	
	Topic({ this.id, this.name }): assert( id != null ), assert( name != null );
	
	factory Topic.fromJson( final Map<String, dynamic> json ) => _$TopicFromJson(json);
	Map<String, dynamic> toJson() => _$TopicToJson(this);
}