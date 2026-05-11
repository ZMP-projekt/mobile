class Env {

  static const apiUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api-j6d6.onrender.com',
  );
}
