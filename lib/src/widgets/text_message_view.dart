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
import 'package:flutter/material.dart';

import '../../chatview.dart';
import '../utils/constants/constants.dart';
import 'link_preview.dart';
import 'reaction_widget.dart';

class TextMessageView extends StatelessWidget {
  const TextMessageView({
    Key? key,
    required this.isMessageBySender,
    required this.message,
    required this.hasReplyMessage,
    this.chatBubbleMaxWidth,
    this.inComingChatBubbleConfig,
    this.outgoingChatBubbleConfig,
    this.messageReactionConfig,
    this.highlightMessage = false,
    this.highlightColor,
  }) : super(key: key);

  final bool hasReplyMessage;

  /// Represents current message is sent by current user.
  final bool isMessageBySender;

  /// Provides message instance of chat.
  final Message message;

  /// Allow users to give max width of chat bubble.
  final double? chatBubbleMaxWidth;

  /// Provides configuration of chat bubble appearance from other user of chat.
  final ChatBubble? inComingChatBubbleConfig;

  /// Provides configuration of chat bubble appearance from current user of chat.
  final ChatBubble? outgoingChatBubbleConfig;

  /// Provides configuration of reaction appearance in chat bubble.
  final MessageReactionConfiguration? messageReactionConfig;

  /// Represents message should highlight.
  final bool highlightMessage;

  /// Allow user to set color of highlighted message.
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textMessage = message.message;
    final double leftPadding = hasReplyMessage ? 0 : 8;
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      clipBehavior: Clip.none,
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: chatBubbleMaxWidth ?? MediaQuery.of(context).size.width * 0.75),
          child: textMessage.isUrl
              ? Container(
                  margin: _margin ?? EdgeInsets.fromLTRB(6, 0, 0, message.reaction.reactions.isNotEmpty ? 20 : 2),
                  decoration: BoxDecoration(
                    color: highlightMessage ? highlightColor : _color,
                    borderRadius: _borderRadius(textMessage),
                  ),
                  // padding: const EdgeInsets.all(3),
                  width: MediaQuery.of(context).size.width / 2,
                  child: LinkPreview(
                    linkPreviewConfig: _linkPreviewConfig,
                    url: textMessage,
                  ),
                )
              : Container(
                  padding: _padding ??
                      (textMessage.isUrl
                          ? EdgeInsets.fromLTRB(leftPadding, 5, isMessageBySender ? leftPadding + 25 : 5, 5)
                          : EdgeInsets.fromLTRB(leftPadding, 8, isMessageBySender ? leftPadding + 25 : 8, 8)),
                  margin: _margin ?? EdgeInsets.fromLTRB(6, 0, 0, message.reaction.reactions.isNotEmpty ? 20 : 2),
                  decoration: BoxDecoration(
                    color: highlightMessage ? highlightColor : _color,
                    borderRadius: _borderRadius(textMessage),
                  ),
                  child: Text(
                    textMessage,
                    style: _textStyle ??
                        textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                  ),
                ),
        ),
        if (message.reaction.reactions.isNotEmpty)
          ReactionWidget(
            key: key,
            isMessageBySender: isMessageBySender,
            reaction: message.reaction,
            messageReactionConfig: messageReactionConfig,
          ),
      ],
    );
  }

  EdgeInsetsGeometry? get _padding =>
      isMessageBySender ? outgoingChatBubbleConfig?.padding : inComingChatBubbleConfig?.padding;

  EdgeInsetsGeometry? get _margin =>
      isMessageBySender ? outgoingChatBubbleConfig?.margin : inComingChatBubbleConfig?.margin;

  LinkPreviewConfiguration? get _linkPreviewConfig =>
      isMessageBySender ? outgoingChatBubbleConfig?.linkPreviewConfig : inComingChatBubbleConfig?.linkPreviewConfig;

  TextStyle? get _textStyle =>
      isMessageBySender ? outgoingChatBubbleConfig?.textStyle : inComingChatBubbleConfig?.textStyle;

  BorderRadiusGeometry _borderRadius(String message) => isMessageBySender
      ? outgoingChatBubbleConfig?.borderRadius ?? BorderRadius.circular(replyBorderRadius1)
      : inComingChatBubbleConfig?.borderRadius ?? BorderRadius.circular(replyBorderRadius1);

  Color get _color => isMessageBySender
      ? outgoingChatBubbleConfig?.color ?? Colors.purple
      : inComingChatBubbleConfig?.color ?? Colors.grey.shade500;
}
