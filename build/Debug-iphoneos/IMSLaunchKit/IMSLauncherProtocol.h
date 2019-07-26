//
//  IMSLauncherProtocol.h
//  IMSLaunchKit
//
//  Created by Aliyun on 2018/9/7.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol IMSLauncherProtocol <NSObject>

@optional
- (void)refreshWithOpt:(NSDictionary *)opt;

@end

NS_ASSUME_NONNULL_END
