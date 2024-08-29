import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PinjolListController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var pinjols = <Map<String, dynamic>>[].obs;
  var filteredPinjols = <Map<String, dynamic>>[].obs;
  var searchTerm = ''.obs;
  var isLoading = true.obs;
  var hasMore = true.obs;
  var documentLimit = 10;
  Rx<DocumentSnapshot?> lastDocument = Rx<DocumentSnapshot?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchPinjols();
    debounceSearch();
  }

  void fetchPinjols({bool isSearch = false}) async {
    try {
      isLoading.value = true;

      Query query = _firestore.collection('pinjols').limit(documentLimit);

      if (lastDocument.value != null && !isSearch) {
        query = query.startAfterDocument(lastDocument.value!);
      }

      var snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        lastDocument.value = snapshot.docs.last;

        var newPinjols = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

        if (isSearch) {
          pinjols.value = newPinjols; // Replace the current list with search results
        } else {
          pinjols.addAll(newPinjols); // Add new items to the existing list
        }

        filteredPinjols.value = _filterPinjols(pinjols); // Use filter function
        hasMore.value = snapshot.docs.length == documentLimit;
      } else {
        hasMore.value = false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch pinjols');
    } finally {
      isLoading.value = false;
    }
  }

  void debounceSearch() {
    debounce(searchTerm, (_) {
      fetchPinjols(isSearch: true);
    }, time: const Duration(milliseconds: 300));
  }

  void updateSearchTerm(String value) {
    searchTerm.value = value;
  }

  void loadMore() {
    if (!isLoading.value && hasMore.value) {
      fetchPinjols();
    }
  }

  List<Map<String, dynamic>> _filterPinjols(List<Map<String, dynamic>> pinjols) {
    final term = searchTerm.value.toLowerCase();
    return pinjols.where((pinjol) {
      final namaAplikasi = (pinjol['namaAplikasi'] ?? '').toLowerCase();
      return namaAplikasi.contains(term);
    }).toList();
  }
}
