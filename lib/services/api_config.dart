class ApiConfig {
  static Uri baseUrl = Uri.parse('http://localhost:3000/api');
  static Uri usersEndpoint = Uri.parse('${baseUrl.toString()}/users');
  static Uri createUserEndpoint = Uri.parse(
    '${baseUrl.toString()}/create_user',
  );
}
