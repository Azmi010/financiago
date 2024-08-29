class Question {
  String id;
  String pertanyaan;
  String jawaban;
  Map<String, String> opsiJawaban;
  String penjelasan;
  int point;

  Question({
    required this.id,
    required this.pertanyaan,
    required this.jawaban,
    required this.opsiJawaban,
    required this.penjelasan,
    required this.point,
  });

  factory Question.fromFirestore(Map<String, dynamic> data) {
    return Question(
      id: data['id'] ?? '',
      pertanyaan: data['pertanyaan'] ?? '',
      jawaban: data['jawaban'] ?? '',
      opsiJawaban: Map<String, String>.from(data['opsiJawaban'] ?? {}),
      penjelasan: data['penjelasan'] ?? '',
      point: data['point'] ?? 10,
    );
  }
}