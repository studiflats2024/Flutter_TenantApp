// ignore_for_file: unused_local_variable

import 'package:vivas/apis/managers/contract_api_manager.dart';

import 'credit_card_bloc.dart';

abstract class BaseCreditCardRepository {
  Future<CreditCardState> payByCreditOrDebitCard();
}

class CreditCardRepository implements BaseCreditCardRepository {
  final ContractApiManger contractApiManger;

  CreditCardRepository({required this.contractApiManger});

  @override
  Future<CreditCardState> payByCreditOrDebitCard() async {
    late CreditCardState creditCardState;

    return CreditCardPaidSuccessfullyState("");
  }
}
