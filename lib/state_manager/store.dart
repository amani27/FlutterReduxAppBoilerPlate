import 'package:redux/redux.dart';
import 'package:scrapabill/state_manager/b_redux.dart';

///  store initialization  ///
final store = Store<AppState>(
  reducer,
  initialState: AppState(
    userInfoState: {},
  ),
);
