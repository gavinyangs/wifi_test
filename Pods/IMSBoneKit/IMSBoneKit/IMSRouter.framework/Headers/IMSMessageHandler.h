//
//  IMSMessageHandler.h
//  IMSRouter
//
//  Created by Hager Hu on 06/11/2017.
//  Copyright © 2017 Aliyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMSMessageHandler <NSObject>

+ (NSArray *)observeMessage;

+ (BOOL)handleMessage:(NSNotification *)message;

@end
