//
//  IMSMobileChannelGlue.h
//  spring-demo
//
//  Created by dujin on 2018/6/25.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IMSMobileChannelGlue : NSObject <UIApplicationDelegate>
+ (void)requestUnbindMobileChannelWithAccount;
@end
