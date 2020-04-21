//
//  PermissionCameraPlugin.mm
//  Unity-iPhone
//https://github.com/react-native-community/react-native-permissions.git
//  Created by blitz on 2020/4/21.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface PNativeCamera:NSObject
+ (int)checkPermission;
+ (int)requestPermission;
//+ (int)canOpenSettings;
//+ (void)openSettings;
@end

@implementation PNativeCamera
// Credit: https://stackoverflow.com/a/20464727/2373034
+ (int)checkPermission {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusAuthorized)
            return 1;
        else if (status == AVAuthorizationStatusNotDetermined )
            return 2;
        else
            return 3;
    }
    
    return 1;
}

// Credit: https://stackoverflow.com/a/20464727/2373034
+ (int)requestPermission {
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
    {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusAuthorized)
            return 1;
        
        if (status == AVAuthorizationStatusNotDetermined) {
            __block BOOL authorized = NO;
            
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                authorized = granted;
                dispatch_semaphore_signal(sema);
            }];
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            if (authorized)
                return 1;
            else
                return 3;
        }
            
        return 3;
    }
    
    return 1;
}
@end

extern "C" int _PNativeCamera_CheckPermission() {
    return [PNativeCamera checkPermission];
}

extern "C" int _PNativeCamera_RequestPermission() {
    return [PNativeCamera requestPermission];
}
