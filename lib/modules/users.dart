class user {
  final String name;
  final bool isWorker;

  user({required this.name, required this.isWorker});
}

class UserData {
  final String? uid;
  final String? name;
  final bool? isWorker;
  final String? profession;
  UserData({this.isWorker, this.name, this.uid, this.profession});
}
