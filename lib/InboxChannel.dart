/// Event types accepted by the Inbox Channel events endpoint.
enum InboxChannelEventType { impression, open, click, delete }

extension InboxChannelEventTypeCode on InboxChannelEventType {
  /// Short code sent to the server: IM, OP, CL or DT.
  String get code {
    switch (this) {
      case InboxChannelEventType.impression:
        return 'IM';
      case InboxChannelEventType.open:
        return 'OP';
      case InboxChannelEventType.click:
        return 'CL';
      case InboxChannelEventType.delete:
        return 'DT';
    }
  }
}

/// A CTA button of an Inbox Channel message.
class InboxChannelCtaButton {
  final String? buttonId;
  final String? label;
  final String? iosDeeplink;
  final String? androidDeeplink;
  final String? webUrl;

  const InboxChannelCtaButton({
    this.buttonId,
    this.label,
    this.iosDeeplink,
    this.androidDeeplink,
    this.webUrl,
  });

  factory InboxChannelCtaButton.fromMap(Map<dynamic, dynamic> map) {
    return InboxChannelCtaButton(
      buttonId: map['buttonId'] as String?,
      label: map['label'] as String?,
      iosDeeplink: map['iosDeeplink'] as String?,
      androidDeeplink: map['androidDeeplink'] as String?,
      webUrl: map['webUrl'] as String?,
    );
  }
}

/// Content payload of an Inbox Channel message.
class InboxChannelMessageData {
  final String? title;
  final String? message;
  final String? imageUrl;
  final List<InboxChannelCtaButton> ctaButtons;
  final bool isPinned;
  final String? receiveDate;

  /// Opaque token, echo it back in every [InboxChannelEvent] of this message.
  final String? messageDetails;

  const InboxChannelMessageData({
    this.title,
    this.message,
    this.imageUrl,
    this.ctaButtons = const [],
    this.isPinned = false,
    this.receiveDate,
    this.messageDetails,
  });

  factory InboxChannelMessageData.fromMap(Map<dynamic, dynamic> map) {
    final cta = map['ctaButtons'];
    return InboxChannelMessageData(
      title: map['title'] as String?,
      message: map['message'] as String?,
      imageUrl: map['imageUrl'] as String?,
      ctaButtons: cta is List
          ? cta
              .whereType<Map>()
              .map((e) => InboxChannelCtaButton.fromMap(e))
              .toList()
          : const [],
      isPinned: map['isPinned'] == true,
      receiveDate: map['receiveDate'] as String?,
      messageDetails: map['messageDetails'] as String?,
    );
  }
}

/// A single Inbox Channel message.
class InboxChannelMessage {
  final String id;
  final bool isRead;
  final int priority;
  final bool isDeleted;
  final InboxChannelMessageData data;

  const InboxChannelMessage({
    required this.id,
    required this.isRead,
    required this.priority,
    required this.isDeleted,
    required this.data,
  });

  factory InboxChannelMessage.fromMap(Map<dynamic, dynamic> map) {
    final data = map['data'];
    return InboxChannelMessage(
      id: map['id'] as String,
      isRead: map['isRead'] == true,
      priority: (map['priority'] as num?)?.toInt() ?? 0,
      isDeleted: map['isDeleted'] == true,
      data: data is Map
          ? InboxChannelMessageData.fromMap(data)
          : const InboxChannelMessageData(),
    );
  }

  InboxChannelMessage copyWith({bool? isRead}) {
    return InboxChannelMessage(
      id: id,
      isRead: isRead ?? this.isRead,
      priority: priority,
      isDeleted: isDeleted,
      data: data,
    );
  }

  /// Builds the event of [type] for this message.
  InboxChannelEvent toEvent(InboxChannelEventType type) {
    return InboxChannelEvent(
      eventType: type,
      messageId: id,
      messageDetails: data.messageDetails,
    );
  }
}

/// A single Inbox Channel interaction to report.
class InboxChannelEvent {
  final InboxChannelEventType eventType;
  final String messageId;
  final String? messageDetails;

  const InboxChannelEvent({
    required this.eventType,
    required this.messageId,
    this.messageDetails,
  });

  Map<String, dynamic> toMap() => {
        'eventType': eventType.code,
        'messageId': messageId,
        'messageDetails': messageDetails,
      };
}
