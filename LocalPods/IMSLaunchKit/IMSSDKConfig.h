//
//  IMSSDKConfig.h
//  IMSLaunchKit
//
//  Created by Hager Hu on 2018/5/15.
//

#import <Foundation/Foundation.h>

@interface IMSSDKConfig : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *version;
@property (nonatomic, strong) NSArray<NSString *> *classNames;
@property (nonatomic, strong) NSDictionary *opt;

@property (nonatomic, strong) NSArray *instances;

@property (nonatomic, strong) NSArray<IMSSDKConfig *> *submodules;

@end
