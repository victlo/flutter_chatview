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
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:chatview/src/extensions/extensions.dart';
import 'package:chatview/src/models/models.dart';
import 'package:flutter/material.dart';

import '../utils/constants/constants.dart';
import '../utils/package_strings.dart';
import 'chat_view_inherited_widget.dart';

class ReplyMessageWidget extends StatelessWidget {
  const ReplyMessageWidget({
    Key? key,
    required this.message,
    this.repliedMessageConfig,
    this.onTap,
  }) : super(key: key);

  /// Provides message instance of chat.
  final Message message;

  /// Provides configurations related to replied message such as textstyle
  /// padding, margin etc. Also, this widget is located upon chat bubble.
  final RepliedMessageConfiguration? repliedMessageConfig;

  /// Provides call back when user taps on replied message.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final currentUser = ChatViewInheritedWidget.of(context)?.currentUser;
    final replyBySender = message.replyMessage.replyTo == currentUser?.id;
    final textTheme = Theme.of(context).textTheme;
    final replyMessage = message.replyMessage.message;
    final chatController = ChatViewInheritedWidget.of(context)?.chatController;
    final messagedUser = chatController?.getUserFromId(message.replyMessage.replyTo);
    final replyBy = replyBySender ? PackageStrings.you : messagedUser?.name;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 4,
          top: 4,
          right: 4,
        ),
        child: Container(
          padding: EdgeInsets.only(left: repliedMessageConfig?.verticalBarWidth ?? 4),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(10),
              bottom: Radius.circular(3),
            ), //
            color: repliedMessageConfig?.verticalBarColor ?? Colors.white,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: repliedMessageConfig?.backgroundColor,
              /*** The BorderRadius widget  is here ***/
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10),
                bottomRight: Radius.circular(3),
              ), //BorderRad
              // ius.all
            ), //BoxDeco
            padding: const EdgeInsets.all(5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "$replyBy",
                  style: repliedMessageConfig?.replyTitleTextStyle ??
                      textTheme.bodyMedium!.copyWith(fontSize: 14, letterSpacing: 0.3),
                ),
                const SizedBox(height: 3),
                Opacity(
                  opacity: repliedMessageConfig?.opacity ?? 0.8,
                  child: message.replyMessage.messageType.isImage
                      ? SizedBox(
                          height: repliedMessageConfig?.repliedImageMessageHeight ?? 50,
                          width: repliedMessageConfig?.repliedImageMessageWidth ?? 50,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: (() {
                                return Image.network(
                                  replyMessage,
                                  fit: BoxFit.fitHeight,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                );
                              }())),
                        )
                      : Container(
                          constraints: BoxConstraints(
                            maxWidth: repliedMessageConfig?.maxWidth ?? 280,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: _borderRadius(
                              replyMessage: replyMessage,
                              replyBySender: replyBySender,
                            ),
                            color: repliedMessageConfig?.backgroundColor ?? Colors.grey.shade500,
                          ),
                          child: message.replyMessage.messageType.isVoice
                              ? Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.mic,
                                      color: repliedMessageConfig?.micIconColor ?? Colors.white,
                                    ),
                                    const SizedBox(width: 2),
                                    if (message.replyMessage.voiceMessageDuration != null)
                                      Text(
                                        message.replyMessage.voiceMessageDuration!.toHHMMSS(),
                                        style: repliedMessageConfig?.textStyle,
                                      ),
                                  ],
                                )
                              : Text(
                                  replyMessage,
                                  style: repliedMessageConfig?.textStyle ??
                                      textTheme.bodyMedium!.copyWith(color: Colors.black),
                                ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BorderRadiusGeometry _borderRadius({
    required String replyMessage,
    required bool replyBySender,
  }) =>
      replyBySender
          ? repliedMessageConfig?.borderRadius ??
              (replyMessage.length < 37
                  ? BorderRadius.circular(replyBorderRadius1)
                  : BorderRadius.circular(replyBorderRadius2))
          : repliedMessageConfig?.borderRadius ??
              (replyMessage.length < 29
                  ? BorderRadius.circular(replyBorderRadius1)
                  : BorderRadius.circular(replyBorderRadius2));
}
