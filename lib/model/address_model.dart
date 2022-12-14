class AddressModel {
  String postalCode;
  String street;
  String neighborhood;
  String city;
  String state;

  AddressModel(
      {required this.postalCode,
      required this.street,
      required this.neighborhood,
      required this.city,
      required this.state});

  String address() {
    return "$street, $neighborhood - $city/$state";
  }

  factory AddressModel.fromJson(Map<String, dynamic> data) {
    return AddressModel(
      postalCode: data['cep'],
      street: data['logradouro'],
      neighborhood: data['bairro'],
      city: data['localidade'],
      state: data['uf'],
    );
  }
}
