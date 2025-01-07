

// class AuthenticationService extends ServicesHelper {
//   String get apiURL => '$baseURL/users/';

//   Future<Map<String, dynamic>?> createUser({
//     required String email,
//     required String name,
//     required String password,
//   }) async {
//     final Map<String, dynamic> data = {
//       "email": email,
//       "name": name,
//       "password": password,
//     };

//     final response = await request(
//       apiURL,
//       body: data,
//       serviceType: ServiceType.post,
//       requiredDefaultHeader: false,
//     );

//     return response;
//   }

//   Future<Map<String, dynamic>?> login(Map<String, dynamic> input) async {
//     print('Requesting login with data: $input');

//     final response = await request(
//       '$baseURL/login',
//       serviceType: ServiceType.post,
//       body: input,
//       requiredDefaultHeader: false,
//       contentType: 'application/x-www-form-urlencoded',
//     );

//     print('Response: $response');
//     return response;
//   }
// }
