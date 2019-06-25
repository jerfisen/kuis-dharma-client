import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kdygd/generated/i18n.dart';
import 'package:kdygd/model/Article.dart';
import 'package:kdygd/repository/ArticleRepository.dart';
import 'package:uuid/uuid.dart';
import 'package:zefyr/zefyr.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mime/mime.dart';
import 'package:image_cropper/image_cropper.dart';

class ArticleEditor extends StatefulWidget {
	final Article article;
	const ArticleEditor({Key key, this.article}) : super(key: key);
	@override State createState() => _ArticleEditorState();
}

class _ArticleEditorState extends State<ArticleEditor> {
	TextEditingController _title_controller;
	ZefyrController _editor_controller;
	FocusNode _editor_focus_node;
	@override
	Widget build(BuildContext context) => new Scaffold(
		appBar: new AppBar(
			title: new Text(
				widget.article == null ? S.of(context).create_article : S.of(context).edit_article,
			),
			actions: <Widget>[
				new FlatButton(
					child: new Text(
						S.of(context).save,
						style: new TextStyle(
							color: Theme.of(context).primaryTextTheme.title.color,
						),
					),
					onPressed: _onSave,
				),
			],
		),
		body: new Column(
			children: <Widget>[
				new Divider(
					height: 10.0,
				),
				new Padding(
					padding: const EdgeInsets.symmetric(horizontal: 25.0),
					child: new TextField(
						controller: _title_controller,
						decoration: InputDecoration(
							hintText: S.of(context).title,
							alignLabelWithHint: true,
						),
						textAlign: TextAlign.center,
					),
				),
				new Divider(
					height: 20.0,
				),
				new Expanded(
					child: new Padding(
						padding: const EdgeInsets.all(5.0),
						child: new Container(
							decoration: BoxDecoration(
								border: Border.all(color: Colors.grey.shade900 )
							),
							child: new ZefyrScaffold(
								child: new ZefyrTheme(
									data: _getTheme(),
									child: new ZefyrField(
										controller: _editor_controller,
										focusNode: _editor_focus_node,
										imageDelegate: new _ArticleImageDelegate(),
									),
								),
							),
						),
					),
				),
			],
		),
	);
	
	ZefyrThemeData _getTheme() => new ZefyrThemeData(
		cursorColor: Colors.blue,
		toolbarTheme: ZefyrToolbarTheme.fallback(context).copyWith(
			color: Colors.grey.shade800,
			toggleColor: Colors.grey.shade900,
			iconColor: Colors.white,
			disabledIconColor: Colors.grey.shade500,
		),
	);
	
	void _onSave() async {
		final indicator = FlushbarHelper.createLoading(message: S.of(context).please_wait, linearProgressIndicator: new LinearProgressIndicator(), duration: null );
		try {
			indicator.show(context);
			if ( widget.article.content == null ) {
				await ArticleRepository.save( new Article(
					topic_id: widget.article.topic_id,
					title: _title_controller.text,
					content: _editor_controller.document.toJson(),
				) );
			}
			else {
				await ArticleRepository.update( new Article(
					id: widget.article.id,
					topic_id: widget.article.topic_id,
					title: _title_controller.text,
					content: _editor_controller.document.toJson(),
				) );
			}
			await indicator.dismiss();
			Navigator.of(context).pop();
		} catch ( error ) {
			if ( indicator.isShowing() ) await indicator.dismiss();
			FlushbarHelper.createError(message: S.of(context).error_occurred ).show(context);
		} finally {
			if ( indicator.isShowing() ) await indicator.dismiss();
		}
	}
	
	@override 
	void initState() {
		_title_controller = new TextEditingController();
		_editor_controller = new ZefyrController( widget.article.content == null ? new NotusDocument() : NotusDocument.fromJson( widget.article.content ) );
		if ( widget.article.title != null ) _title_controller.text = widget.article.title;
		_editor_focus_node = new FocusNode();
		super.initState();
	}
	
	@override
	void dispose() {
		_title_controller.dispose();
		_editor_controller.dispose();
		_editor_focus_node.dispose();
		super.dispose();
	}
}

class _ArticleImageDelegate extends ZefyrImageDelegate<ImageSource> {
	@override
	Widget buildImage(BuildContext context, String imageSource) => new CachedNetworkImage(
		imageUrl: imageSource,
	);
	@override
	Future<String> pickImage(ImageSource source) async {
		final file = await ImagePicker.pickImage(source: source);
		if (file == null) return null;
		
		final cropped_image = await ImageCropper.cropImage(
			sourcePath: file.path,
			ratioX: 1.0,
			ratioY: 1.0,
			maxWidth: 512,
			maxHeight: 512,
		);
		
		final ref = FirebaseStorage.instance.ref().child("article").child("${Uuid().v4()}.${"jpg"}");
		final upload_task = ref.putFile(cropped_image, new StorageMetadata(
			cacheControl: "public, max-age=31536000",
			contentType: lookupMimeType(cropped_image.path),
		));
		await upload_task.onComplete;
		return await ref.getDownloadURL();
	}
}