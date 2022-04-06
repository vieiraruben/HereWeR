// Login exceptions
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

// Signup exceptions

class WeakPasswordAuthException implements Exception {}

class EmailAlreadyInUseAuthException implements Exception {}

class InvalidEmailAuthException implements Exception {}

// Generic exceptions

class GenericAuthException implements Exception {
}

class UserNotLoggedInAuthException implements Exception {}

class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateDocumentException extends CloudStorageException {}

class CouldNotGetDocumentException extends CloudStorageException {}

class CouldNotUpdateDocumentException extends CloudStorageException {}

class CouldNotDeleteDocumentException extends CloudStorageException {}
