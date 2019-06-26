part of 'ProfilePage.dart';

class _ProfileEditPage extends StatefulWidget {
	@override
	State createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<_ProfileEditPage> {
	TextEditingController _username_controller, _email_controller, _phone_number_controller;
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new NestedScrollView(
			headerSliverBuilder: ( _, __ ) => <Widget>[
				new SliverAppBar(
					title: new Text(
						S.of(context).edit_profile,
					),
				),
			],
			body: new ListView(
				padding: const EdgeInsets.all(30.0),
				children: <Widget>[
					new Center(
						child: new Column(
							children: <Widget>[
								new AccountIcon(
									size: MediaQuery.of(context).size.width / 2 - 20,
								),
								new FlatButton(
									child: new Text(
										S.of(context).edit_photo_profile
									),
									onPressed: _onUpdatePhotoProfile,
								),
							],
						),
					),
					new Divider(
						height: 30.0,
					),
					new Column(
						mainAxisSize: MainAxisSize.min,
						crossAxisAlignment: CrossAxisAlignment.start,
						children: <Widget>[
							new Text(
								S.of(context).username,
								textAlign: TextAlign.left,
							),
							new TextField(
								controller: _username_controller,
								style: Theme.of(context).primaryTextTheme.title.copyWith(color: Theme.of(context).textTheme.body1.color),
								onEditingComplete: _onUpdateUsername,
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
							new TextField(
								controller: _email_controller,
								style: Theme.of(context).primaryTextTheme.title.copyWith(color: Theme.of(context).textTheme.body1.color),
								keyboardType: TextInputType.emailAddress,
								onEditingComplete: _onUpdateEmail,
							),
						],
					),
				],
			),
		),
	);
	
	void _onUpdatePhotoProfile() async {
		final source = await showModalBottomSheet<ImageSource>(
			context: context,
			builder: ( final BuildContext modal_context ) => new ListView(
				shrinkWrap: true,
				children: <Widget>[
					new ListTile(
						leading: const Icon(Icons.cancel),
						title: new Text(
							S.of(context).cancel,
							style: Theme.of( modal_context ).primaryTextTheme.title.copyWith( color: Theme.of( modal_context ).textTheme.body1.color ),
						),
						onTap: () => Navigator.of(context).pop(),
					),
					new ListTile(
						leading: const Icon(Icons.camera_alt),
						title: new Text(
							S.of(context).camera,
							style: Theme.of( modal_context ).primaryTextTheme.title.copyWith( color: Theme.of( modal_context ).textTheme.body1.color ),
						),
						onTap: () => Navigator.of(context).pop(ImageSource.camera),
					),
					new ListTile(
						leading: const Icon(Icons.photo_album),
						title: new Text(
							S.of(context).gallery,
							style: Theme.of( modal_context ).primaryTextTheme.title.copyWith( color: Theme.of( modal_context ).textTheme.body1.color ),
						),
						onTap: () => Navigator.of(context).pop(ImageSource.gallery),
					),
				],
			)
		);
		if ( source == null ) return;
		final file = await ImagePicker.pickImage(source: source);
		if (file == null) return;
		
		final cropped_image = await ImageCropper.cropImage(
			sourcePath: file.path,
			ratioX: 1.0,
			ratioY: 1.0,
			maxWidth: 512,
			maxHeight: 512,
			circleShape: true,
		);
		
		if ( cropped_image == null ) return;
		
		final indicator = FlushbarHelper.createLoading(message: S.of(context).please_wait, linearProgressIndicator: new LinearProgressIndicator(), duration: null);
		try {
			indicator.show(context);
			final ref = FirebaseStorage.instance.ref().child("profile").child( Uuid().v4() );
			final upload_task = ref.putFile(
				cropped_image,
				new StorageMetadata(
					cacheControl: "public, max-age=31536000",
					contentType: lookupMimeType(cropped_image.path),
				),
			);
			await upload_task.onComplete;
			final url = await ref.getDownloadURL();
			
			final user = await FirebaseAuth.instance.currentUser();
			final update_info = new UserUpdateInfo();
			update_info.displayName = _username_controller.text;
			update_info.photoUrl = url;
			await user.updateProfile( update_info );
			await indicator.dismiss();
			if ( mounted ) setState(() {});
		} catch ( error ) {
			await indicator.dismiss();
			FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
		} finally {
			if ( indicator.isShowing() ) await indicator.dismiss();
		}
	}
	
	void _onUpdateUsername() async {
		final indicator = FlushbarHelper.createLoading(message: S.of(context).please_wait, linearProgressIndicator: new LinearProgressIndicator(), duration: null);
		try {
			indicator.show(context);
			final user = await FirebaseAuth.instance.currentUser();
			final update_info = new UserUpdateInfo();
			update_info.displayName = _username_controller.text;
			update_info.photoUrl = user.photoUrl;
			await user.updateProfile( update_info );
			await indicator.dismiss();
		} catch ( error ) {
			await indicator.dismiss();
			FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
		} finally {
			if ( indicator.isShowing() ) await indicator.dismiss();
		}
	}
	
	void _onUpdateEmail() async {
		final indicator = FlushbarHelper.createLoading(message: S.of(context).please_wait, linearProgressIndicator: new LinearProgressIndicator(), duration: null);
		try {
			indicator.show(context);
			final user = await FirebaseAuth.instance.currentUser();
			await user.updateEmail(_email_controller.text);
			await indicator.dismiss();
		} catch ( error ) {
			await indicator.dismiss();
			FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
		} finally {
			if ( indicator.isShowing() ) await indicator.dismiss();
		}
	}
	
	@override
	void initState() {
		_username_controller = new TextEditingController();
		_email_controller = new TextEditingController();
		_phone_number_controller = new TextEditingController();
		new Future.delayed(Duration.zero, _loadUser);
		super.initState();
	}
	
	@override
	void dispose() {
		_username_controller.dispose();
		_email_controller.dispose();
		_phone_number_controller.dispose();
		super.dispose();
	}
	
	void _loadUser() async {
		final user = await FirebaseAuth.instance.currentUser();
		_username_controller.text = user.displayName;
		_email_controller.text = user.email;
		_phone_number_controller.text = user.phoneNumber.isNotEmpty ? user.phoneNumber : "-";
	}
}