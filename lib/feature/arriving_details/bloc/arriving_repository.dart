import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/feature/arriving_details/Models/arriving_details_request_model.dart';
import 'package:vivas/feature/arriving_details/bloc/arriving_details_bloc.dart';

abstract class BaseArrivingRepository {
  Future<ArrivingDetailsState> sendArrivingDetails(
    ArrivingDetailsRequestModel arrivingDetailsRequestModel,
  );
}

class ArrivingRepository implements BaseArrivingRepository {
  ApartmentRequestsApiManger apartmentRequestsApiManger;

  ArrivingRepository({required this.apartmentRequestsApiManger});

  @override
  Future<ArrivingDetailsState> sendArrivingDetails(
    ArrivingDetailsRequestModel arrivingDetailsRequestModel,
  ) async {
    late ArrivingDetailsState arrivingDetailsState;
    await apartmentRequestsApiManger
        .sendArrivingDetails(arrivingDetailsRequestModel, () {
      arrivingDetailsState = SendingArrivingDetailsSuccess();
    }, (p0) {
      arrivingDetailsState = SendingArrivingDetailsException();
    });
    return arrivingDetailsState;
  }
}
