//
//  IMSLauncherEnv.h
//  IMSLaunchKit
//
//  Created by dujin on 2018/6/21.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kLauncherEnvAppEnvRelease,
    kLauncherEnvAppEnvDebug,
} LauncherEnvAppEnv;

extern NSString * const kLauncherEnvConfigKey;

extern NSString * const kLauncherEnvRegion;
extern NSString * const kLauncherEnvServer;
extern NSString * const kLauncherEnvLanguage;
extern NSString * const kLauncherEnvAuthCode;
extern NSString * const kLauncherEnvBoneKit;
extern NSString * const kLauncherEnvAppEnv;

extern NSString * const LauncherEnvRegionDefaultValue;
extern NSString * const LauncherEnvEnviromentDefaultValue;
extern NSString * const LauncherEnvLanguageDefaultValue;


@interface IMSLauncherEnv : NSObject

@property (nonatomic, strong) NSMutableDictionary *launcherConfig;

+ (instancetype)sharedInstance;

@end
