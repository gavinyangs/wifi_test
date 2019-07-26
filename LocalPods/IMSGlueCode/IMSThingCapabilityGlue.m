//
//  IMSThingCapabilityGlue.m
//  spring-demo
//
//  Created by dujin on 2018/6/25.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "IMSThingCapabilityGlue.h"

#import <IMSThingCapability/IMSThingCapability.h>

@interface IMSThingCapabilityGlue ()

@end

@implementation IMSThingCapabilityGlue

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:@"ALBBOA_NOTIFICATION_USER_LOGGED_OUT"
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          [kIMSThingManager clearLocalCache];
                                                      }];    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    return TRUE;
}

#pragma mark - Request


@end
