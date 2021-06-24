///  state where you want to store ///
class AppState {
  var userInfoState;

  AppState({
    this.userInfoState,
  });

  AppState copywith({
    userInfoState,
  }) {
    return AppState(
      userInfoState: userInfoState ?? this.userInfoState,
    );
  }
}
