import 'handler_base.dart';

class AdHocHandler<REQUEST extends MessageBody, RESPONSE extends MessageBody>
    extends HandlerBase<REQUEST, RESPONSE> {
  final Future<RESPONSE?> Function(RequestContext p1, REQUEST p2) _handle;

  AdHocHandler(this._handle);
  @override
  Future<RESPONSE?> handle(RequestContext context, REQUEST message) async =>
      await _handle(context, message);
}
