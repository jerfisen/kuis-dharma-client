import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:kdygd/generated/i18n.dart';

class SignIn extends StatefulWidget {
	final String front_page_error_message;
	SignIn({ this.front_page_error_message = null });
	@override
	State<StatefulWidget> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
	Future _signInWithGoogle() async {
		final loading_indicator = await FlushbarHelper.createLoading(message: S.of(context).please_wait, linearProgressIndicator: new LinearProgressIndicator(), duration: null);
		try {
			final GoogleSignInAccount google_account = await new GoogleSignIn().signIn();
			loading_indicator.show(context);
			final GoogleSignInAuthentication google_auth = await google_account.authentication;
			await FirebaseAuth.instance.signInWithCredential( GoogleAuthProvider.getCredential(idToken: google_auth.idToken, accessToken: google_auth.accessToken ) );
			await loading_indicator.dismiss();
		} catch ( error ) {
			await loading_indicator.dismiss();
			if ( error is SocketException )
				FlushbarHelper.createError(message: S.of(context).no_connection).show(context);
			else {
				FlushbarHelper.createError(message: S.of(context).cant_login).show(context);
			}
		} finally {
			if ( loading_indicator.isShowing() ) await loading_indicator.dismiss();
		}
	}
	Future _signInWithFacebook() async {
		FlushbarHelper.createError(message: "Not Implemented").show(context);
		/*
		try {
			setState(() {
				_busy = true;
			});
			FacebookLoginResult result = await new FacebookLogin().logInWithReadPermissions(['email', 'public_profile']);
			switch (result.status) {
				case FacebookLoginStatus.loggedIn: {
					await FirebaseAuth.instance.signInWithCredential( FacebookAuthProvider.getCredential(accessToken: result.accessToken.token) );
				} break;
				case FacebookLoginStatus.cancelledByUser: {
					if ( mounted ) setState(() {
						_busy = false;
					}); else _busy = false;
				} break;
				case FacebookLoginStatus.error: {
					if ( mounted ) setState(() {
						_busy = false;
					}); else _busy = false;
					showErrorMessage(context, message: result.errorMessage);
				} break;
			}
		} catch (error, st) {
			ErrorReporter.instance.captureException(error, stack_trace: st);
			showErrorMessage(context, message: I18N.of(context).common.cant_login );
		}
		*/
	}
	Future<void> _signInAnonymously() async {
		try {
			await FirebaseAuth.instance.signInAnonymously();
		} catch ( _ ) {
			FlushbarHelper.createError(message: S.of(context).cant_login).show(context);
		}
	}
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new SafeArea(
			child: new Container(
				padding: const EdgeInsets.only(top: 25.0, right: 50.0, bottom: 25.0, left: 50.0),
				child: new Column(
					mainAxisAlignment: MainAxisAlignment.spaceBetween,
					mainAxisSize: MainAxisSize.max,
					crossAxisAlignment: CrossAxisAlignment.center,
					children: <Widget>[
						new Flexible(
							fit: FlexFit.loose,
							flex: 4,
							child: new LayoutBuilder(
								builder: ( _, constraints ) => new Image.asset(
									"images/logo.jpg",
								),
							),
						),
						new Column(
							mainAxisSize: MainAxisSize.min,
							mainAxisAlignment: MainAxisAlignment.start,
							crossAxisAlignment: CrossAxisAlignment.stretch,
							children: <Widget>[
								new GoogleSignInButton(
									onPressed: _signInWithGoogle,
								),
								new FacebookSignInButton(
									onPressed: _signInWithFacebook,
								),
								new RaisedButton(
									child: new Text(
										S.of(context).skip,
										style: new TextStyle(
											color: Theme.of(context).accentColor,
											fontWeight: FontWeight.bold,
											fontSize: 18.0,
										),
									),
									onPressed: _signInAnonymously,
								),
							].where( ( widget ) => widget != null ).toList(growable: false),
						),
						new Align(
							alignment: Alignment.bottomCenter,
							child: new RichText(
								text: new TextSpan(
									children: <TextSpan>[
										new TextSpan(
											style: Theme.of(context).textTheme.body1,
											text: "abcdef",
										),
										new TextSpan(
											text: "ghijklmno",
											style: new TextStyle(
												color: Theme.of(context).primaryTextTheme.title.color,
												decoration: TextDecoration.underline,
											),
										),
									],
								),
							),
						),
					],
				),
			),
		),
	);
	@override
	void initState() {
		super.initState();
		if(widget.front_page_error_message != null) {
			new Future.delayed(Duration.zero, () {
				FlushbarHelper.createError(message: widget.front_page_error_message).show(context);
			});
		}
	}
}