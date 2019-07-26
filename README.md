### 介绍
* 移动SDK工作台主要帮助解决SDK组合及初始化过程中遇到的问题，节省SDK接入成本。

### 依赖及安装
* 本框架依赖CocoaPods，请先安装CocoaPods，建议使用最新版本；

* 创建.xcodeproj工程，将本文件夹的内容拷贝至.xcodeproj根目录（如果已有Podfile，请注意内容合并）；

* 修改Bundle Identifier，与移动SDK工作台创建的应用的“应用包名”保持一致；

* 前往移动SDK工作台下载安全图片，将安全图片引用到工程中（注意：不要修改安全图片的默认名字，yw_1222_07e8.jpg）；

* 将本文件夹内的Launch.json配置文件引用到工程中；

* 运行pod update，确保安装成功；

* 打开./Pods/AlicloudALBBOpenAccount/openaccount/ALBBOpenAccountUI.framework/ALBBOpenAccount.bundle，
   将里面的资源文件引用到工程中。

### 用法
* 待完成上面的步骤后 ，打开AppDelegate.m文件添加如下事件，
    * 引入头文件：
        ```
            #import <IMSLaunchKit/IMSLaunchKit.h>
        ```
    * 添加代码：
        ```
            - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
                [[IMSLauncher defaultLauncher] application:application didFinishLaunchingWithOptions:launchOptions];
                return YES;
            }
        ```

* 如果需要支持Push，请打开AppDelegate.m添加如下事件：
    ```
        - (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
            [[IMSLauncher defaultLauncher] application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
        }

        - (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
            [[IMSLauncher defaultLauncher] application:application didFailToRegisterForRemoteNotificationsWithError:error];
        }

        - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
            [[IMSLauncher defaultLauncher] application:application didReceiveRemoteNotification:userInfo];
        }
    ```

