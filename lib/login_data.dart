class LoggedUser {
  int id;
  String name;
  String mail;
  String type;
  List<Map<String, dynamic>> forms = [];

  LoggedUser (int _id, String _name, String _mail, String _type) {
    this.id = _id;
    this.name = _name;
    this.mail = _mail;
    this.type = _type;
  }
}

LoggedUser loggedUser;