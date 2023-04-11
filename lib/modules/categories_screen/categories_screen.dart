import 'package:ecommerce_app/layout/layout_cubit/layout_cubit.dart';
import 'package:ecommerce_app/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<CategoryModel>categories=BlocProvider.of<LayoutCubit>(context).categoriesData;
    return  Scaffold(
      body: Padding(padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 12),
      child: GridView.builder(
        itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount:2,
              mainAxisSpacing: 20,
              crossAxisSpacing: 15),
          itemBuilder:(context,index){
          return Container(
            child: Column(
              children: [
                Expanded(
                    child: Image.network(categories[index].image!,fit: BoxFit.fill)),
                const SizedBox(height: 10,),
                Text(categories[index].title!)
              ],
            ),
          );
          }


      )

        ,)

    );
  }
}