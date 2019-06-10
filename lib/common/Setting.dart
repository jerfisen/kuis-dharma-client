import 'dart:async';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';
class Setting {
	SharedPreferences _preferences;
	bool _is_init = false;
	Future<Setting> init() async {
		_preferences = await SharedPreferences.getInstance();
		_is_init = true;
		return this;
	}
	
	void setLocale( final Locale locale ) {
		StringBuffer buffer = new StringBuffer();
		if ( locale.countryCode != null ) {
			buffer.write(locale.languageCode);
			buffer.write("|");
			buffer.write( locale.languageCode );
		}
		else buffer.write(locale.languageCode);
		_preferences.setString("locale", buffer.toString());
	}
	Locale getLocale() {
		final raw_locale = _preferences.getString("locale") ?? "id|ID";
		final components = raw_locale.split("|");
		if ( components.length == 2 ) return new Locale(components[0], components[1]);
		else return new Locale(components[0]);
	}
	
	bool get isInit => _is_init;
}