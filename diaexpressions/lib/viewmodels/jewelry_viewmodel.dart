import 'package:flutter/material.dart';
import '../models/jewelry_model.dart';
import '../models/jewelry_filter_model.dart';
import '../services/jewelry_service.dart';

class JewelryViewModel extends ChangeNotifier {
  final JewelryService _service = JewelryService();

  bool _isLoadingFilters = false;
  bool _isLoadingJewelry = false;
  bool _isLoadingMore = false;
  String? _error;

  JewelryFilterData? _filterData;
  List<JewelryItem> _jewelryList = [];

  List<String> _selectedCategories = [];
  List<String> _selectedMetals = [];
  List<String> _selectedShapes = [];
  List<String> _selectedStoneNames = [];
  double _minPrice = 0.0;
  double _maxPrice = 999999999999.0;
  String _currentSort = 'p_low';

  // Pagination
  int _offset = 0;
  final int _limit = 10;
  bool _hasMore = true;

  // Getters
  bool get isLoadingFilters => _isLoadingFilters;
  bool get isLoadingJewelry => _isLoadingJewelry;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  JewelryFilterData? get filterData => _filterData;
  List<JewelryItem> get jewelryList => _jewelryList;
  bool get hasMore => _hasMore;

  List<String> get selectedCategories => _selectedCategories;
  List<String> get selectedMetals => _selectedMetals;
  List<String> get selectedShapes => _selectedShapes;
  List<String> get selectedStoneNames => _selectedStoneNames;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;
  String get currentSort => _currentSort;

  List<JewelryItem> _newArrivals = [];
  bool _isLoadingArrivals = false;

  List<JewelryItem> get newArrivals => _newArrivals;
  bool get isLoadingArrivals => _isLoadingArrivals;

  JewelryViewModel() {
    _initData();
  }

  Future<void> _initData() async {
    await fetchFilters();
    await fetchJewelry(reset: true);
  }

  Future<void> fetchFilters() async {
    _isLoadingFilters = true;
    notifyListeners();

    try {
      _filterData = await _service.getFilters();
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingFilters = false;
      notifyListeners();
    }
  }

  Future<void> fetchNewArrivals() async {
    _isLoadingArrivals = true;
    _newArrivals = []; // Clear old list before loading
    notifyListeners();

    try {
      final response = await _service.getNewArrivals();

      // Double check that 'status' is true and 'records' is actually a List
      if (response != null && response['status'] == true) {
        final dynamic recordsData = response['records'];

        if (recordsData is List) {
          _newArrivals = recordsData
              .map((json) => JewelryItem.fromJson(json))
              .toList();
          debugPrint("Successfully loaded ${_newArrivals.length} arrivals");
        }
      }
    } catch (e) {
      debugPrint("New Arrival ViewModel Error: $e");
    } finally {
      _isLoadingArrivals = false;
      notifyListeners();
    }
  }

  Future<void> fetchJewelry({bool reset = false}) async {
    if (reset) {
      _offset = 0;
      _hasMore = true;
      _jewelryList.clear();
      _isLoadingJewelry = true;
      notifyListeners();
    } else {
      if (!_hasMore || _isLoadingMore) return;
      _isLoadingMore = true;
      notifyListeners();
    }

    try {
      final newItems = await _service.getJewelry(
        categoryName: _selectedCategories,
        metalType: _selectedMetals,
        stoneShape: _selectedShapes,
        stoneName: _selectedStoneNames,
        price: _minPrice == 0.0 && _maxPrice == 999999999999.0 ? null : "${_minPrice.toInt()}-${_maxPrice.toInt()}",
        sort: _currentSort,
        offset: _offset,
        limit: _limit,
      );

      if (newItems.length < _limit) {
        _hasMore = false;
      }

      _jewelryList.addAll(newItems);
      _offset += newItems.length;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoadingJewelry = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }



  void toggleCategory(String category) {
    if (_selectedCategories.contains(category)) {
      _selectedCategories.remove(category);
    } else {
      _selectedCategories.add(category);
    }
    notifyListeners();
  }

  void toggleMetal(String metal) {
    if (_selectedMetals.contains(metal)) {
      _selectedMetals.remove(metal);
    } else {
      _selectedMetals.add(metal);
    }
    notifyListeners();
  }

  void toggleShape(String shape) {
    if (_selectedShapes.contains(shape)) {
      _selectedShapes.remove(shape);
    } else {
      _selectedShapes.add(shape);
    }
    notifyListeners();
  }
  
  void setSort(String sort) {
    _currentSort = sort;
    fetchJewelry(reset: true);
  }

  void updatePriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    notifyListeners();
  }

  void applyFilters() {
    fetchJewelry(reset: true);
  }
  
  void clearFilters() {
    _selectedCategories.clear();
    _selectedMetals.clear();
    _selectedShapes.clear();
    _selectedStoneNames.clear();
    _minPrice = 0.0;
    _maxPrice = 999999999999.0;
    fetchJewelry(reset: true);
  }

  Future<Map<String, dynamic>> fetchJewelryDetail(String jewelryId) async {
    try {
      final response = await _service.getJewelryDetail(jewelryId);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch details: $e');
    }
  }

  Future<bool> addToCart(String jewelryId, {String? userId}) async {
    try {
      final response = await _service.addToCart(jewelryId, userId: userId);
      return response['status'] == 1 || response['code'] == 1;
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }
}
