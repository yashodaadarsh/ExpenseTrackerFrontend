class SignupReqParams {
  final String username;
  final String password;
  final String firstname;
  final String lastname;
  final String phonenumber;
  final String email;

  SignupReqParams( { required this.username, required this.password, required this.firstname, required this.lastname,
    required this.phonenumber, required this.email } );

  Map<String, dynamic> toJson() {
    return <String,dynamic> {
      "username": username,
      "password": password,
      "first_name": firstname,
      "last_name": lastname,
      "phone_number": phonenumber,
      "email": email,
    };
  }

}

