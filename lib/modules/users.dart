class user {
  final String name;
  final bool isWorker;
  final String? profession;
  final double? latitude;
  final double? longitude;
  user(
      {required this.name,
      required this.isWorker,
      this.profession,
      this.latitude,
      this.longitude});
}

class UserData {
  final String? uid;
  final String? name;
  final bool? isWorker;
  final String? profession;
  final double? latitude;
  final double? longitude;
  UserData(
      {this.isWorker,
      this.name,
      this.uid,
      this.profession,
      this.latitude,
      this.longitude});
}
