import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/view/common/AccountIcon.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

part 'profile.edit.dart';

class ProfilePage extends StatefulWidget {
	@override
	State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
	Future<FirebaseUser> _user_loader;
	@override 
	Widget build(BuildContext context) => new Scaffold(
		body: new NestedScrollView(
			headerSliverBuilder: ( _, __ ) => <Widget>[
				new SliverAppBar(
					title: new Text(
						S.of(context).profile,
					),
					actions: <Widget>[
						new IconButton(
							icon: const Icon(Icons.edit),
							onPressed: _onUpdateProfile,
						),
					],
				),
			],
			body: new Center(
				child: new FutureBuilder<FirebaseUser>(
					future: _user_loader,
					initialData: null,
					builder: ( _, snapshot ) {
						if ( snapshot.connectionState == ConnectionState.done ) {
							return new ListView(
								padding: const EdgeInsets.all(30.0),
								shrinkWrap: true,
								children: <Widget>[
									new Center(
										child: AccountIcon(
											size: MediaQuery.of(context).size.width / 2 - 20,
										),
									),
									new Divider(
										height: 10.0,
									),
									new Column(
										mainAxisSize: MainAxisSize.min,
										crossAxisAlignment: CrossAxisAlignment.start,
										children: <Widget>[
											new Text(
												S.of(context).username,
												textAlign: TextAlign.left,
											),
											new Text(
												snapshot.data.displayName,
												style: Theme.of(context).primaryTextTheme.title.copyWith(color: Theme.of(context).textTheme.body1.color),
												textAlign: TextAlign.left,
											),
										],
									),
									new Divider(
										height: 30.0,
									),
									new Column(
										mainAxisSize: MainAxisSize.min,
										crossAxisAlignment: CrossAxisAlignment.start,
										children: <Widget>[
											new Text(
												S.of(context).email,
												textAlign: TextAlign.left,
											),
											new Text(
												snapshot.data.email,
												style: Theme.of(context).primaryTextTheme.title.copyWith(color: Theme.of(context).textTheme.body1.color),
												textAlign: TextAlign.left,
											),
										],
									),
								],
							);
						} else {
							return new Center(
								child: new CircularProgressIndicator(),
							);
						}
					},
				),
			),
		),
	);
	
	void _onUpdateProfile() async {
		await Navigator.of(context).push( new MaterialPageRoute( builder: ( _ ) => new _ProfileEditPage()  ) );
		if ( mounted ) setState( () { _user_loader = FirebaseAuth.instance.currentUser(); } );
	}
	
	@override
	void initState() {
		_user_loader = FirebaseAuth.instance.currentUser();
		super.initState();
	}
}