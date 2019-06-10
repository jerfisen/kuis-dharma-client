import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kdygd/view/MainPage.dart';
import 'package:kdygd/view/SignIn.dart';

class Session {
	static final Session _session = Session._internal();
	static Session get instance => _session;
	GlobalKey<NavigatorState> _navigator_state;
	void init( GlobalKey<NavigatorState> navigator_state ) => _navigator_state = navigator_state;
	
	bool _is_anonymous = false;
	
	Stream<String> _first_name_stream, _surname_stream, _bio_stream;
	
	Stream<String> get first_name_stream => _first_name_stream;
	Stream<String> get surname_stream => _surname_stream;
	Stream<String> get bio_stream => _bio_stream;
	
	bool get is_anonymous => _is_anonymous;
	
	Session._internal() {
		FirebaseAuth.instance.onAuthStateChanged.listen( (FirebaseUser user) async {
			if ( user == null ) {
				_navigator_state.currentState.pushAndRemoveUntil(
					new MaterialPageRoute(
						builder: ( _ ) => new SignIn(),
					),
					( _ ) => false,
				);
			}
			else {
				_navigator_state.currentState.pushAndRemoveUntil(
					new MaterialPageRoute(
						builder: ( _ ) => new MainPage(),
					),
					( _ ) => false,
				);
			}
		} ).onError( (error, st) async {
			_navigator_state.currentState.pushAndRemoveUntil(
				new MaterialPageRoute(
					builder: (_) => new SignIn(front_page_error_message: error.toString(),),
				),
				(_) => false,
			);
		} );
	}
	Future<Null> updatePhotoProfileName(final String file_name) async {
		FirebaseUser user = await FirebaseAuth.instance.currentUser();
		UserUpdateInfo user_update_info = new UserUpdateInfo();
		user_update_info.photoUrl = file_name;
		
		await user.updateProfile(user_update_info);
	}
	Future<Null> updateDisplayName(final String display_name) async {
		FirebaseUser user = await FirebaseAuth.instance.currentUser();
		UserUpdateInfo user_update_info = new UserUpdateInfo();
		user_update_info.displayName = display_name;
		await user.updateProfile(user_update_info);
	}
	Future<String> getEmail() async => ( await FirebaseAuth.instance.currentUser() ).email;
	Future<String> getPhoneNumber() async => ( await FirebaseAuth.instance.currentUser() ).phoneNumber;
}