class Subscription {
  String? advertisingId;
  String? appVersion;
  String? carrierId;
  String? contactKey;
  String? country;
  String? udid;
  String? integrationKey;
  String? language;
  bool? permission;
  String? sdkVersion;
  String? testGroup;
  String? timezone;
  String? token;
  String? tokenType;
  bool? trackingPermission;

  Subscription({
    this.advertisingId,
    this.appVersion,
    this.carrierId,
    this.contactKey,
    this.country,
    this.udid,
    this.integrationKey,
    this.language,
    this.permission,
    this.sdkVersion,
    this.testGroup,
    this.timezone,
    this.token,
    this.tokenType,
    this.trackingPermission,
  });

  @override
  String toString() {
    return 'Subscription(advertisingId: $advertisingId, appVersion: $appVersion, carrierId: $carrierId, contactKey: $contactKey, country: $country, udid: $udid, integrationKey: $integrationKey, language: $language, permission: $permission, sdkVersion: $sdkVersion, testGroup: $testGroup, timezone: $timezone, token: $token, tokenType: $tokenType, trackingPermission: $trackingPermission)';
  }

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
        advertisingId: json['advertisingId'] as String?,
        appVersion: json['appVersion'] as String?,
        carrierId: json['carrierId'] as String?,
        contactKey: json['contactKey'] as String?,
        country: json['country'] as String?,
        udid: json['udid'] as String?,
        integrationKey: json['integrationKey'] as String?,
        language: json['language'] as String?,
        permission: json['permission'] as bool?,
        sdkVersion: json['sdkVersion'] as String?,
        testGroup: json['testGroup'] as String?,
        timezone: json['timezone'] as String?,
        token: json['token'] as String?,
        tokenType: json['tokenType'] as String?,
        trackingPermission: json['trackingPermission'] as bool?,
      );

  Map<String, dynamic> toJson() => {
        'advertisingId': advertisingId,
        'appVersion': appVersion,
        'carrierId': carrierId,
        'contactKey': contactKey,
        'country': country,
        'udid': udid,
        'integrationKey': integrationKey,
        'language': language,
        'permission': permission,
        'sdkVersion': sdkVersion,
        'testGroup': testGroup,
        'timezone': timezone,
        'token': token,
        'tokenType': tokenType,
        'trackingPermission': trackingPermission,
      };
}
