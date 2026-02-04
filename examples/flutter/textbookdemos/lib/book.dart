class BookModel {
  final VolumeInfo volumeInfo;
  final AccessInfo accessInfo;
  final SaleInfo saleInfo;

  BookModel(
      {required this.volumeInfo,
      required this.accessInfo,
      required this.saleInfo});

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
        volumeInfo: VolumeInfo.fromJson(json['volumeInfo']),
        accessInfo: AccessInfo.fromJson(json['accessInfo']),
        saleInfo: SaleInfo.fromJson(json['saleInfo']));
  }
}

class VolumeInfo {
  final String title;
  final String subtitle;
  final String description;
  final List<dynamic>? authors;
  final String publisher;
  final String publishedDate;
  final ImageLinks imageLinks;

  VolumeInfo(
      {required this.title,
      required this.subtitle,
      required this.description,
      this.authors,
      required this.publisher,
      required this.publishedDate,
      required this.imageLinks});

  factory VolumeInfo.fromJson(Map<String, dynamic> json) {
    return VolumeInfo(
        title: json['title'],
        subtitle: json['subtitle'],
        description: json['description'],
        authors: json['authors'] as List,
        publisher: json['publisher'],
        publishedDate: json['publishedDate'],
        imageLinks: ImageLinks.fromJson(json['imageLinks']));
  }
}

class ImageLinks {
  final String smallThumbnail;
  final String? thumbnail;

  ImageLinks({required this.smallThumbnail, this.thumbnail});

  factory ImageLinks.fromJson(Map<String, dynamic>? json) {
    return ImageLinks(
        smallThumbnail: json != null ? json['smallThumbnail'] : '',
        thumbnail: json != null ? json['thumbnail'] : '');
  }
}

class AccessInfo {
  String webReaderLink;

  AccessInfo({required this.webReaderLink});

  factory AccessInfo.fromJson(Map<String, dynamic> json) {
    return AccessInfo(webReaderLink: json['webReaderLink']);
  }
}

class SaleInfo {
  final String saleability;
  final String buyLink;

  SaleInfo({required this.saleability, required this.buyLink});

  factory SaleInfo.fromJson(Map<String, dynamic> json) {
    return SaleInfo(saleability: json['saleability'], buyLink: json['buyLink']);
  }
}
