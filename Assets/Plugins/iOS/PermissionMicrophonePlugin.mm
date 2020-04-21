//
//  PermissionMicrophonePlugin.mm
//  Unity-iPhone
//https://github.com/react-native-community/react-native-permissions.git
//  Created by blitz on 2020/4/21.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PNativemMicrophone:NSObject
+ (int)checkPermission;
+ (int)requestPermission;
//+ (int)canOpenSettings;
//+ (void)openSettings;
@end

@implementation PNativemMicrophone
+ (int)checkPermission {
    switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio]) {
      case AVAuthorizationStatusNotDetermined: //未决定
        return 2;
      case AVAuthorizationStatusRestricted: //受限制
        return 3;
      case AVAuthorizationStatusDenied://拒绝
        return 3;
      case AVAuthorizationStatusAuthorized: //同意
        return 1;
    }
    return 1;
}
+ (int)requestPermission {
    __block BOOL authorized = NO;
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio
                             completionHandler:^(__unused BOOL granted) {
        authorized = granted;
    }];
    if (authorized)
        return 1; //允许
    else
        return 3;//拒绝
}
@end

extern "C" int _PNativeMicrophone_CheckPermission() {
    return [PNativemMicrophone checkPermission];
}

extern "C" int _PNativeMicrophone_RequestPermission() {
    return [PNativemMicrophone requestPermission];
}
