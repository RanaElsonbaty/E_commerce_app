import 'package:ecommerce_app/layout/layout_cubit/layout_cubit.dart';
import 'package:ecommerce_app/layout/layout_cubit/layout_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/style/colors.dart';
class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LayoutCubit cubit = BlocProvider.of<LayoutCubit>(context);
    return BlocConsumer<LayoutCubit,LayoutStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
            appBar: AppBar(title: const Text("Favorites"),elevation:0,backgroundColor: Colors.transparent,foregroundColor: mainColor,),
            body: cubit.favoritesData.isEmpty ?
            const Center(child: Text("Loading...."),) :
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.5,vertical: 10),
              child: ListView.builder(
                itemCount: cubit.favoritesData.length,
                itemBuilder: (context,index){
                  return _favoriteItem(
                    url: cubit.favoritesData[index].image,
                    title: cubit.favoritesData[index].name,
                    id: cubit.favoritesData[index].id!,
                    cubit: cubit,
                    price: cubit.favoritesData[index].price.toInt(),
                    oldPrice: cubit.favoritesData[index].oldPrice.toInt(),
                  );
                },
              ),
            )
        );
      },
    );
  }

  Widget _favoriteItem({required int price,required int oldPrice,required String url,required String title,required String id,required LayoutCubit cubit}){
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      color: thirdColor,
      child: Row(
        children:
        [
          Image.network(url,height: 100,width: 100,fit: BoxFit.fill,),
          const SizedBox(width: 20,),
          Expanded(
              child: Column(
                children:
                [
                  Text(title,style: const TextStyle(overflow: TextOverflow.ellipsis),),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children:
                    [
                      FittedBox(fit:BoxFit.scaleDown,child: Text("$price \$",style: const TextStyle(fontSize: 13),)),
                      const SizedBox(width: 5,),
                      if( oldPrice != 0 && oldPrice != price)
                        FittedBox(fit: BoxFit.scaleDown,child:Text("$oldPrice \$",style: const TextStyle(fontSize:12,color: Colors.grey,decoration: TextDecoration.lineThrough)))
                    ],
                  ),
                  MaterialButton(
                    color: mainColor,
                    height: 30,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2.5)
                    ),
                    textColor: Colors.white,
                    onPressed: ()
                    {
                      cubit.addOrRemoveToOrFromFavorites(productID: id);
                    },
                    child: const Text("Remove"),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}