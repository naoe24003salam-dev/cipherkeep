/// Authentication states
sealed class AuthState {
  const AuthState();
}

/// User is not authenticated
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// User is authenticated and in real vault mode
class AuthAuthenticated extends AuthState {
  const AuthAuthenticated();
}

/// User is authenticated but in decoy mode
class AuthDecoy extends AuthState {
  const AuthDecoy();
}

/// Authentication is in progress
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Authentication result
class AuthResult {
  final bool success;
  final AuthState? state;
  final String? errorMessage;

  const AuthResult({
    required this.success,
    this.state,
    this.errorMessage,
  });

  const AuthResult.success(this.state)
      : success = true,
        errorMessage = null;

  const AuthResult.failure(String message)
      : success = false,
        state = null,
        errorMessage = message;
}
