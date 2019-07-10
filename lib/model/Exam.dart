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
class ExamResult {
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final String id;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final DateTime date;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final double skor;
	
	@JsonKey(required: true, nullable: false, disallowNullValue: true)
	final List<Work> works;
	
	ExamResult(this.id, this.date, this.skor, this.works);
	
	factory  ExamResult.fromJson( final Map<String, dynamic> json ) => _$ExamResultFromJson(json);
	Map<String, dynamic> toJson() => _$ExamResultToJson(this);
}

@JsonSerializable()
class ExamResults extends ListWithPageInfo<ExamResult> {
	ExamResults(PageInfo meta, List<ExamResult> list) : super(meta, list);
	
	factory ExamResults.fromJson( final Map<String, dynamic> json ) => _$ExamResultsFromJson(json);
	Map<String, dynamic> toJson() => _$ExamResultsToJson(this);
}