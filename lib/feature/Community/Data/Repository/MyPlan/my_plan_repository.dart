import 'dart:async';

import 'package:vivas/feature/Community/Data/Repository/PayRepository/pay_repository.dart';
import 'package:vivas/feature/Community/presentations/ViewModel/MyPlan/my_plan_bloc.dart';

abstract class MyPlanRepository  extends PayRepository<MyPlanState>{
  Future<MyPlanState> getMyPlan();

}
