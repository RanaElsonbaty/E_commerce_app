import 'package:ecommerce_app/layout/layout_cubit/layout_cubit.dart';
import 'package:ecommerce_app/layout/layout_cubit/layout_states.dart';
import 'package:ecommerce_app/models/product_model.dart';
import 'package:ecommerce_app/modules/product_details/product_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/category_model.dart';
import '../../../shared/style/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(title: const Text("Fashion store"),elevation:0,backgroundColor: thirdColor,foregroundColor: mainColor,),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12.5),
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children:
              [
                TextFormField(
                  onChanged: (input)
                  {
                    cubit.filterProducts(input: input);
                  },
                  decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(Icons.search),
                      border: const OutlineInputBorder(),
                      suffixIcon: GestureDetector(
                        onTap: (){},
                        child: const Icon(Icons.clear),
                      )
                  ),
                ),
                const SizedBox(height: 18,),
                cubit.bannersData.isEmpty ?
                _loadingWidget() :
                SizedBox(
                    height: 120,
                    width: double.infinity,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cubit.bannersData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index){
                          return _bannerItem(url: cubit.bannersData[index].image!);
                        }
                    )
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                    const Text("Categories",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: mainColor),),
                    InkWell(
                      onTap: (){},
                      child: const Text("View All",style: TextStyle(color: secondColor,fontSize: 14,fontWeight: FontWeight.w500),),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                cubit.categoriesData.isEmpty ?
                _loadingWidget() :
                SizedBox(
                    height: 70,
                    width: double.infinity,
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: cubit.categoriesData.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context,index)
                        {
                          return _categoryItem(categoryModel: cubit.categoriesData[index]);
                        }
                    )
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                  [
                    const Text("Products",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: mainColor),),
                    InkWell(
                      onTap: (){},
                      child: const Text("View All",style: TextStyle(color: secondColor,fontSize: 14,fontWeight: FontWeight.w500),),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                cubit.productsData.isEmpty ?
                _loadingWidget() :
                GridView.builder(
                    itemCount: cubit.productsFiltered.isEmpty ?
                    cubit.productsData.length :
                    cubit.productsFiltered.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisSpacing:12,
                        mainAxisSpacing:10,
                        crossAxisCount: 2,
                        childAspectRatio: 0.8
                    ),
                    itemBuilder: (context,index){
                      return GestureDetector(
                        onTap : ()
                        {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ProductDetails(model: cubit.productsData[index]);
                          }));
                        },
                        child: _productItem(
                            cubit: cubit,
                            productModel: cubit.productsFiltered.isEmpty ?
                            cubit.productsData[index] :
                            cubit.productsFiltered[index]
                        ),
                      );
                    }
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // This widget will be shown during during there is no Data
  Widget _loadingWidget(){
    return const Center(child: CupertinoActivityIndicator());
  }

  // Banner Widget
  Widget _bannerItem({required String url}){
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4)
      ),
      margin: const EdgeInsets.only(right: 15),
      child: Image.network(url,fit: BoxFit.fill,width: 220,),
    );
  }

  // Category Widget
  Widget _categoryItem({required CategoryModel categoryModel}){
    return Container(
      margin: const EdgeInsets.only(right: 15),
      child: InkWell(
        onTap: ()
        {
          // Here Will open Categories Screen
        },
        child: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(categoryModel.image!),
        ),
      ),
    );
  }

  // Product Widget
  Widget _productItem({required LayoutCubit cubit,required ProductModel productModel}){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12,horizontal: 12),
        color: Colors.grey.withOpacity(0.2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
          [
            Expanded(child: Image.network(productModel.image,fit: BoxFit.fill,width: double.infinity,height: double.infinity,)),
            const SizedBox(height: 12,),
            Text(productModel.name,style: const TextStyle(fontWeight:FontWeight.bold,overflow: TextOverflow.ellipsis),),
            const SizedBox(height: 4,),
            Row(
              mainAxisSize: MainAxisSize.min,
              children:
              [
                Expanded(
                  child: Row(
                    children:
                    [
                      FittedBox(fit:BoxFit.scaleDown,child: Text("${productModel.price} \$",style: const TextStyle(fontSize: 13),)),
                      const SizedBox(width: 5,),
                      if( productModel.oldPrice != 0 && productModel.oldPrice != productModel.price)
                        FittedBox(fit: BoxFit.scaleDown,child:Text("${productModel.oldPrice} \$",style: const TextStyle(fontSize:12,color: Colors.grey,decoration: TextDecoration.lineThrough)))
                    ],
                  ),
                ),
                GestureDetector(
                    onTap:()
                    {
                      cubit.addOrRemoveToOrFromFavorites(productID: productModel.id!);
                    },
                    child: Icon(
                        Icons.favorite,
                        size: 20,
                        color: cubit.favoritesStatus.contains(productModel.id!) ? Colors.red : Colors.grey
                    )
                )
              ],
            ),
          ],
        )
    );
  }

}