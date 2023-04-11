class ProductModel
{
  String? id;
  dynamic price;
  dynamic oldPrice;
  dynamic discount;
  dynamic image;
  dynamic name;
  dynamic description;
  bool? inFavorite;
  bool? inCart;

  ProductModel.fromJson({required Map<String, dynamic> json})
  {
    id = json['id'].toString();
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    inFavorite = json['in_favorites'];
    inCart = json['in_cart'];
    description = json['description'];
  }

}