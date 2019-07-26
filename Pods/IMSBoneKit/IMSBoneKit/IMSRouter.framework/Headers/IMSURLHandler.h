//
//  IMSURLHandler.h
//  IMSRouter
//
//  Created by Hager Hu on 06/11/2017.
//  Copyright © 2017 Aliyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMSURLHandler <NSObject>

+ (UIViewController *)controllerWithParams:(NSDictionary *)params;

@optional
+ (BOOL)handleURL:(NSURL *)url params:(NSDictionary *)params;

@end
