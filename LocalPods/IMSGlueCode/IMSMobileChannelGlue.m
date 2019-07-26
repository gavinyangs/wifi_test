//
//  IMSMobileChannelGlue.m
//  spring-demo
//
//  Created by dujin on 2018/6/25.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "IMSMobileChannelGlue.h"

#import <IMSLog/IMSLog.h>
#import <AlinkAppExpress/AlinkAppExpress.h>
#import <IMSAuthentication/IMSAuthentication.h>
#import <IMSApiClient/IMSApiClient.h>
#import <ALBBOpenAccountCloud/ALBBOpenAccountSDK.h>

static NSString *const kIMSMobileChannelGlueLogTag = @"MobileChannelDemo";

@interface IMSMobileChannelGlue()

@end

@implementation IMSMobileChannelGlue

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bindMobileChannelWithAccount)
                                                     name:@"IMSMobileChannelConnectedSussess"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bindMobileChannelWithAccount)
                                                     name:ALBBOpenAccountNotificationUserLoggedIn
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    return TRUE;
}

#pragma mark - Request

- (void)bindMobileChannelWithAccount {
    IMSCredential *credential = [[IMSCredentialManager sharedManager] credential];
    if (credential && credential.iotToken && ![credential isIotTokenExpired]) {
        [self requestBindMobileChannelWithAccount:credential.iotToken];
    } else {
        [[IMSCredentialManager sharedManager] asyncRefreshCredential:^(NSError * _Nullable error, IMSCredential * _Nullable credential)
         {
             if (credential && credential.iotToken) {
                 [self requestBindMobileChannelWithAccount:credential.iotToken];
             } else {
                 IMSLogDebug(kIMSMobileChannelGlueLogTag, @"移动推送请求iotToken失败:%@", error);
             }
         }];
    }
}

- (void)requestBindMobileChannelWithAccount:(NSString *)token {
    if (!token) {
        return;
    }
    
    NSDictionary *params = @{
                             @"iotToken": token,
                             };
    [[LKAppExpress sharedInstance] invokeWithTopic:@"/account/bind"
                                              opts:nil
                                            params:params
                                       respHandler:^(LKAppExpResponse * _Nonnull response)
     {
         if ([response successed]) {
             IMSLogDebug(kIMSMobileChannelGlueLogTag, @"长连接通道绑定账号成功");
         } else {
             IMSLogDebug(kIMSMobileChannelGlueLogTag, @"长连接通道绑定账号失败");
         }
     }];
}

// TODO: 退出登录事件是需要顺序的
+ (void)requestUnbindMobileChannelWithAccount {
    [[LKAppExpress sharedInstance] invokeWithTopic:@"/account/unbind"
                                              opts:nil
                                            params:@{}
                                       respHandler:^(LKAppExpResponse * _Nonnull response)
     {
         if (![response successed]) {
             NSLog(@"解绑长连接推送失败");
         }
     }];
}

@end
