//
//  PermissionLocationWhenInUsePlugin.mm
//  Unity-iPhone
//https://github.com/react-native-community/react-native-permissions.git
//  Created by blitz on 2020/4/21.
//

#import <CoreLocation/CoreLocation.h>

@interface PNativeLocationWhenInUse:NSObject
+ (int)checkPermission;
+ (int)requestPermission;
//+ (int)canOpenSettings;
//+ (void)openSettings;
@end

@implementation PNativeLocationWhenInUse
+ (int)checkPermission {
    
    if (![CLLocationManager locationServicesEnabled]) {
        return 3;//服务没有开启
    }
    switch ([CLLocationManager authorizationStatus]) {
      case kCLAuthorizationStatusNotDetermined://未决定
        return 2;
      case kCLAuthorizationStatusRestricted://受限制
        return 3;
      case kCLAuthorizationStatusAuthorizedWhenInUse://在利用的时候可以
      case kCLAuthorizationStatusDenied://拒绝
        return 3;
      case kCLAuthorizationStatusAuthorizedAlways://总是可以
        return 1;
    }
    return 1;
}
+ (int)requestPermission {
    
    if (![CLLocationManager locationServicesEnabled]) {
        return 3;
    }
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusNotDetermined) {
        return 3;
    }
    //唯一的一点申请的权限不一样
    [[CLLocationManager new] requestWhenInUseAuthorization];
    
    return 1; //最终的同意或者不同意我不需要 真正需要了再写吧TODO
}
@end

extern "C" int _PNativeLocationWhenInUse_CheckPermission() {
    return [PNativeLocationWhenInUse checkPermission];
}

extern "C" int _PNativeLocationWhenInUse_RequestPermission() {
    return [PNativeLocationWhenInUse requestPermission];
}

