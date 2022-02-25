class user {
  final String name;
  final bool isWorker;

  user({required this.name, required this.isWorker});
}

class UserData {
  final String? uid;
  final String? name;
  final bool? isWorker;
  UserData({this.isWorker, this.name, this.uid});
}
