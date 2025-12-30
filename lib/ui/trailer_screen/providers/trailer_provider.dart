import 'package:app_m0v4u/services/trailer_service.dart';
import 'package:app_m0v4u/ui/trailer_screen/models/trailer_model.dart';
import 'package:flutter/foundation.dart';

class TrailerProvider with ChangeNotifier {
  final TrailerService _service = TrailerService();

  List<Trailer> _trailers = [];
  List<Trailer> get trailers => _trailers;

  String _category = 'popular';
  String get category => _category;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> loadTrailers(String category) async {
    _isLoading = true;
    notifyListeners();

    _category = category;
    _trailers = await _service.fetchTrailers(category);

    _isLoading = false;
    notifyListeners();
  }
}
