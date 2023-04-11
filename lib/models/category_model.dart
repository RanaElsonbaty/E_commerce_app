class CategoryModel{
  int? id;
  String? title;
  String? image;

  CategoryModel.fromJson({required Map<String,dynamic> data}){
    id = data['id'];
    image = data['image'];
    title = data['name'];
  }
}