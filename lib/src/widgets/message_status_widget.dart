/*
 * Copyright (c) 2022 Simform Solutions
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/utils/measure_size.dart';
import 'package:flutter/material.dart';

import '../../chatview.dart';

class MessageStatusWidget extends StatefulWidget {
  const MessageStatusWidget({
    Key? key,
    this.messageReactionConfig,
    required this.isMessageBySender,
    required this.messageStatus,
    this.reaction,
  }) : super(key: key);

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Provides reaction instance of message.
  final Reaction? reaction;

  final MessageStatus messageStatus;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  @override
  State<MessageStatusWidget> createState() => _MessageStatusWidgetState();
}

class _MessageStatusWidgetState extends State<MessageStatusWidget> {
  bool needToExtend = false;

  MessageReactionConfiguration? get messageReactionConfig => widget.messageReactionConfig;
  final _reactionTextStyle = const TextStyle(fontSize: 13);
  ChatController? chatController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (provide != null) {
      chatController = provide!.chatController;
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isMessageBySender
        ? Positioned(
            bottom: widget.reaction != null && widget.reaction!.reactions.isNotEmpty ? 23 : 5,
            right: -7,
            child: InkWell(
              child: MeasureSize(
                onSizeChange: (extend) => setState(() => needToExtend = extend),
                child: Container(
                  padding: messageReactionConfig?.padding ?? const EdgeInsets.all(1),
                  margin: messageReactionConfig?.margin ??
                      const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                  decoration: BoxDecoration(
                    color: messageReactionConfig?.backgroundColor ?? Colors.grey.shade200,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: messageReactionConfig?.borderColor ?? Colors.white,
                      width: messageReactionConfig?.borderWidth ?? 1,
                    ),
                  ),
                  child: Icon(
                    size: 12,
                    widget.messageStatus == MessageStatus.read ? Icons.done_all_rounded : Icons.done,
                    color: widget.messageStatus == MessageStatus.read
                        ? (messageReactionConfig?.messageReceivedColor ?? Colors.green)
                        : (messageReactionConfig?.messagePendingColor ?? Colors.grey),
                  ),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}
