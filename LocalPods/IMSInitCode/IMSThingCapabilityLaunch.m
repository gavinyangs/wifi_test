//
//  IMSThingCapabilityLaunch.m
//  spring-demo
//
//  Created by dujin on 2018/6/12.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "IMSThingCapabilityLaunch.h"

#import <IMSLaunchKit/IMSLaunchKit.h>

#import <IMSLog/IMSLog.h>
#import <IMSThingCapability/IMSThingCapability.h>
#import <AlinkAppExpress/AlinkAppExpress.h>
#import <AlinkMobileGateway/AlinkMobileGateway.h>


static NSString *const kIMSThingCapabilityLaunchLogTag = @"IoTSDKInit";

@interface IMSThingCapabilityLaunch ()<LKMgwConnectListener>

@end

@implementation IMSThingCapabilityLaunch

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(startGatewayConnect)
                                                     name:@"IMSMobileChannelConnectedSussess"
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IMSLog registerTag:kIMSThingCapabilityLaunchLogTag];
    
    [kIMSThingManager startLocalAcceleration];
    
    [self startGatewayConnect];
    
    return TRUE;
}

- (void)startGatewayConnect {
    NSString *clientId = [[LKAppExpress sharedInstance] getClientId];
    if (clientId.length > 0) {
        [[LKIoTMobileGateway sharedGateway] startConnectWithId:clientId connectListener:self];
    }
}

#pragma mark - LKMgwConnectListener

- (void)onConnectState:(LKMgwConnectState)state {
    switch (state) {
        case LKMgwConnectStateConnected:
            IMSLogDebug(kIMSThingCapabilityLaunchLogTag, @"网关已连接");
            break;
        case LKMgwConnectStateDisConnected:
            IMSLogDebug(kIMSThingCapabilityLaunchLogTag, @"网关已断连");
            break;
        case LKMgwConnectStateConnecting:
            IMSLogDebug(kIMSThingCapabilityLaunchLogTag, @"网关连接中");
            break;
            
        default:
            break;
    }
}

@end
