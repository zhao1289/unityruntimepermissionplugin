//
//  PermissionPhotoLibraryPlugin.mm
//  Unity-iPhone
//https://github.com/react-native-community/react-native-permissions.git
//  Created by blitz on 2020/4/21.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
#import <AssetsLibrary/AssetsLibrary.h>
#endif

@interface PNativePhotoLibrary:NSObject
+ (int)checkPermission;
+ (int)requestPermission;
//+ (int)canOpenSettings;
//+ (void)openSettings;
@end

@implementation PNativePhotoLibrary
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (int)checkPermission {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
    {
#endif
        // version >= iOS 8: check permission using Photos framework
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusAuthorized)
            return 1;
        else if (status == PHAuthorizationStatusNotDetermined )
            return 2;
        else
            return 3;
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    }
    else
    {
        // version < iOS 8: check permission using AssetsLibrary framework (Photos framework not available)
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusAuthorized)
            return 1;
        else if (status == ALAuthorizationStatusNotDetermined)
            return 2;
        else
            return 3;
    }
#endif
}
#pragma clang diagnostic pop

+ (int)requestPermission {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    if ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
    {
#endif
        // version >= iOS 8: request permission using Photos framework
        return [self requestPermissionNew];
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    }
    else
    {
        // version < iOS 8: request permission using AssetsLibrary framework (Photos framework not available)
        return [self requestPermissionOld];
    }
#endif
}

// Credit: https://stackoverflow.com/a/32989022/2373034
+ (int)requestPermissionNew {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    
    if (status == PHAuthorizationStatusAuthorized) {
        return 1;
    }
    else if (status == PHAuthorizationStatusNotDetermined) {
        __block BOOL authorized = NO;
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            authorized = (status == PHAuthorizationStatusAuthorized);
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        if (authorized)
            return 1;
        else
            return 3;
    }
    else {
        return 3;
    }
}

// Credit: https://stackoverflow.com/a/26933380/2373034
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
+ (int)requestPermissionOld {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    
    if (status == ALAuthorizationStatusAuthorized) {
        return 1;
    }
    else if (status == ALAuthorizationStatusNotDetermined) {
        __block BOOL authorized = NO;
        ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        [lib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            *stop = YES;
            authorized = YES;
            dispatch_semaphore_signal(sema);
        } failureBlock:^(NSError *error) {
            dispatch_semaphore_signal(sema);
        }];
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        if (authorized)
            return 1;
        else
            return 3;
    }
    else {
        return 3;
    }
#endif
    
    return 3;
}
#pragma clang diagnostic pop

@end

extern "C" int _PNativePhotoLibrary_CheckPermission() {
    return [PNativePhotoLibrary checkPermission];
}

extern "C" int _PNativePhotoLibrary_RequestPermission() {
    return [PNativePhotoLibrary requestPermission];
}
