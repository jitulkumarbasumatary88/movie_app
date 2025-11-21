class FavoriteModel {
  final int? id; // db autoincrement id (optional)
  final String tmdbid;
  final String tmdbtype;
  final String tmdbname;
  final String tmdbrating;
  final String tmdbposter;

  FavoriteModel({
    this.id,
    required this.tmdbid,
    required this.tmdbtype,
    required this.tmdbname,
    required this.tmdbrating,
    required this.tmdbposter,
  });

  Map<String, dynamic> toMap() => {
    if (id != null) 'id': id,
    'tmdbid': tmdbid,
    'tmdbtype': tmdbtype,
    'tmdbname': tmdbname,
    'tmdbrating': tmdbrating,
  };

  factory FavoriteModel.fromMap(Map<String, dynamic> m) => FavoriteModel(
    id: m['id'],
    tmdbid: m['tmdbid'].toString(),
    tmdbtype: m['tmdbtype'].toString(),
    tmdbname: m['tmdbname'].toString(),
    tmdbrating: m['tmdbrating'].toString(),
    tmdbposter: m['tmdbposter'],
  );
}
