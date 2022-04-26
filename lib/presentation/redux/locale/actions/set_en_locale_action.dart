import 'package:async_redux/async_redux.dart';
import 'package:device_apps/core/di/locator.dart';
import 'package:device_apps/data/datasources/local/shared_prefs.dart';
import 'package:device_apps/l10n/app_locale.dart';
import 'package:device_apps/presentation/redux/app_state.dart';

class SetEnLocaleAction extends ReduxAction<AppState> {
  @override
  Future<AppState> reduce() async {
    await locator<SharedPrefs>().setLocale(AppLocale.en);
    return state.copyWith(appLocale: AppLocale.en);
  }
}
