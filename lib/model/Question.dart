import 'package:json_annotation/json_annotation.dart';
import 'package:kdygd/model/Topic.dart';
import 'package:meta/meta.dart';

part 'Question.g.dart';

@JsonSerializable( explicitToJson: true )
class Question {
	@JsonKey( required: true, nullable: false, disallowNullValue: true )
	final String id;
	
	@JsonKey( required: true, nullable: false, disallowNullValue: true )
	final String text_content;
	
	@JsonKey( required: true, nullable: false, disallowNullValue: true )
	final List<String> media_content;
	
	@JsonKey( required: true, nullable: false, disallowNullValue: true )
	final List<Answer> answers;
	
	@JsonKey( required: true, nullable: false, disallowNullValue: true )
	final List<Topic> topics;
	
	Question({
		@required this.id,
		@required this.text_content,
		@required  this.media_content,
		@required  this.answers,
		@required  this.topics
	}) : assert( id != null ),
				assert( text_content != null ),
				assert( media_content != null ),
				assert( answers != null ),
				assert( topics != null );
	
	factory Question.fromJson( final Map<String, dynamic> json ) => _$QuestionFromJson(json);
	Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Answer {
	@JsonKey( required: true, nullable: false, disallowNullValue: true )
	final String id;
	
	@JsonKey( required: true, nullable: false, disallowNullValue: true )
	final String text_content;
	
	@JsonKey( required: true, nullable: false, disallowNullValue: true )
	final List<String> media_content;
	
	Answer( {
		@required this.id,
		@required this.text_content,
		@required this.media_content
	}): assert( id != null ),
				assert( text_content != null ),
				assert( media_content != null );
	
	factory Answer.fromJson( final Map<String, dynamic> json ) => _$AnswerFromJson(json);
	Map<String, dynamic> toJson() => _$AnswerToJson(this);
}