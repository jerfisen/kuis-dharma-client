import 'package:kdygd/common/ExamRest.dart';
import 'package:kdygd/common/Rest.dart';
import 'package:kdygd/model/Exam.dart';
import 'package:edenvidi_paging/edenvidi_paging.dart';

class ExamRepository {
	static Future<ExamResult> save( ArgSaveExam exam ) async => await new _ExamSaveER(exam).execute();
	static Future<ExamResults> loadMany( ArgPageInfo page_info ) async => await new _ExamResultsER(page_info).execute();
}

class _ExamResultsER extends ExamRest<ExamResults> {
	final ArgPageInfo _page_info;
	_ExamResultsER( this._page_info );
	@override REQUEST_METHOD get method => REQUEST_METHOD.GET;
	@override Future<ExamResults> onData(Map<String, dynamic> data) => Future.value(ExamResults.fromJson(data));
	@override String get path => "";
	@override Future<Map<String, String>> get query => Future.value( _page_info.toJson().map( ( key, value ) => new MapEntry(key, value) ) );
}

class _ExamSaveER extends ExamRest<ExamResult> {
	final ArgSaveExam input;
	_ExamSaveER(this.input);
	@override REQUEST_METHOD get method => REQUEST_METHOD.POST;
	@override Future<ExamResult> onData(Map<String, dynamic> data) => Future.value(ExamResult.fromJson(data));
	@override String get path => "";
	@override Future<Map<String, dynamic>> get body => Future.value(input.toJson());
}