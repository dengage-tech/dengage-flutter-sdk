#import "DengageFlutterPlugin.h"
#if __has_include(<dengage_flutter/dengage_flutter-Swift.h>)
#import <dengage_flutter/dengage_flutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "dengage_flutter-Swift.h"
#endif

@implementation DengageFlutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftDengageFlutterPlugin registerWithRegistrar:registrar];
}
@end
