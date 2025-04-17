class LeaderboardUserModel {
  final String name;
  final double distance;
  final double duration;
  final int rank;
  final String imageUrl;
  final bool? isIncreasingRank;

  LeaderboardUserModel({
    required this.name,
    required this.distance,
    required this.duration,
    required this.rank,
    required this.imageUrl,
    this.isIncreasingRank,
  });

  factory LeaderboardUserModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardUserModel(
      name: json['name'] as String,
      distance: json['distance'],
      duration: json['duration'],
      rank: json['rank'],
      imageUrl: json['imageUrl'] as String,
      isIncreasingRank: json['isIncreasingRank'] as bool,
    );
  }
}
