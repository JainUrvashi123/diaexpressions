import 'package:flutter/material.dart';
import '../models/pdf_model.dart';
import '../services/pdf_service.dart';

class PdfViewModel extends ChangeNotifier {
  final PdfService _pdfService = PdfService();

  List<PdfModel> _pdfs = [];
  List<PdfModel> get pdfs => _pdfs;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchPdfs({bool force = false}) async {
    if (!force && _pdfs.isNotEmpty && _error == null) {
      return; // Already loaded successfully
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _pdfs = await _pdfService.getPdfList();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  PdfModel? getPdfByFileNameKeyword(String keyword) {
    if (_pdfs.isEmpty) return null;
    try {
      return _pdfs.firstWhere(
        (pdf) => pdf.fileName.toLowerCase().contains(keyword.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }

  PdfModel? getPdfByNameKeyword(String keyword) {
    if (_pdfs.isEmpty) return null;
    try {
      return _pdfs.firstWhere(
        (pdf) => pdf.name.toLowerCase().contains(keyword.toLowerCase()),
      );
    } catch (_) {
      return null;
    }
  }
}
