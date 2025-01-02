part of 'complaints_bloc.dart';

sealed class ComplaintsEvent extends Equatable {
  const ComplaintsEvent();

  @override
  List<Object> get props => [];
}

class GetComplaintsApiEvent extends ComplaintsEvent {
  const GetComplaintsApiEvent();
  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetComplaintsTypeApiEvent extends ComplaintsEvent {
  @override
  List<Object> get props => [identityHashCode(this)];
}

class GetComplaintDetailsApiEvent extends ComplaintsEvent {
  final String ticketId;

  const GetComplaintDetailsApiEvent(this.ticketId);
  @override
  List<Object> get props => [identityHashCode(this)];
}

class CreateTicketApiEvent extends ComplaintsEvent {
  final CreateTicketSendModel createTicketSendModel;

  const CreateTicketApiEvent(this.createTicketSendModel);
  @override
  List<Object> get props => [createTicketSendModel];
}

class ReplyComplaintApiEvent extends ComplaintsEvent {
  final ReplyComplaintSendModel replyComplaintSendModel;

  const ReplyComplaintApiEvent(this.replyComplaintSendModel);
  @override
  List<Object> get props => [replyComplaintSendModel];
}

class ValidateFormEvent extends ComplaintsEvent {
  final GlobalKey<FormState> formKey;
  const ValidateFormEvent(this.formKey);
  @override
  List<Object> get props => [identityHashCode(this)];
}
