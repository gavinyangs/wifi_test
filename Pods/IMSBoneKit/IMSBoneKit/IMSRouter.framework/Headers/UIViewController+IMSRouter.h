//
//  UIViewController+AKRouter.h
//  Pods
//
//  Created by Hager Hu on 28/04/2017.
//
//

#import <UIKit/UIKit.h>

typedef void(^IMSRouterCallback)(NSError *error, NSDictionary *info);

@interface UIViewController (IMSRouter)

- (IMSRouterCallback)ims_routerCallback;

- (void)ims_setRouterCallback:(IMSRouterCallback)callback;

- (IMSRouterCallback)ims_routerExitInterceptCallback;

- (void)ims_setRouterExitInterceptCallback:(IMSRouterCallback)callback;

@end
