//
//  IMSLauncher.m
//  CocoaAsyncSocket
//
//  Created by Hager Hu on 2018/5/15.
//

#import "IMSLauncher.h"

#import "IMSLauncherEnv.h"
#import "IMSSDKConfig.h"

static NSString *const kLaunchSDKName = @"name";
static NSString *const kLaunchSDKVersion = @"version";
static NSString *const kLaunchSDKDesc = @"desc";
static NSString *const kLaunchSDKClassNames = @"classNames";
static NSString *const kLaunchSDKOpt = @"opt";

static NSString *const kLaunchSDKSubmodules = @"submodules";


@interface IMSLauncher ()

@property (nonatomic, strong) NSArray<IMSSDKConfig *> *sdkConfigList;

@end


@implementation IMSLauncher

+ (instancetype)defaultLauncher {
    static IMSLauncher *launcher = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        launcher = [[[self class] alloc] init];
    });
    
    return launcher;
}

- (id)init {
    if (self = [super init]) {
        [self registerObserver];
    }
    
    return self;
}

- (void)dealloc {
    [self removeApplicationObserver];
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"%s options:%@", __FUNCTION__, launchOptions);
    
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        NSMutableDictionary *option = [sdk.opt mutableCopy] ? : [NSMutableDictionary dictionary];
        [option addEntriesFromDictionary:launchOptions];
        
        NSDictionary *envConfig = [IMSLauncherEnv sharedInstance].launcherConfig ? : @{};
        [option setValue:envConfig forKey:kLauncherEnvConfigKey];

        for (id<UIApplicationDelegate> instance in sdk.instances) {
            [instance application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:option];
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            NSMutableDictionary *suboption = [subsdk.opt mutableCopy] ? : [NSMutableDictionary dictionary];
            [suboption addEntriesFromDictionary:launchOptions];
            
            NSDictionary *envConfig = [IMSLauncherEnv sharedInstance].launcherConfig ? : @{};
            [suboption setValue:envConfig forKey:kLauncherEnvConfigKey];
            
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                [subinstance application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:suboption];
            }
        }
    }
    
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<UIApplicationDelegate> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
                [instance application:application didReceiveRemoteNotification:userInfo];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
                    [subinstance application:application didReceiveRemoteNotification:userInfo];
                }
            }
        }
    }
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<UIApplicationDelegate> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
                [instance application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
                    [subinstance application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
                }
            }
        }
    }
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<UIApplicationDelegate> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
                [instance application:application didFailToRegisterForRemoteNotificationsWithError:error];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
                    [subinstance application:application didFailToRegisterForRemoteNotificationsWithError:error];
                }
            }
        }
    }
}


#pragma mark - Other

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"%s", __FUNCTION__);
    
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<UIApplicationDelegate> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(applicationDidBecomeActive:)]) {
                [instance applicationDidBecomeActive:application];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(applicationDidBecomeActive:)]) {
                    [subinstance applicationDidBecomeActive:application];
                }
            }
        }
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"%s", __FUNCTION__);
    
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<UIApplicationDelegate> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(applicationWillResignActive:)]) {
                [instance applicationWillResignActive:application];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(applicationWillResignActive:)]) {
                    [subinstance applicationWillResignActive:application];
                }
            }
        }
    }
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"%s", __FUNCTION__);
    
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<UIApplicationDelegate> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(applicationDidEnterBackground:)]) {
                [instance applicationDidEnterBackground:application];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(applicationDidEnterBackground:)]) {
                    [subinstance applicationDidEnterBackground:application];
                }
            }
        }
    }
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"%s", __FUNCTION__);
    
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<UIApplicationDelegate> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(applicationWillEnterForeground:)]) {
                [instance applicationWillEnterForeground:application];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(applicationWillEnterForeground:)]) {
                    [subinstance applicationWillEnterForeground:application];
                }
            }
        }
    }
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    NSLog(@"%s", __FUNCTION__);
    
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<UIApplicationDelegate> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(applicationDidReceiveMemoryWarning:)]) {
                [instance applicationDidReceiveMemoryWarning:application];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(applicationDidReceiveMemoryWarning:)]) {
                    [subinstance applicationDidReceiveMemoryWarning:application];
                }
            }
        }
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"%s", __FUNCTION__);
    
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<UIApplicationDelegate> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(applicationWillTerminate:)]) {
                [instance applicationWillTerminate:application];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<UIApplicationDelegate> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(applicationWillTerminate:)]) {
                    [subinstance applicationWillTerminate:application];
                }
            }
        }
    }
}

#pragma mark - Method

- (void)refreshWithOpt:(NSDictionary *)opt {
    for (IMSSDKConfig *sdk in self.sdkConfigList) {
        for (id<IMSLauncherProtocol> instance in sdk.instances) {
            if ([instance respondsToSelector:@selector(refreshWithOpt:)]) {
                [instance refreshWithOpt:opt];
            }
        }
        
        for (IMSSDKConfig *subsdk in sdk.submodules) {
            for (id<IMSLauncherProtocol> subinstance in subsdk.instances) {
                if ([subinstance respondsToSelector:@selector(refreshWithOpt:)]) {
                    [subinstance refreshWithOpt:opt];
                }
            }
        }
    }
}

- (NSArray *)launchJSONConfig {
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *path = [mainBundle pathForResource:@"Launch" ofType:@"json"];
    
    if (!path) {
        return nil;
    }
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    if (!data) {
        return nil;
    }
    
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

#pragma mark - Property

- (NSArray *)sdkConfigList {
    if (!_sdkConfigList) {
        NSArray *json = [self launchJSONConfig];
        NSMutableArray *sdkMutArray = [NSMutableArray array];
        
        for (NSDictionary *dict in json) {
            IMSSDKConfig *sdk = [self dict2SDKConfig:dict];
            
            IMSSDKConfig *subsdk = nil;
            NSMutableArray<IMSSDKConfig *> *submodules = [NSMutableArray array];
            for (NSDictionary *subdict in dict[kLaunchSDKSubmodules]) {
                subsdk = [self dict2SDKConfig:subdict];
                if (subsdk) {
                    [submodules addObject:subsdk];
                }
            }
            if (submodules.count > 0) {
                sdk.submodules = submodules;
            }
            
            if (sdk) {
                [sdkMutArray addObject:sdk];
            }
        }
        
        _sdkConfigList = sdkMutArray;
    }
    
    return _sdkConfigList;
}

- (IMSSDKConfig *)dict2SDKConfig:(NSDictionary *)config {
    IMSSDKConfig *sdk = [[IMSSDKConfig alloc] init];
    sdk.name = config[kLaunchSDKName];
    sdk.version = config[kLaunchSDKVersion];
    sdk.desc = config[kLaunchSDKDesc];
    sdk.classNames = config[kLaunchSDKClassNames];
    sdk.opt = config[kLaunchSDKOpt];
    
    if (sdk.classNames.count > 0) {
        Class class = nil;
        NSMutableArray *instances = [NSMutableArray array];
        for (NSString *className in sdk.classNames) {
            class = NSClassFromString(className);
            if (class) {
                [instances addObject:[[class alloc] init]];
            }
        }
        if (instances.count > 0) {
            sdk.instances = instances;
        }
    }
    
    return sdk;
}

#pragma mark - Add or Remove UIApplication State Observer

- (void)registerObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidReceiveMemoryWarning:)
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillTerminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}


- (void)removeApplicationObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIApplicationDidReceiveMemoryWarningNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                 name:UIApplicationWillTerminateNotification
                                               object:nil];
}

@end
