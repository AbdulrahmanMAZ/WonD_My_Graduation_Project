class user {
  final String name;
  final bool isWorker;
  final String? profession;
  user({required this.name, required this.isWorker, this.profession});
}

class UserData {
  final String? uid;
  final String? name;
  final bool? isWorker;
  final String? profession;
  UserData({this.isWorker, this.name, this.uid, this.profession});
}
