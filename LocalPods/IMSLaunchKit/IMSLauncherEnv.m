//
//  IMSLauncherEnv.m
//  IMSLaunchKit
//
//  Created by dujin on 2018/6/21.
//

#import "IMSLauncherEnv.h"

NSString * const kLauncherEnvConfigKey = @"IMSLauncherEnvConfigKey";

NSString * const kLauncherEnvRegion = @"region";
NSString * const kLauncherEnvServer = @"serverEnv";
NSString * const kLauncherEnvLanguage = @"language";
NSString * const kLauncherEnvAuthCode = @"authCode";
NSString * const kLauncherEnvBoneKit = @"boneEnv";
NSString * const kLauncherEnvAppEnv = @"LDPAppEnv";

NSString * const LauncherEnvRegionDefaultValue = @"china";
NSString * const LauncherEnvEnviromentDefaultValue = @"release";
NSString * const LauncherEnvLanguageDefaultValue = @"zh-CN";


static NSString * const IMSLauncherBundleName = @"IMSLaunchKit";

@interface IMSLauncherEnv ()

@end

@implementation IMSLauncherEnv

+ (instancetype)sharedInstance {
    static IMSLauncherEnv *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _launcherConfig = [NSMutableDictionary dictionary];
        
        [self loadConfig];
    }
    return self;
}

#pragma mark - Method

- (void)loadConfig {
    [self.launcherConfig addEntriesFromDictionary:[self defalutLauncherKitConfig] ? : @{}];
}

#pragma mark - File Path

- (NSDictionary *)defalutLauncherKitConfig {
    return @{
             @"region": @"china",
             @"boneEnv": @"release",
             @"serverEnv": @"release",
             @"language": @"zh-CN",
             @"authCode": @"07e8",
             };
}

@end

