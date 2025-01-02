part of 'add_remove_wish_bloc.dart';

abstract class AddRemoveWishState extends Equatable {
  final String id;
  const AddRemoveWishState({required this.id});

  @override
  List<Object> get props => [id];
}

class AddRemoveWishInitialState extends AddRemoveWishState {
  const AddRemoveWishInitialState({super.id = ""});
}

class AddRemoveWishLoadingState extends AddRemoveWishState {
  const AddRemoveWishLoadingState({required super.id});
}

class WishAddedState extends AddRemoveWishState {
  const WishAddedState({required super.id});
}

class BookmarkRemoveState extends AddRemoveWishState {
  const BookmarkRemoveState({required super.id});
}

class AddRemoveWishErrorState extends AddRemoveWishState {
  final String errorMessage;
  final bool isLocalizationKey;
  const AddRemoveWishErrorState(
    this.errorMessage,
    this.isLocalizationKey, {
    required super.id,
  });

  @override
  List<Object> get props => [errorMessage, isLocalizationKey, id];
}
