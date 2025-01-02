class MetaModel {
  final int currentPage;
  final int pageSize;
  final int totalPages;
  final int totalRecords;

  MetaModel(
      this.currentPage, this.pageSize, this.totalPages, this.totalRecords);

  MetaModel.fromJson(Map<String, dynamic> json)
      : currentPage = json['pageNumber'] as int,
        pageSize = json['pageSize'] as int,
        totalPages = json['totalPages'] as int,
        totalRecords = json['totalRecords'] as int;

  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'totalPages': totalPages,
        'totalRecords': totalRecords
      };

  static MetaModel getEmptyOne() {
    return MetaModel(0, 0, 0, 0);
  }

  static MetaModel demo() {
    return MetaModel(1, 10, 1, 10);
  }
}
