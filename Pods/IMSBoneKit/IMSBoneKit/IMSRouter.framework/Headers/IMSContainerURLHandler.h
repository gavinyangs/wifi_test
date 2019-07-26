//
//  IMSContainerURLHandler.h
//  IMSRouter
//
//  Created by Hager Hu on 06/11/2017.
//  Copyright © 2017 Aliyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol IMSContainerURLHandler <NSObject>

/**
 能否处理指定URL和对应的参数
 
 @param url 需要处理的url，不包含查询参数
 @param params 需要处理的url对应的查询参数
 @return 能够处理返回YES，否则返回NO。
 */

+ (BOOL)canHandle:(NSURL *)url params:(NSDictionary *)params;

/**
 返回指定URL和参数对应的视图控制器实例
 
 @param url 对应的url内容，不包含查询参数
 @param params 对应url的查询参数
 @return 返回对应的视图控制器实例，不应该返回nil
 */
+ (UIViewController *)controllerWithURL:(NSURL *)url params:(NSDictionary *)params;

@optional
+ (BOOL)handleURL:(NSURL *)url params:(NSDictionary *)params;

@end
