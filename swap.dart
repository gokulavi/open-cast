import 'dart:io';

void main() {
  final file = File('lib/features/stream/presentation/screens/stream_studio_screen.dart');
  String content = file.readAsStringSync();
  content = content.replaceAll('\r\n', '\n');

  // 1. Update callers
  content = content.replaceAll(
    '_buildStudioPreviewColumn(context, ref, session, scenes)',
    '_buildStudioPreviewColumn(context, ref, session, scenes, messages)',
  );
  content = content.replaceAll(
    '_buildChatAndAlertsColumn(ref, messages)',
    '_buildChatAndAlertsColumn(context, ref)',
  );

  // 2. Extract Broadcast Controls block
  final broadcastStartToken = '        // Control mixers and volume bar row';
  final broadcastEndToken = '      ],\n    );\n  }\n\n';
  
  final broadcastStart = content.indexOf(broadcastStartToken);
  final broadcastEnd = content.indexOf(broadcastEndToken, broadcastStart);
  if (broadcastStart == -1 || broadcastEnd == -1) {
    print('Failed to find Broadcast Controls block');
    return;
  }
  final broadcastControlsStr = content.substring(broadcastStart, broadcastEnd);

  // 3. Extract Studio Live Chat block
  final chatStartToken = '        Row(\n          mainAxisAlignment: MainAxisAlignment.spaceBetween,\n          children: [\n            Text(\n              \'STUDIO LIVE CHAT\',';
  final chatEndToken = '      ],\n    );\n  }\n}';
  
  final chatStart = content.indexOf(chatStartToken);
  final chatEnd = content.indexOf(chatEndToken, chatStart);
  if (chatStart == -1 || chatEnd == -1) {
    print('Failed to find Studio Live Chat block');
    return;
  }
  final liveChatStr = content.substring(chatStart, chatEnd);

  // 4. Swap!
  content = content.replaceRange(chatStart, chatEnd, broadcastControlsStr);
  content = content.replaceRange(broadcastStart, broadcastEnd, liveChatStr);

  // 5. Move submitChat logic to _buildStudioPreviewColumn
  final submitChatStartToken = '    final textController = TextEditingController();';
  final submitChatEndToken = '    return Column(';
  final submitStart = content.indexOf(submitChatStartToken);
  final submitEnd = content.indexOf(submitChatEndToken, submitStart);
  if (submitStart == -1 || submitEnd == -1) {
    print('Failed to find submitChat logic');
    return;
  }
  final submitChatStr = content.substring(submitStart, submitEnd);
  
  // Remove submitChat from _buildChatAndAlertsColumn
  content = content.replaceRange(submitStart, submitEnd, '');

  // Add submitChat logic to _buildStudioPreviewColumn
  final insertPoint = content.indexOf('    return Column(\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      children: [\n        Text(\n          \'PROGRAM MONITOR\',');
  if (insertPoint == -1) {
    print('Failed to find insert point');
    return;
  }
  content = content.replaceRange(insertPoint, insertPoint, submitChatStr);

  // 6. Update signatures
  content = content.replaceAll(
    'Widget _buildStudioPreviewColumn(BuildContext context, WidgetRef ref, StreamSession session, List<SceneModel> scenes) {',
    'Widget _buildStudioPreviewColumn(BuildContext context, WidgetRef ref, StreamSession session, List<SceneModel> scenes, List<ChatMessage> messages) {',
  );
  content = content.replaceAll(
    'Widget _buildChatAndAlertsColumn(WidgetRef ref, List<ChatMessage> messages) {',
    'Widget _buildChatAndAlertsColumn(BuildContext context, WidgetRef ref) {',
  );

  file.writeAsStringSync(content);
  print('Successfully swapped sections!');
}
