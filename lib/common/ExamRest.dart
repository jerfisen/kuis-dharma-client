import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kdygd/common/Rest.dart';

abstract class ExamRest<T> extends Rest<T> {
	ExamRest() : super(_ExamClient.instance._dio);
	
	Future<T> onResponse(Response<Map<String, dynamic>> res) async {
		return await onData(res.data);
	}
	
	@override
	Future<void> onResponseError(Response res) {
		throw new Exception(res.data);
	}
	
	@override bool get is_secure => false;
	@override Future<String> get domain async => Future.value("kodexa.herokuapp.com");
	
	Future<T> onData( Map<String, dynamic> data );
	
	@override Future<Map<String, String>> get headers async {
		final user = await FirebaseAuth.instance.currentUser();
		if ( user != null ) {
			return {
				"Authorization": "Bearer ${ await user.getIdToken() }",
			};
		} else {
			return super.headers;
		}
	}
}

class _ExamClient {
	static final _ExamClient _client = new _ExamClient._internal();
	static _ExamClient get instance => _client;
	_ExamClient._internal() {
		_dio = new Dio();
		_dio.httpClientAdapter = DefaultHttpClientAdapter();
	}
	Dio _dio;
}