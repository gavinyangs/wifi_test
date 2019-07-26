//
//  IMSBoneKitLaunch.m
//  spring-demo
//
//  Created by dujin on 2018/6/12.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "IMSBoneKitLaunch.h"

#import <IMSLaunchKit/IMSLaunchKit.h>
#import <IMSBoneKit/IMSBoneConfiguration.h>

@interface IMSBoneKitLaunch ()

@end

@implementation IMSBoneKitLaunch

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSDictionary *envConfig = [launchOptions valueForKey:kLauncherEnvConfigKey];
    NSString *boneEnv = [envConfig valueForKey:kLauncherEnvBoneKit];
    
    IMSBonePluginEnvironment pluginEnv = IMSBonePluginEnvironmentRelease;
    if ([boneEnv isEqualToString:@"test"]) {
        pluginEnv = IMSBonePluginEnvironmentDaily;
    }
    
    [IMSBoneConfiguration sharedInstance].pluginEnvironment = pluginEnv;
    
    return TRUE;
}

@end
