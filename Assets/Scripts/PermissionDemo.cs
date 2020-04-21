using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

//参考的案例：
//android:https://github.com/yasirkula/UnityAndroidRuntimePermissions
//ios:https://github.com/hiyorin/PermissionPlugin-for-Unity
public class PermissionDemo : MonoBehaviour
{
    public Text resultText;

    //核查麦克风的权限
    public void CheckPermission()
    {

#if UNITY_ANDROID && !UNITY_EDITOR
          AndroidRuntimePermissions.Permission result = AndroidRuntimePermissions.CheckPermission("android.permission.RECORD_AUDIO");
        if (result == AndroidRuntimePermissions.Permission.Granted)
        {
            resultText.text = "核查--麦克风权限被--允许";
        }
        else if (result == AndroidRuntimePermissions.Permission.ShouldAsk)
        {
            resultText.text = "核查--麦克风权限被--未同意可询问";
        }
        else if (result == AndroidRuntimePermissions.Permission.Denied)
        {
            resultText.text = "核查--麦克风权限被--被拒绝到设置里开启";
        }
#elif UNITY_IOS && !UNITY_EDITOR
#else

#endif


    }

   

    

    //请求麦克风的权限
    public void RequestPermission()
    {

#if UNITY_ANDROID && !UNITY_EDITOR
        AndroidRuntimePermissions.Permission result = AndroidRuntimePermissions.RequestPermission("android.permission.RECORD_AUDIO");
        if (result == AndroidRuntimePermissions.Permission.Granted)
        {
            resultText.text = "请求--麦克风权限被--允许";
        }
        else if (result == AndroidRuntimePermissions.Permission.ShouldAsk)
        {
            resultText.text = "请求--麦克风权限被--未同意可询问";
        }
        else if (result == AndroidRuntimePermissions.Permission.Denied)
        {
            resultText.text = "请求--麦克风权限被--被拒绝到设置里开启";
        }
#elif UNITY_IOS && !UNITY_EDITOR
#else
#endif

    }


    //ios的核查的方法
    public void IOSCheckPermission(int permissionType)
    {
#if UNITY_IOS && !UNITY_EDITOR
        PermissionSelf result = PermissionPluginForIOS.CheckPermission((PermissionType)permissionType);
        resultText.text = "ios的核查结果：" + result;
#endif

    }
    //ios的请求的方法
    public void IOSRequestPermission(int permissionType)
    {
#if UNITY_IOS && !UNITY_EDITOR
         PermissionSelf result = PermissionPluginForIOS.RequestPermission((PermissionType)permissionType);
        resultText.text = "ios的请求结果：" + result;
#endif

    }
}
