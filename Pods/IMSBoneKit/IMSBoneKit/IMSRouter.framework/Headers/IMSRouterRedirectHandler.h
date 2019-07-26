//
//  IMSRouterRedirectHandler.h
//  IMSRouter
//
//  Created by Hager Hu on 06/11/2017.
//  Copyright © 2017 Aliyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^IMSRedirectHandler)(NSError *error, NSURL *newURL, NSDictionary *options);

@protocol IMSRouterRedirectHandler <NSObject>

/**
 判断是否需要路由重定向
 
 @param url 需要判断的url地址
 @param options 需要判断的url地址对应的查询参数
 @return 是否需要重新路由
 */
- (BOOL)needsRedirectWithURL:(NSURL *)url options:(NSDictionary *)options;

/**
 判断是否需要加载页面
 
 @param url 需要判断的url地址
 @param options 需要判断的url地址对应的查询参数
 @return 是否需要加载页面
 */
- (BOOL)needsLoadingViewWithURL:(NSURL *)url options:(NSDictionary *)options;

/**
 处理指定url对应的路由
 
 @param url 需要获取目标地址的原始url
 @param options 需要判断的url地址对应的查询参数
 @param handler 重新路由后的url地址
 */
- (void)handleURL:(NSURL *)url options:(NSDictionary *)options completion:(IMSRedirectHandler)handler;

@end
