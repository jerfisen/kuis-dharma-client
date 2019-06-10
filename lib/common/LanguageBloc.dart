import 'dart:ui';

import 'package:kdygd/common/Setting.dart';
import 'package:rxdart/rxdart.dart';

class Language {
	static final Language _language = Language._internal();
	static Language get instance => _language;
	
	Language._internal() {
		new Future.delayed(Duration.zero, _loadLocale);
	}
	void _loadLocale() async {
		Setting setting = new Setting();
		await setting.init();
		_locale_subject.add(setting.getLocale());
	}
	final _locale_subject = new BehaviorSubject<Locale>.seeded(new Locale('id', 'id'));
	Observable<Locale> get locale_stream => _locale_subject.stream;
	set locale( final Locale locale ) => _locale_subject.add(locale);
	dispose() => _locale_subject.close();
}