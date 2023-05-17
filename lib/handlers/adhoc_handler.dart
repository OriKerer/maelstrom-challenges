import 'handler_base.dart';

class AdHocHandler<REQUEST extends MessageBody, RESPONSE extends MessageBody>
    extends HandlerBase<REQUEST, RESPONSE> {
  final Future<RESPONSE> Function(RequestContext p1, REQUEST p2) _handle;

  final REQUEST Function(Map<String, dynamic> p1) Function() _fromJson;

  AdHocHandler(this._handle, this._fromJson);
  @override
  Future<RESPONSE> handle(RequestContext context, REQUEST message) async =>
      await _handle(context, message);

  @override
  REQUEST Function(Map<String, dynamic>) get fromJson => _fromJson();
}
