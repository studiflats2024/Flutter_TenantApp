import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:vivas/_core/widgets/base_stateful_screen_widget.dart';
import 'package:vivas/apis/_base/dio_api_manager.dart';
import 'package:vivas/apis/managers/apartment_requests_api_manger.dart';
import 'package:vivas/feature/bookings/bloc/bookings_bloc.dart';
import 'package:vivas/feature/bookings/bloc/bookings_repository.dart';
import 'package:vivas/feature/bookings/widget/active_booking_widget_v2.dart';
import 'package:vivas/feature/bookings/widget/active_bookings_widget.dart';
import 'package:vivas/feature/bookings/widget/expired_bookings_widget.dart';
import 'package:vivas/feature/bookings/widget/expired_bookings_widget_v2.dart';
import 'package:vivas/feature/bookings/widget/offers_bookings_widget.dart';
import 'package:vivas/feature/bookings/widget/offers_bookings_widget_v2.dart';
import 'package:vivas/feature/widgets/modal_sheet/app_bottom_sheet.dart';
import 'package:vivas/preferences/preferences_manager.dart';
import 'package:vivas/utils/empty/empty_widgets.dart';
import 'package:vivas/utils/locale/app_localization_keys.dart';

class BookingsScreen extends StatelessWidget {
  BookingsScreen({Key? key}) : super(key: key);

  final DioApiManager dioApiManager = GetIt.I<DioApiManager>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider<BookingsBloc>(
      create: (context) => BookingsBloc(BookingsRepository(
        preferencesManager: GetIt.I<PreferencesManager>(),
        apartmentRequestsApiManger: ApartmentRequestsApiManger(dioApiManager, context),
      )),
      child: const BookingsScreenWithBloc(),
    );
  }
}

class BookingsScreenWithBloc extends BaseStatefulScreenWidget {
  const BookingsScreenWithBloc({super.key});

  @override
  BaseScreenState<BookingsScreenWithBloc> baseScreenCreateState() {
    return _BookingsScreenWithBloc();
  }
}

class _BookingsScreenWithBloc extends BaseScreenState<BookingsScreenWithBloc>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _checkIsLoggedInEvent();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget baseScreenBuild(BuildContext context) {
    return BlocConsumer<BookingsBloc, BookingsState>(
      listener: (BuildContext context, BookingsState state) {
        if (state is IsGuestModeState) {
          AppBottomSheet.showLoginOrRegisterDialog(context);
        }
      },
      builder: (context, state) {
        if (state is IsGuestModeState) {
          return const EmptyWidget();
        } else if (state is IsLoggedInState) {
          return _bookingWidget();
        }
        return _bookingWidget();
      },
    );
  }

  Widget _bookingWidget() {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF1151B4),
          indicatorColor: const Color(0xFF1151B4),
          indicatorWeight: 3,
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          unselectedLabelColor: const Color(0xFF49454F),
          tabs: [
            Tab(child: Text(translate(LocalizationKeys.activeBookings)!)),
            Tab(child: Text(translate(LocalizationKeys.offersBookings)!)),
            Tab(
              child: Text(translate(LocalizationKeys.expiredBookings)!),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ActiveBookingsWidgetV2(),
          OffersBookingsWidgetV2(),
          ExpiredBookingsWidgetV2(),
        ],
      ),
    );
  }

  BookingsBloc get currentBloc => BlocProvider.of<BookingsBloc>(context);

  void _checkIsLoggedInEvent() {
    currentBloc.add(CheckIsLoggedInEvent());
  }
}
