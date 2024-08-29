// lib/models/financial_data_model.dart
class FinancialData {
  final double pendapatan;
  final double pengeluaran;
  final double rasioTabungan;
  final double rasioDarurat;
  final double rasioLiburan;
  final double rasioPendidikan;
  final int usia;
  final String profesi;

  FinancialData({
    required this.pendapatan,
    required this.pengeluaran,
    required this.rasioTabungan,
    required this.rasioDarurat,
    required this.rasioLiburan,
    required this.rasioPendidikan,
    required this.usia,
    required this.profesi,
  });

  Map<String, dynamic> toJson() {
    return {
      "pendapatan": pendapatan,
      "pengeluaran": pengeluaran,
      "rasio_tabungan": rasioTabungan,
      "rasio_darurat": rasioDarurat,
      "rasio_liburan": rasioLiburan,
      "rasio_pendidikan": rasioPendidikan,
      "usia": usia,
      "profesi": profesi,
    };
  }
}
