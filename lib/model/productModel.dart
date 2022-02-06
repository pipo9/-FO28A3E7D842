class ProductModel {
  String id;
  String name;
  String price;
  String category;
  String subcategory;
  String city;
  String description;
  String image;
  String createdAt;
  String bestproduct;
  String visible;
  String topsells;
  String status;
  String startDate;
  Map dates = {};
  List days = [];
  String discount;
  String quantity;
  bool isExpanded = false;

  ProductModel(Map<String, dynamic> data) {
    this.id = data['id'];
    this.name = data['name'];
    this.startDate = data['startDate'];
    this.price = data['price'].toString();
    this.category = data['category'] ?? "";
    this.subcategory = data['subcategory'] ?? "";
    this.city = data['city'] ?? "";
    this.description = data['description'] ?? "";
    this.image = data['image'] ??
        "https://lh3.googleusercontent.com/proxy/L9HZ5iSce6A0UW_TlLbY9izutqTsDihOiocsTzio2v3qzyE7d6-o-7UJMF0puW8B_1Ix7TZmh9hcrnfdAYp8gMJSZeSK-BbBT0HsVIRA-fNJ7HY_jhfFZDFEAxPHtt64";
    this.createdAt = data['createdAt'] ?? "";
    this.bestproduct = data['bestproduct'] ?? "";
    this.visible = data['visible'] ?? "";
    this.topsells = data['topsells'] ?? "";
    this.discount = data['discount'].toString() ?? "";
    this.quantity =
        data['quantity'] == null ? "1" : data['quantity'].toString();
    this.dates = data['dates'];
    this.days = data['days'];
    this.status = data['status'];
  }

  Map<String, dynamic> toMap() {
    return {
      "dates": dates,
      "name": name,
      "price": price,
      "image": image,
      "status": status,
      "quantity":quantity,
      "discount":discount,
      "days": days,
      "id":id,
      "category":category,
      "subcategory":subcategory,
      "city":city,
      "description":description,
      "bestproduct":bestproduct,
      "visible":visible,
      "topsells":topsells,
      "startDate":startDate
    };
  }
}
