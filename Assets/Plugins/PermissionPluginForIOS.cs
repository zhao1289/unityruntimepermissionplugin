//#if UNITY_IOS
using UnityEngine;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Runtime.InteropServices;

public enum PermissionType
{
    Camera=0,//相机
    PhotoLibrary,//相册
    Microphone,//麦克风
    LocationWhenInUse,//app启动时候的定位
    LocationAlways,//app总是定位的权限
}

public enum PermissionSelf { Granted = 1, ShouldAsk = 2, Denied = 3 };
/// <summary>
/// Permission plugin for iOS.
/// </summary>
public static class PermissionPluginForIOS 
{
    #if !UNITY_EDITOR && UNITY_IOS
    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativeCamera_CheckPermission();

    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativeCamera_RequestPermission();

    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativePhotoLibrary_CheckPermission();

    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativePhotoLibrary_RequestPermission();

    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativeMicrophone_CheckPermission();

    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativeMicrophone_RequestPermission();

    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativeLocationWhenInUse_CheckPermission();

    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativeLocationWhenInUse_RequestPermission();

    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativeLocationAlways_CheckPermission();

    [System.Runtime.InteropServices.DllImport("__Internal")]
    private static extern int _PNativeLocationAlways_RequestPermission();
    #endif

    #region Runtime Permissions
    public static PermissionSelf CheckPermission(PermissionType permissionType)
    {
#if !UNITY_EDITOR && UNITY_IOS
        switch (permissionType)
        {
            case PermissionType.Microphone: return (PermissionSelf)_PNativeMicrophone_CheckPermission(); break;
            case PermissionType.LocationWhenInUse: return (PermissionSelf)_PNativeLocationWhenInUse_CheckPermission(); break;
            case PermissionType.LocationAlways: return (PermissionSelf)_PNativeLocationAlways_CheckPermission(); break;
            case PermissionType.Camera: return (PermissionSelf)_PNativeCamera_CheckPermission(); break;
            case PermissionType.PhotoLibrary: return (PermissionSelf)_PNativePhotoLibrary_CheckPermission(); break;
            default: return PermissionSelf.Granted; break;
        }
#else
        return PermissionSelf.Granted;
#endif
    }

    public static PermissionSelf RequestPermission(PermissionType permissionType)
    {
#if !UNITY_EDITOR && UNITY_IOS
         switch (permissionType)
        {
            case PermissionType.Microphone: return (PermissionSelf)_PNativeMicrophone_RequestPermission(); break;
            case PermissionType.LocationWhenInUse: return (PermissionSelf)_PNativeLocationWhenInUse_RequestPermission(); break;
            case PermissionType.LocationAlways: return (PermissionSelf)_PNativeLocationAlways_RequestPermission(); break;
            case PermissionType.Camera: return (PermissionSelf)_PNativeCamera_RequestPermission(); break;
            case PermissionType.PhotoLibrary: return (PermissionSelf)_PNativePhotoLibrary_RequestPermission(); break;
            default: return PermissionSelf.Granted; break;
        }
#else
        return PermissionSelf.Granted;
#endif
    }
    #endregion
}

