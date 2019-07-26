//
//  IMSAlicloudPushIoTGlue.m
//  
//
//  Created by Aliyun on 2018/6/21.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "IMSAlicloudPushIoTGlue.h"

#import <IMSLog/IMSLog.h>
#import <IMSAccount/IMSAccount.h>
#import <IMSAuthentication/IMSAuthentication.h>
#import <ALBBOpenAccountCloud/ALBBOpenAccountSDK.h>
#import <IMSApiClient/IMSApiClient.h>
#import <CloudPushSDK/CloudPushSDK.h>

static NSString *const IMSLogTagAlicloudPushIoTGlue = @"PushGlue";
static NSString *const kIMSAlicloudPushIoTLaunchBindDeviceWithAccount = @"bindDeviceWithAccount";

@interface IMSAlicloudPushIoTGlue ()


@end


@implementation IMSAlicloudPushIoTGlue

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [IMSLog registerTag:IMSLogTagAlicloudPushIoTGlue];
    
    NSNumber *shouldBind = launchOptions[kIMSAlicloudPushIoTLaunchBindDeviceWithAccount];
    if ([shouldBind isKindOfClass:[NSNumber class]] && [shouldBind boolValue]) {
        if ([[IMSAccountService sharedService] isLogin]) {
            [self bindDevicePushWithAccount];
        } else {
            __weak typeof(self) weakSelf = self;
            [[NSNotificationCenter defaultCenter] addObserverForName:ALBBOpenAccountNotificationUserLoggedIn
                                                              object:nil
                                                               queue:[NSOperationQueue mainQueue]
                                                          usingBlock:^(NSNotification * _Nonnull note)
             {
                 [weakSelf bindDevicePushWithAccount];
             }];
        }
    }
    
    return TRUE;
}

#pragma mark - Request

- (void)bindDevicePushWithAccount {
    NSDictionary *params = @{
                             @"deviceId": [CloudPushSDK getDeviceId] ? : @"",
                             @"deviceType":@"iOS"
                             };
    
    IMSIoTRequestBuilder *builder = [[IMSIoTRequestBuilder alloc] initWithPath:@"/uc/bindPushChannel"
                                                                    apiVersion:@"1.0.2"
                                                                        params:params];
    [builder setAuthenticationType:IMSAuthenticationTypeIoT];
    
    IMSRequest *request = [[builder setAuthenticationType:IMSAuthenticationTypeIoT] build];
    [IMSRequestClient asyncSendRequest:request responseHandler:^(NSError *error, IMSResponse *response) {
        if (error) {
            IMSLogDebug(IMSLogTagAlicloudPushIoTGlue, @"Push SDK init failed, error: %@", error);
        } else {
            if (response.code != 200) {
                IMSLogDebug(IMSLogTagAlicloudPushIoTGlue, @"Push SDK init failed, error: %@", response.localizedMsg);
            } else {
                IMSLogDebug(IMSLogTagAlicloudPushIoTGlue, @"Push SDK init success");
            }
        }
    }];
}
	
+ (void)unbindAPNSChannel {
	NSString *path = @"/uc/unbindPushChannel";
	NSString *version = @"1.0.0";
	NSDictionary *params = @{
							 @"deviceId": [CloudPushSDK getDeviceId] ? : @"",
							 };
	
	IMSIoTRequestBuilder *builder = [[IMSIoTRequestBuilder alloc] 	 initWithPath:path
																	  apiVersion:version
																		  params:params];
	[builder setAuthenticationType:IMSAuthenticationTypeIoT];
	[builder setScheme:@"https://"];
	IMSRequest *request = [[builder setAuthenticationType:IMSAuthenticationTypeIoT] build];
	[IMSRequestClient asyncSendRequest:request responseHandler:^(NSError *error, IMSResponse *response) {
		if (error) {
			IMSLogDebug(IMSLogTagAlicloudPushIoTGlue, @"Push SDK unbind failed, error: %@", error);
		} else {
			if (response.code != 200) {
				IMSLogDebug(IMSLogTagAlicloudPushIoTGlue, @"Push SDK unbind failed, error: %@", response.localizedMsg);
			} else {
				IMSLogDebug(IMSLogTagAlicloudPushIoTGlue, @"Push SDK unbind success");
			}
		}
	}];
}

@end
