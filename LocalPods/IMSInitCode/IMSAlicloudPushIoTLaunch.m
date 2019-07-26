//
//  IMSAlicloudPushIoTLaunch.m
//  
//
//  Created by Aliyun on 2018/6/21.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "IMSAlicloudPushIoTLaunch.h"

#import <IMSLog/IMSLog.h>
#import <IMSLaunchKit/IMSLaunchKit.h>
#import <CloudPushSDK/CloudPushSDK.h>
#import <IMSAccount/IMSAccount.h>
#import <IMSRouter/IMSRouterService.h>

static NSString *const IMSLogTagAlicloudPushIoTLaunch = @"PushLaunch";

@interface IMSAlicloudPushIoTLaunch ()

@property (nonatomic, strong) NSDictionary *launchOptions;

@property (nonatomic, strong) NSData *deviceToken;
@property (nonatomic, assign) BOOL pushInitialized;

@end

@implementation IMSAlicloudPushIoTLaunch

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IMSLog registerTag:IMSLogTagAlicloudPushIoTLaunch];
    
    self.launchOptions = launchOptions;
    
    NSDictionary *envConfig = [launchOptions valueForKey:kLauncherEnvConfigKey];
    NSString *autoCode = [envConfig valueForKey:kLauncherEnvAuthCode] ? : @"07e8";
    
    UIUserNotificationType type = (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:type  categories:nil]];
    [application registerForRemoteNotifications];
    
    __weak typeof(self) weakSelf = self;
    [CloudPushSDK setAuthCode:autoCode];
    [CloudPushSDK asyncInitWithSecurity:^(CloudPushCallbackResult *res) {
        if (res.success) {
            IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch, @"Push SDK init success, deviceId: %@.", [CloudPushSDK getDeviceId]);
            
            weakSelf.pushInitialized = TRUE;
            [weakSelf registerDeviceToken];
        } else {
            IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch, @"Push SDK init failed, error: %@", res.error);
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onMessageReceived:)
                                                 name:@"CCPDidReceiveMessageNotification"
                                               object:nil];
    
    [CloudPushSDK sendNotificationAck:launchOptions];
    
    NSString *url = [launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] valueForKey:@"url"];
    if (url.length > 0) {
        [self handlePushNotificationWithURL:[NSURL URLWithString:url]];
    }
    
    return TRUE;
}

#pragma mark - Push Notification Callback

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch, @"Receive one notification.");
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        return;
    }
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"];
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    NSString *sound = [aps valueForKey:@"sound"];
    NSString *Extras =
    [userInfo valueForKey:@"Extras"]; //服务端中Extras字段，key是自己定义的
    IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch,
                @"content = [%@], badge = [%ld], sound = [%@], Extras = [%@]",
                content, (long)badge, sound, Extras);
    // iOS badge 清0
    application.applicationIconBadgeNumber = 0;
    // 通知打开回执上报
    [CloudPushSDK sendNotificationAck:userInfo];
    
    NSString *url = [userInfo valueForKey:@"url"];
    if (url.length > 0) {
        [self handlePushNotificationWithURL:[NSURL URLWithString:url]];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    self.deviceToken = deviceToken;
    [self registerDeviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch, @"didFailToRegisterForRemoteNotificationsWithError %@", error);
}

#pragma mark - Notification Handler

- (void)handlePushNotificationWithURL:(NSURL *)url {
    IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch, @"Receive notification.");
    IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch, @"%@", url ? : @"");
    
    if (![[IMSAccountService sharedService] isLogin] || !url) {
        return;
    }
    
    NSString *startString = self.launchOptions[@"prefixURL"] ? : @"livinglink://living.aliyun.com?url=";
    NSRange startRange = [url.absoluteString rangeOfString:startString];
    if (startRange.length > 0) {
        NSString *encodeString = [[url absoluteString] substringFromIndex:(startRange.location + startRange.length)];
        NSString *decodeString = [encodeString stringByRemovingPercentEncoding];
        
        NSURL *routerURL = [NSURL URLWithString:decodeString];
        if (routerURL) {
            [[IMSRouterService sharedService] openURL:routerURL options:nil];
        }
    } else {
        [[IMSRouterService sharedService] openURL:url options:nil];
    }
}

- (void)registerDeviceToken {
    if (self.pushInitialized && self.deviceToken.length > 0) {
        [CloudPushSDK registerDevice:self.deviceToken
                        withCallback:^(CloudPushCallbackResult *res)
         {
             if (res.success) {
                 IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch, @"Register deviceToken success: %@", [CloudPushSDK getApnsDeviceToken]);
             } else {
                 IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch, @"Register deviceToken failed, error: %@", res.error);
             }
         }];
    }
}

#pragma mark - Action

- (void)onMessageReceived:(NSNotification *)notification {
    CCPSysMessage *message = [notification object];
    NSString *title = [[NSString alloc] initWithData:message.title encoding:NSUTF8StringEncoding];
    NSString *body = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    IMSLogDebug(IMSLogTagAlicloudPushIoTLaunch, @"Receive message title: %@, content: %@.", title, body);
}


@end
