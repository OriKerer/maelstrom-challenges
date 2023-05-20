import 'handler_base.dart';

class GenerateHandler extends HandlerBase<MessageBody, MessageBodyGenerateOk> {
  int runningId = 0;

  @override
  Future<MessageBodyGenerateOk> handle(
      RequestContext context, MessageBody message) async {
    return MessageBodyGenerateOk(generatedId: context.uuid.generate());
  }
}
