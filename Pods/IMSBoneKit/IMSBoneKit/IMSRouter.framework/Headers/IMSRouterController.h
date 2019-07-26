//
//  IMSRouterController.h
//  IMSRouter
//
//  Created by Hager Hu on 06/11/2017.
//  Copyright © 2017 Aliyun.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol IMSRouterController <NSObject>

+ (UIViewController *)controllerWithURL:(NSURL *)url
                                 params:(NSDictionary<NSString *, id> *)params;

@end


@protocol IMSRouterErrorController <NSObject>

+ (UIViewController *)controllerWithURL:(NSURL *)url
                                 params:(NSDictionary<NSString *, id> *)params
                                  error:(NSError *)error;

@end
