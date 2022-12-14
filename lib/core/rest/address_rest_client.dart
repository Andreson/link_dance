import 'package:link_dance/core/constants.dart';
import 'package:link_dance/core/rest/rest_template.dart';
import 'package:link_dance/features/authentication/auth_facate.dart';
import 'package:link_dance/model/address_model.dart';

class AddressRestClient {
  final RestTemplate _restTemplate = RestTemplate(auth: AuthenticationFacate());

  Future<AddressModel?>? findAddressByPostalCode(String postalCode) async {
    return await _restTemplate.Get(url:  Constants.findPostalCodeUri(postalCode))
        .then((data) {
      return AddressModel.fromJson(data);
    });
  }
}
