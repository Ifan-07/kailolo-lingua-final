class Word {
  final String ind;
  final String kai;
  final List<String> pron;
  final List<String> kaiSyns;
  final List<String> indSyns;
  final List<String> sents;

  Word({
    required this.ind,
    required this.kai,
    required this.pron,
    required this.kaiSyns,
    required this.indSyns,
    required this.sents,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      ind: json['ind'] ?? '',
      kai: json['kai'] ?? '',
      pron: (json['pron'] != null && json['pron'] is List)
          ? List<String>.from(json['pron'].map((item) => item.toString()))
          : [],
      kaiSyns: (json['kai_syns'] != null && json['kai_syns'] is List)
          ? List<String>.from(json['kai_syns']!)
          : [],
      indSyns: (json['ind_syns'] != null && json['ind_syns'] is List)
          ? List<String>.from(json['ind_syns']!)
          : [],
      sents: (json['sents'] != null && json['sents'] is List)
          ? List<String>.from(json['sents']!)
          : [],
    );
  }
}
