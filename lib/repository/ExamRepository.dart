import 'package:kdygd/common/ExamRest.dart';
import 'package:kdygd/common/Rest.dart';
import 'package:kdygd/model/Exam.dart';

class ExamRepository {
	static Future<ExamResult> save( ArgSaveExam exam ) async => await new _ExamSaveER(exam).execute();
}

class _ExamSaveER extends ExamRest<ExamResult> {
	final ArgSaveExam input;
	_ExamSaveER(this.input);
	@override REQUEST_METHOD get method => REQUEST_METHOD.POST;
	@override Future<ExamResult> onData(Map<String, dynamic> data) => Future.value(ExamResult.fromJson(data));
	@override String get path => "";
	@override Future<Map<String, dynamic>> get body => Future.value(input.toJson());
}