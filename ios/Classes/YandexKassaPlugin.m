#import "YandexKassaPlugin.h"
#if __has_include(<yandex_kassa/yandex_kassa-Swift.h>)
#import <yandex_kassa/yandex_kassa-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "yandex_kassa-Swift.h"
#endif

@implementation YandexKassaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftYandexKassaPlugin registerWithRegistrar:registrar];
}
@end
