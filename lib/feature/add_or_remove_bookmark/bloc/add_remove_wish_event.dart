part of 'add_remove_wish_bloc.dart';

abstract class AddRemoveWishEvent extends Equatable {
  const AddRemoveWishEvent();

  @override
  List<Object> get props => [];
}

class ToggleWishEvent extends AddRemoveWishEvent {
  final bool isAddedToBookmarks;
  final String id;
  const ToggleWishEvent({
    required this.id,
    required this.isAddedToBookmarks,
  });

  @override
  List<Object> get props => [id, isAddedToBookmarks];
}
