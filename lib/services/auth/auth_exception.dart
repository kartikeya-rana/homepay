// Logins Exception
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Register Exceptions
class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailException implements Exception {}

// Generic Exceptions
class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
