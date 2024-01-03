// Login Exception
class UserNotFoundAuthException implements Exception {}

class WronPasswordAuthException implements Exception {}
// Register Exception

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// generic exception

class GenericAuthException implements Exception {}

class UserNotLoggedInException implements Exception {}
