//
//  IMSRouterService.h
//  IMSRouter
//
//  Created by Hager Hu on 06/11/2017.
//  Copyright © 2017 Aliyun.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "IMSURLHandler.h"
#import "IMSMessageHandler.h"
#import "IMSContainerURLHandler.h"
#import "IMSRouterRedirectHandler.h"

#import "IMSRouterController.h"

extern NSString * const AKRouterLoadingClassKey;
extern NSString * const AKRouterPresentTypeKey;
extern NSString * const AKRouterPresentTypePush;
extern NSString * const AKRouterPresentTypePresent;
extern NSString * const AKRouterCompletionHandlerKey;
extern NSString * const AKRouterExitInterceptHandlerKey;

@protocol IMSRouterHandler <NSObject>

+ (void)registerRouterHandler;

@end


@interface IMSRouterService : NSObject

@property (nonatomic, strong) NSString *boneKey;

@property (nonatomic, strong) UINavigationController *rootNavigationController;

+ (instancetype)sharedService;

- (void)loadRouterHandler;

// 能否打开对应的url
- (BOOL)canOpenURL:(NSURL *)url options:(NSDictionary *)options;

// 打开对应的url
- (void)openURL:(NSURL *)url
        options:(NSDictionary *)options;

- (void)openStringURL:(NSString *)url
              options:(NSDictionary *)options;

- (void)openURL:(NSURL *)url
        options:(NSDictionary *)options
completionHandler:(void (^)(BOOL success))completion;


// 获取对应的视图控制器
- (UIViewController *)controllerWithURL:(NSURL *)url
                                options:(NSDictionary *)options;


// 消息类注册方式
- (BOOL)registerMessageHandler:(Class<IMSMessageHandler>)handler;


// 业务类注册方式
- (BOOL)registerURL:(NSURL *)url withHandler:(Class<IMSURLHandler>)handler;

//- (BOOL)registerRegex:(NSString *)regex withHandler:(Class<IMSURLHandler>)handler;

// 容器类注册方式，最先注册的最先被调用
- (BOOL)registerURLHandler:(Class<IMSContainerURLHandler>)handler;

// 注册重定向处理器
- (BOOL)regiseterRedirectHandler:(id<IMSRouterRedirectHandler>)handler;

// 最后执行的重定向处理器
- (BOOL)registerLastRedirectHandler:(id<IMSRouterRedirectHandler>)handler;


// 自定义路由加载中页面显示，不调用使用默认路由加载中页面
- (BOOL)registerLoadingHandler:(Class<IMSRouterController>)handler;

// 注册默认加载页面，默认支持多个加载页面实现类，但只能有1个默认加载页面
// 不调用此方法时，默认返回第一个注册的加载页面实现类；如果没有注册过，则使用统一路由内部默认加载页面
- (BOOL)registerDefaultLoadingHandler:(Class<IMSRouterController>)handler;

// 自定义路由找不到页面显示，不调用使用默认路由找不到页面
- (BOOL)registerNotFoundHandler:(Class<IMSRouterController>)handler;

// 自定义路由错误页面显示，不调用使用默认路由错误页面
- (BOOL)registerErrorHandler:(Class<IMSRouterErrorController>)handler;

@end
