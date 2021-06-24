import 'package:scrapabill/state_manager/b_redux.dart';

AppState reducer(AppState state, dynamic action) {
  /// your updating list where you store by applying logic ///
  if (action is UserInfoAction) {
    return state.copywith(userInfoState: action.userInfoAction);
  }
  
  return state;
}
