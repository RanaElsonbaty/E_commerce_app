abstract class LayoutStates{}

class LayoutInitialState extends LayoutStates{}

class ChangeBottomNavigationIndexState extends LayoutStates{}

class ChangePasswordSuccessState extends LayoutStates{}
class ChangePasswordLoadingState extends LayoutStates{}
class FailedToChangePasswordState extends LayoutStates{}

class UpdateUserDataSuccessState extends LayoutStates{}
class UpdateUserDataLoadingState extends LayoutStates{}
class FailedToUpdateUserDataState extends LayoutStates{}

class GetUserDataSuccessState extends LayoutStates{}
class GetUserDataLoadingState extends LayoutStates{}
class FailedToGetUserDataState extends LayoutStates{
  String message;
  FailedToGetUserDataState(this.message);
}

class GetBannersSuccessState extends LayoutStates{}
class GetBannersLoadingState extends LayoutStates{}
class FailedToGetBannersState extends LayoutStates{}

class GetFavoritesSuccessState extends LayoutStates{}
class GetFavoritesLoadingState extends LayoutStates{}
class FailedToGetFavoritesState extends LayoutStates{}

class GetCartSuccessState extends LayoutStates{}
class GetCartLoadingState extends LayoutStates{}
class FailedToGetCartState extends LayoutStates{}

class AddOrRemoveFromCartSuccessState extends LayoutStates{}
class UpdateProductNumSuccessState extends LayoutStates{}
class FailedToAddOrRemoveFromCartState extends LayoutStates{}

class AddOrRemoveFromFavoritesSuccessState extends LayoutStates{}
class FailedToAddOrRemoveFromFavoritesState extends LayoutStates{}
class FilterProductsSuccessState extends LayoutStates{}

class GetCategoriesSuccessState extends LayoutStates{}
class GetCategoriesLoadingState extends LayoutStates{}
class FailedToGetCategoriesState extends LayoutStates{}

class GetProductsSuccessState extends LayoutStates{}
class GetProductsLoadingState extends LayoutStates{}
class FailedToGetProductsState extends LayoutStates{}