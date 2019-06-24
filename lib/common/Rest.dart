
import 'dart:async';
import 'dart:io';
import 'package:meta/meta.dart';
import 'package:dio/dio.dart';

enum REQUEST_METHOD {
	HEAD,
	GET,
	POST,
	PUT,
	DELETE,
}

abstract class Rest<T> {
	final Dio _client;
	Rest(this._client);
	Future<T> execute() async {
		try {
			final res = await makeRequest();
			return await onResponse(res);
		} catch ( error ) {
			if ( error is DioError ) {
				if ( error.type == DioErrorType.RESPONSE ) {
					await onResponseError(error.response);
				}
				else rethrow;
			}
			else rethrow;
		}
		return null;
	}
	
	@protected
	Future<Response<Map<String, dynamic>>> makeRequest( { ProgressCallback onSendProgress, ProgressCallback onReceiveProgress, CancelToken cancel_token } ) async {
		final options = new Options(
			headers: await headers,
			contentType: ContentType.json,
			responseType: ResponseType.json,
		);
		switch ( method ) {
			case REQUEST_METHOD.HEAD: return await _client.headUri(await uri, options: options, cancelToken: cancel_token, data: await body );
			case REQUEST_METHOD.GET: return await _client.getUri( await uri, options: options, onReceiveProgress: onReceiveProgress, cancelToken: cancel_token );
			case REQUEST_METHOD.POST: return await _client.postUri( await uri, data: await body, options: options, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress, cancelToken: cancel_token );
			case REQUEST_METHOD.PUT: return await _client.putUri( await uri, data: await body, options: options, onSendProgress: onSendProgress, onReceiveProgress: onReceiveProgress, cancelToken: cancel_token );
			case REQUEST_METHOD.DELETE: return await _client.deleteUri( await uri, data: await body, options: options, cancelToken: cancel_token );
		}
		return null;
	}
	
	@protected
	Future<Uri> get uri async {
		if ( is_secure ) return new Uri.https( await domain, path, await query);
		else return Uri.http(await domain, path, await query);
	}
	
	bool get is_secure;
	Future<String> get domain;
	String get path;
	Future<Map<String, dynamic>> get body async => null;
	Future<Map<String, String>> get query async => null;
	Future<Map<String, String>> get headers async => null;
	
	Future<T> onResponse(Response<Map<String, dynamic>> res);
	Future<void> onResponseError( Response res );
	
	@protected
	REQUEST_METHOD get method;
}