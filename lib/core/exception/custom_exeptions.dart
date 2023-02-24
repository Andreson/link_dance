class InvalidFormException implements Exception{
  String cause;
  InvalidFormException(this.cause);

  @override
  String toString() {
    return 'NotImplementedException{cause: $cause}';
  }
}
