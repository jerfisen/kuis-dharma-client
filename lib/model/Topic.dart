import 'package:json_annotation/json_annotation.dart';
import 'package:edenvidi_paging/edenvidi_paging.dart';

part 'Topic.g.dart';

@JsonSerializable()
class Topic {
	@JsonKey(nullable: false, required: true, disallowNullValue: true)
	final int id;
	
	@JsonKey(nullable: false, required: true, disallowNullValue: true)
	final String name;
	
	Topic({ this.id, this.name }): assert( id != null ), assert( name != null );
	
	factory Topic.fromJson( final Map<String, dynamic> json ) => _$TopicFromJson(json);
	Map<String, dynamic> toJson() => _$TopicToJson(this);
}

@JsonSerializable()
class Topics extends ListWithPageInfo<Topic> {
	Topics(PageInfo page_info, List<Topic> list) : super(page_info, list);
	factory Topics.fromJson( final Map<String, dynamic> json ) => _$TopicsFromJson(json);
	Map<String, dynamic> toJson() => _$TopicsToJson(this);
}