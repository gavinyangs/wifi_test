//
//  IMSAuthenticationLaunch.m
//  spring-demo
//
//  Created by dujin on 2018/6/11.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "IMSAuthenticationLaunch.h"

#import <IMSLaunchKit/IMSLaunchKit.h>

#import <IMSApiClient/IMSApiClient.h>
#import <IMSAuthentication/IMSAuthentication.h>
#import <IMSAccount/IMSAccount.h>
#import <IMSInitCode/IMSOpenAccount.h>
#import <ALBBOpenAccountCloud/ALBBOpenAccountSDK.h>

static NSString *const kIMSAuthenticationLaunchHost = @"host";
static NSString *const kIMSAuthenticationLaunchLanguage = @"language";


@interface IMSAuthenticationLaunch ()

@property (nonatomic, strong) NSDictionary *lanMapper;

@end

@implementation IMSAuthenticationLaunch

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *envConfig = [launchOptions valueForKey:kLauncherEnvConfigKey];
    NSString *gRegion = [envConfig valueForKey:kLauncherEnvRegion] ? : LauncherEnvRegionDefaultValue;
    NSString *gLanguage = [envConfig valueForKey:kLauncherEnvLanguage];
    
    NSString *host = launchOptions[gRegion][kIMSAuthenticationLaunchHost];
    NSString *language = gLanguage ? : launchOptions[gRegion][kIMSAuthenticationLaunchLanguage];
    
    if (host.length > 0) {
        [[ALBBOpenAccountSDK sharedInstance] setGwHost:host];
    }
	
#if DEBUG
    [[ALBBOpenAccountSDK sharedInstance] setDebugLogOpen:YES];
#endif
    
    if (language.length > 0) {
        [[ALBBOpenAccountSDK sharedInstance] setI18N:[self.lanMapper valueForKey:language]];
    }
    
    IMSAccountService *accountService = [IMSAccountService sharedService];
    IMSOpenAccount *openAccount = [IMSOpenAccount sharedInstance];
    accountService.sessionProvider = openAccount;
    accountService.accountProvider = openAccount;
    
    [IMSCredentialManager initWithAccountProtocol:accountService.sessionProvider];
    IMSIoTAuthentication *iotAuthDelegate = [[IMSIoTAuthentication alloc] initWithCredentialManager:IMSCredentialManager.sharedManager];
    [IMSRequestClient registerDelegate:iotAuthDelegate forAuthenticationType:IMSAuthenticationTypeIoT];
    
    return TRUE;
}

#pragma mark - Property

- (NSDictionary *)lanMapper {
    if (!_lanMapper) {
        _lanMapper = @{
                   @"zh-CN": @"zh-Hans",
                   @"en-US": @"en",
                   };
    }
    return _lanMapper;
}

@end
