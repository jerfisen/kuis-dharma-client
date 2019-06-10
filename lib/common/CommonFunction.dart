import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:kdygd/generated/i18n.dart';

Flushbar<void> createLoadingMessage( final BuildContext context, { final String message, final double overlay_blur = 0.0 } ) {
	return new Flushbar<void>(
		message: message ?? S.of(context).please_wait,
		flushbarPosition: FlushbarPosition.TOP,
		flushbarStyle: FlushbarStyle.FLOATING,
		reverseAnimationCurve: Curves.decelerate,
		forwardAnimationCurve: Curves.elasticOut,
		backgroundColor: Colors.red,
		boxShadows: [ BoxShadow(color: Colors.blue[800], offset: Offset(0.0, 2.0), blurRadius: 3.0) ],
		backgroundGradient: LinearGradient(colors: [Colors.blueGrey, Colors.black]),
		isDismissible: false,
		showProgressIndicator: true,
		progressIndicatorBackgroundColor: Colors.blueGrey,
		overlayBlur: overlay_blur,
	);
}