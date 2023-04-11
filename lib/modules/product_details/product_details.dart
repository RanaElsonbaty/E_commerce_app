import 'package:ecommerce_app/layout/layout_cubit/layout_cubit.dart';
import 'package:ecommerce_app/layout/layout_cubit/layout_states.dart';
import 'package:ecommerce_app/shared/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/product_model.dart';

class ProductDetails extends StatelessWidget {
  final ProductModel model;
  const ProductDetails({Key? key,required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener:(context,state){},
      builder:(context,state){
        return Scaffold(
          appBar: AppBar(
            leading: BackButton(
              onPressed: ()
              {
                cubit.productNum = 1;
                Navigator.pop(context);
              },
            ),
            title: const Text("Product Details"),elevation: 0,foregroundColor:Colors.black,backgroundColor: thirdColor,),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:
              [
                Image.network(model.image.toString(),height: 200,width: double.infinity,),
                const SizedBox(height: 20,),
                Text(model.name.toString(),style: const TextStyle(color: mainColor,fontSize: 17,overflow: TextOverflow.ellipsis),),
                const SizedBox(height: 10,),
                Text("${model.price} \$",style: const TextStyle(color: secondColor),),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [
                    MaterialButton(
                      onPressed: ()
                      {
                        cubit.decrement();
                      },
                      textColor: Colors.white,
                      color: mainColor,
                      child: const Text("-",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                    ),
                    const SizedBox(width: 15,),
                    Text(cubit.productNum.toString(),style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                    const SizedBox(width: 15,),
                    MaterialButton(
                      onPressed: ()
                      {
                        cubit.increment();
                      },
                      textColor: Colors.white,
                      color: mainColor,
                      child: const Text("+",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                const Text("Description",style: TextStyle(color: mainColor,fontSize: 17,overflow: TextOverflow.ellipsis),),
                const SizedBox(height: 10,),
                Expanded(
                  child: Text("${model.description} \$",style: const TextStyle(color: Colors.grey),),
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:
                  [
                    MaterialButton(
                      onPressed: ()
                      {
                        cubit.addOrRemoveFromCart(productID: model.id!);
                      },
                      textColor: Colors.white,
                      color: mainColor,
                      child: Text(
                          cubit.cartsID.contains(model.id.toString()) ?
                          "Remove from Cart" : "Add to Cart"
                      ),
                    ),
                    const SizedBox(width: 15,),
                    OutlinedButton(
                        onPressed: ()
                        {
                          cubit.addOrRemoveToOrFromFavorites(productID: model.id!);
                        },
                        child: Icon(
                          Icons.favorite,
                          color: cubit.favoritesStatus.contains(model.id) ? Colors.red : Colors.grey,
                        )
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}