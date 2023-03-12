class InvalidFormException implements Exception{
  String cause;
  InvalidFormException(this.cause);

  @override
  String toString() {
    return 'NotImplementedException{cause: $cause}';
  }
}

//Exception para erros que nao impedem o fluxo de criação de um recurso que pode ser criado posteriormente
//ex: link dinamico para listas
class NoCriticalException implements Exception{
  String cause;
  NoCriticalException(this.cause);

  @override
  String toString() {
    return 'NotImplementedException{cause: $cause}';
  }
}


class PersistenceFirebaseException implements Exception{
  String cause;
  PersistenceFirebaseException(this.cause);

  @override
  String toString() {
    return 'Erro ao persistir dados no firebase {cause: $cause}';
  }
}

