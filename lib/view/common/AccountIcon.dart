import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AccountIcon extends StatefulWidget {
	final double size;
	const AccountIcon({Key key, this.size = 35.0}) : super(key: key);
	@override State<StatefulWidget> createState() => _AccountIconState();
}

class _AccountIconState extends State<AccountIcon> {
	FirebaseUser _user;
	@override
	Widget build(BuildContext context) => _user != null && _user.photoUrl != null ? new Container(
		height: widget.size,
		width: widget.size,
		decoration: ShapeDecoration(
			shape: CircleBorder(side: BorderSide(width: 1.0, color: Colors.white)),
			image: DecorationImage(
				image: CachedNetworkImageProvider(
					_user.photoUrl,
				),
				fit: BoxFit.fill,
			)
		),
	) : const Icon(Icons.person);
	
	@override
	void initState() {
		super.initState();
		new Future.delayed(Duration.zero, _loadAccountIcon);
	}
	
	void _loadAccountIcon() async {
		final user = await FirebaseAuth.instance.currentUser();
		setState(() {
			_user = user;
		});
	}
}