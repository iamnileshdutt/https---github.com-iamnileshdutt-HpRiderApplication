import '/backend/api_requests/api_calls.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'acceptorder_widget.dart' show AcceptorderWidget;
import 'package:map_launcher/map_launcher.dart' as $ml;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AcceptorderModel extends FlutterFlowModel<AcceptorderWidget> {
  ///  Local state fields for this page.

  bool accepted = true;

  bool deliveryStarted = true;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getLatLngFromCoordinates] action in Text widget.
  LatLng? locationbussiness1;
  // Stores action output result for [Custom Action - getLatLngFromPostalCode] action in Text widget.
  LatLng? locationcustomer1;
  // Stores action output result for [Backend Call - API (UpdateOrderStatus)] action in Button widget.
  ApiCallResponse? updateorderstatus;
  // Stores action output result for [Backend Call - API (RemoveRider)] action in Button widget.
  ApiCallResponse? apiremove;
  // Stores action output result for [Backend Call - API (SetOrderCompleteStatus)] action in Button widget.
  ApiCallResponse? setOrderCompleteStatusResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
