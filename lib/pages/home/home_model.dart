import '/backend/api_requests/api_calls.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:map_launcher/map_launcher.dart' as $ml;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  Local state fields for this page.

  List<dynamic> order = [];
  void addToOrder(dynamic item) => order.add(item);
  void removeFromOrder(dynamic item) => order.remove(item);
  void removeAtIndexFromOrder(int index) => order.removeAt(index);
  void insertAtIndexInOrder(int index, dynamic item) =>
      order.insert(index, item);
  void updateOrderAtIndex(int index, Function(dynamic) updateFn) =>
      order[index] = updateFn(order[index]);

  int? index = 0;

  bool load = true;

  ///  State fields for stateful widgets in this page.

  InstantTimer? instantTimer;
  // Stores action output result for [Backend Call - API (Active Order)] action in home widget.
  ApiCallResponse? activeOrdersList;
  // State field(s) for Switch widget.
  bool? switchValue;
  // Stores action output result for [Backend Call - API (DutyOnOff )] action in Switch widget.
  ApiCallResponse? dutyonoff;
  // Stores action output result for [Backend Call - API (DutyOnOff )] action in Switch widget.
  ApiCallResponse? dutyonoffCopy;
  // Stores action output result for [Custom Action - getLatLngFromCoordinates] action in Text widget.
  LatLng? locationbussiness;
  // Stores action output result for [Backend Call - API (DeclineRequest)] action in Button widget.
  ApiCallResponse? declinerequest;
  // Stores action output result for [Backend Call - API (UpdateOrderStatus)] action in Button widget.
  ApiCallResponse? updateorderstatus;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
