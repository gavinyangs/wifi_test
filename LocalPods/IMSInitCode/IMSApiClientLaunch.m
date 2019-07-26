//
//  IMSApiClientLaunch.m
//  spring-demo
//
//  Created by dujin on 2018/6/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "IMSApiClientLaunch.h"

#import <IMSLaunchKit/IMSLaunchKit.h>
#import <IMSApiClient/IMSConfiguration.h>

static NSString *const kIMSApiClientLaunchHosts = @"hosts";
static NSString *const kIMSApiClientLaunchLanguage = @"language";


@interface IMSApiClientLaunch ()

@property (nonatomic, strong) NSDictionary *serverEnvDict;

@end


@implementation IMSApiClientLaunch

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *envConfig = [launchOptions valueForKey:kLauncherEnvConfigKey];
    NSString *gRegion = [envConfig valueForKey:kLauncherEnvRegion] ? : LauncherEnvRegionDefaultValue;
    NSString *gEnviroment = [envConfig valueForKey:kLauncherEnvServer] ? : LauncherEnvEnviromentDefaultValue;
    NSString *gLanguage = [envConfig valueForKey:kLauncherEnvLanguage];
    
    NSString *host = launchOptions[gRegion][kIMSApiClientLaunchHosts][gEnviroment];
    IMSServerEnviroment serverEnv = [self.serverEnvDict[gEnviroment] integerValue];
    NSString *language = gLanguage ? : launchOptions[gRegion][kIMSApiClientLaunchLanguage];
    NSString *autoCode = [envConfig valueForKey:kLauncherEnvAuthCode] ? : @"07e8";
    
    [IMSConfiguration initWithHost:(host ? : @"api.link.aliyun.com") serverEnv:serverEnv];
    [IMSConfiguration sharedInstance].authCode = autoCode;
    [IMSConfiguration sharedInstance].language = language;
    
    return TRUE;
}

#pragma mark - Property

- (NSDictionary *)serverEnvDict {
    if (!_serverEnvDict) {
        _serverEnvDict = @{
                           @"test": @(IMSServerDaily),
                           @"pre": @(IMSServerPreRelease),
                           @"release": @(IMSServerRelease),
                           };
    }
    return _serverEnvDict;
}

@end
