//
//  IMSLauncher.h
//  CocoaAsyncSocket
//
//  Created by Hager Hu on 2018/5/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "IMSLauncherProtocol.h"

@interface IMSLauncher : NSObject <UIApplicationDelegate>

+ (instancetype)defaultLauncher;

- (void)refreshWithOpt:(NSDictionary *)opt;

@end
