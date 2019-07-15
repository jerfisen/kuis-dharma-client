import 'package:json_annotation/json_annotation.dart';
import 'package:kdygd/model/Question.dart';
import 'package:edenvidi_paging/edenvidi_paging.dart';

part 'Exam.g.dart';

@JsonSerializable()
class ArgSaveExam {
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final List<String> ids;
	ArgSaveExam(this.ids);
	
	Map<String, dynamic> toJson() => _$ArgSaveExamToJson(this);
}

@JsonSerializable()
class Work {
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final Answer question;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final Answer correct_answer;
	
	@JsonKey(required: true, nullable: true, disallowNullValue: false)
	final Answer selected_answer;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final bool is_correct;
	
	Work(this.question, this.correct_answer, this.selected_answer, this.is_correct);
	
	factory Work.fromJson( final Map<String, dynamic> json ) => _$WorkFromJson(json);
}

@JsonSerializable()
class Exam {
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final String id;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final DateTime date;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final double skor;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final List<Work> works;
	
	Exam( this.id, this.date, this.skor, this.works );
	
	factory Exam.fromJson( final Map<String, dynamic> json ) => _$ExamFromJson(json);
	Map<String, dynamic> toJson() => _$ExamToJson(this);
}

@JsonSerializable()
class Exams extends ListWithPageInfo<Exam> {
	Exams(PageInfo meta, List<Exam> list) : super(meta, list);
	
	factory Exams.fromJson( final Map<String, dynamic> json ) => _$ExamsFromJson(json);
	Map<String, dynamic> toJson() => _$ExamsToJson(this);
}

@JsonSerializable()
class ArgsWorks {
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final String question_id;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final String answer_id;
	
	ArgsWorks({ this.question_id, this.answer_id } );
	
	factory ArgsWorks.fromJson( final Map<String, dynamic> json ) => _$ArgsWorksFromJson(json);
	Map<String, dynamic> toJson() => _$ArgsWorksToJson(this);
}