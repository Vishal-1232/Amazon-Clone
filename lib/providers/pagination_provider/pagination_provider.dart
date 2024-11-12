import 'package:flutter/material.dart';

class PaginationProvider<T> with ChangeNotifier {
  final Future<List<T>> Function(int page) fetchItems; // API fetch function
  List<T> _items = [];
  int _page = 1;
  bool _isLoading = false;
  bool _hasMore = true;

  PaginationProvider({required this.fetchItems});

  List<T> get items => _items;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> loadMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    notifyListeners();

    List<T> newItems = await fetchItems(_page);
    if (newItems.isEmpty) {
      _hasMore = false;
    } else {
      _items.addAll(newItems);
      _page++;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    _items = [];
    _page = 1;
    _hasMore = true;
    await loadMore();
  }
}
