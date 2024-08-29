class AnalysisModel {
  final String analysis;
  final List<String> prediction;
  final List<List<double>> probabilities;
  final String recommendation;

  AnalysisModel({
    required this.analysis,
    required this.prediction,
    required this.probabilities,
    required this.recommendation,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      analysis: json['analysis'],
      prediction: List<String>.from(json['prediction']),
      probabilities: List<List<double>>.from(
        json['probabilities'].map(
          (prob) => List<double>.from(prob),
        ),
      ),
      recommendation: json['recommendation'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'analysis': analysis,
      'prediction': prediction,
      'probabilities': probabilities,
      'recommendation': recommendation,
    };
  }
}
