sealed class ProfileState {
  const ProfileState();
}

final class ProfileStateInit extends ProfileState {
  const ProfileStateInit();
}

final class ProfileStateLoading extends ProfileState {
  const ProfileStateLoading();
}

final class ProfileStateSuccess extends ProfileState {
  const ProfileStateSuccess();
}

final class ProfileStateFailure extends ProfileState {
  const ProfileStateFailure({required this.message});
  final String message;
}
