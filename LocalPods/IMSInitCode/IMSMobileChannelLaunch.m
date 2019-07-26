//
//  IMSMobileChannelLaunch.m
//  spring-demo
//
//  Created by dujin on 2018/6/12.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "IMSMobileChannelLaunch.h"

#import <IMSLog/IMSLog.h>
#import <IMSLaunchKit/IMSLaunchKit.h>

#import <AlinkAppExpress/AlinkAppExpress.h>
#import <IMSAccount/IMSAccount.h>
#import <ALBBOpenAccountCloud/ALBBOpenAccountSDK.h>
#import <IMSApiClient/IMSApiClient.h>

static NSString *const kIMSMobileChannelLaunchLogTag = @"MobileChannelDemo";
static NSString *const kIMSApiClientLaunchAutoSelectChannelHost = @"autoSelectChannelHost";


@interface IMSMobileChannelLaunch () <LKAppExpConnectListener>


@end

@implementation IMSMobileChannelLaunch

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IMSLog registerTag:kIMSMobileChannelLaunchLogTag];
    
    NSDictionary *envConfig = [launchOptions valueForKey:kLauncherEnvConfigKey];
    NSString *gRegion = [envConfig valueForKey:kLauncherEnvRegion] ? : LauncherEnvRegionDefaultValue;
    NSNumber *autoSelectChannelHost = launchOptions[gRegion][kIMSApiClientLaunchAutoSelectChannelHost];
    
    LKAppExpressEnv expressEnv = (LKAppExpressEnv)([IMSConfiguration sharedInstance].serverEnv + 1);
    LKAEConnectConfig *channelConfig = [LKAEConnectConfig new];
    channelConfig.appKey = [IMSConfiguration sharedInstance].appKey;
    channelConfig.authCode = [IMSConfiguration sharedInstance].authCode;
    
    if ([autoSelectChannelHost isKindOfClass:[NSNumber class]] && [autoSelectChannelHost boolValue]) {
        channelConfig.autoSelectChannelHost = YES;
    }
    [LKAppExpressEnvSet setRunEnv:expressEnv];
    
    [[LKAppExpress sharedInstance] startConnect:channelConfig connectListener:self];
    
    return TRUE;
}

#pragma mark - LKAppExpConnectListener

- (void)onConnectState:(LKAppExpConnectState)state {
    switch (state) {
        case LKAppExpConnectStateConnected: {
            IMSLogDebug(kIMSMobileChannelLaunchLogTag, @"已连接");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"IMSMobileChannelConnectedSussess" object:nil userInfo:nil];
            });
            break;
        }
        case LKAppExpConnectStateDisconnected: {
            IMSLogDebug(kIMSMobileChannelLaunchLogTag, @"已断连");
            break;
        }
        case LKAppExpConnectStateConnecting: {
            IMSLogDebug(kIMSMobileChannelLaunchLogTag, @"开始建联");
            break;
        }
        default:
            break;
    }
}

@end
