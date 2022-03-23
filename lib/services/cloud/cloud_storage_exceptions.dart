class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotCreateHouseException extends CloudStorageException {}

class CouldNotGetAllHousesException extends CloudStorageException {}

class CouldNotUpdateHouseException extends CloudStorageException {}

class CouldNotDeleteHouseException extends CloudStorageException {}

class CouldNotCreateOwnerException extends CloudStorageException {}

class CouldNotGetOwnerException extends CloudStorageException {}

class CouldNotUpdateOwnerException extends CloudStorageException {}

class CouldNotDeleteOwnerException extends CloudStorageException {}

class CouldNotCreateRewardException extends CloudStorageException {}

class CouldNotUpdateRewardException extends CloudStorageException {}
