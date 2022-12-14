abstract class Constants {
  static String env="prod";
  static const String baseUrlDev = "https://linkdance-691ad-default-rtdb.firebaseio.com";
  static const String baseUrlProd = "https://linkdance-691ad-default-rtdb.firebaseio.com";
  static const String firebaseApiKeyDev = "AIzaSyDeh0P4Qc2rm4hDOQmhK7COUkQZazSM3pg";
  static const String firebaseApiKeyProd = "AIzaSyBYjavKCwFGGfspj_ThSugG6C8MXZm9-x0";

  static String get firebaseApiKey =>env=="dev"?firebaseApiKeyDev : firebaseApiKeyProd;

  static String get baseUrl =>env=="dev"?baseUrlDev : baseUrlProd;

  static String  authUrl(String operation)  => "https://identitytoolkit.googleapis.com/v1/accounts:$operation?key=$firebaseApiKey" ;
  static  String refreshToken = "https://securetoken.googleapis.com/v1/token?key=$firebaseApiKey";
  static  String  teacherUri(String auth)  => "$baseUrl/teacher?auth=$auth" ;
  static  String get teacherDbUrl  => "$baseUrl/teacher" ;
  static  String get eventDbUrl  => "$baseUrl/event" ;
  static String get moviesDbUrl  => "$baseUrl/movie" ;
  static String get userDbUrl  => "$baseUrl/user" ;
  static String  youtubeThumbnailUri(String youtubeId)=> "https://img.youtube.com/vi/$youtubeId/0.jpg";
  static String get searchPostalCodeUrl  => "https://buscacepinter.correios.com.br/app/endereco/index.php" ;
  static String  findPostalCodeUri(String postalCode)  => "https://viacep.com.br/ws/$postalCode/json/" ;

  static String userAuthData="userAuthData";
  static String userTeacherData="userTeacherData";
  static const int pageSize=15;
  static const String defaultAvatar= "assets/images/default_profile.jpg";

  static const String defaultBackgroud= "assets/images/backgroud2.jpg";

}

class ConstantsLayout {


}

/**
 * Frases para usar:
 *
 * Dançar é escrever um poema que se faz com o corpo e se lê com a alma.
 * Meu coração nao bate, ele samba...
 *
 * A dança nao tem duplo sentido, ela so em um sentido: se sentir bem.
 *
 * Para mim a dança é como a vida. Você não escolhe, ela simplesmente acontece.
 *
 *A dança nasce da alma, não dos pés.
 *
 * Enquanto a dança trouxer alegria às nossas vidas a tristeza terá de aguardar sua vez.
 *
 *É com o corpo que se dançamas é com a alma que se sente a música.
 *
 *Dançar é sonhar com os pés.
 *
 *Quando meu corpo dança, minha mente balança entre o belo e o maravilhoso.
 *
 *A dança é a linguagem escondida da alma.
 *
 *Dança: uma forma de expressar tudo o que você está sentindo sem precisar dizer nenhuma palavra. +++++++
 *
 *Dançar é deixar a alma livre para que escreva poesia com o corpo.
 *
 *Com a dança todo mau humor vai embora, por isso não poderia ser mais feliz do que dançando pelo mundo a fora.
 *
 *
 * Muitas das vezes a vida é como uma dança, você só precisa pegar o ritmo.
 *
 * A dança é a expressão perpendicular de um desejo horizontal.
 *
 *E se você ficar sozinho, pega a solidão e dança!
 *
 * E são nos meus piores dias que eu faço a minha melhor dança.
 *
 *Sua dança não mente o que seu coração sente.

 *Amar, sorrir e dançar: as melhores coisas do mundo são gratuitas.
 *
 *Minha felicidade não tem preço, tem ritmo. ++++++++
 *
 *A dança é a linguagem secreta da alma.
 *
 *A dança é a mãe de todas as linguagens.
 *
 *Dançar é como crescer. Um processo lento, cheio de surpresas e lutas.
 *
 *Dançar é como sonhar com os pés.
 *
 *Não danço para esquecer a vida, mas para lembrar que ela existe.
 *
 *Nunca se ri ou se dança o suficiente.
 */
