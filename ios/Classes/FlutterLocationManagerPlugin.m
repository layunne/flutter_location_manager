#import "FlutterLocationManagerPlugin.h"
#import <flutter_location_manager/flutter_location_manager-Swift.h>

@implementation FlutterLocationManagerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterLocationManagerPlugin registerWithRegistrar:registrar];
}
@end
