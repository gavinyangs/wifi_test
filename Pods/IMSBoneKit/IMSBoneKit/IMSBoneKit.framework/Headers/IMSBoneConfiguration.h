//
//  IMSBoneConfiguration.h
//  IMSBoneKit
//
//  Created by Aliyun on 2017/11/30.
//  Copyright © 2017年 Aliyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IMSBoneServerEnvironment) {
    IMSBoneServerEnvironmentDaily,
    IMSBoneServerEnvironmentPreRelease,
    IMSBoneServerEnvironmentRelease,
};

/**
 Bone 插件环境
 */
typedef NS_ENUM(NSInteger, IMSBonePluginEnvironment) {
    IMSBonePluginEnvironmentDaily,          // 开发环境
    IMSBonePluginEnvironmentRelease,        // 生产环境
};

/**
 Bone 容器运行配置
 */
@interface IMSBoneConfiguration : NSObject

/**
 设置插件环境，默认为生产环境，参见枚举 `IMSBonePluginEnvironment`
 */
@property (nonatomic, assign) IMSBonePluginEnvironment pluginEnvironment;

@property (nonatomic, assign) IMSBoneServerEnvironment serverEnvironment __deprecated_msg("已废弃，内部通过 `[IMSConfiguration sharedInstance].serverEnv` 进行打通");

/**
 返回 Bone 容器运行配置的实例，采用单例设计
 */
+ (instancetype)sharedInstance;


/**
 获取bone config属性

 @param key bone config 列表对应的key
 @return key值对应的bone config属性
 */
- (id)get:(NSString *)key;


/**
 可以自定义bone config 属性，这些属性会上报给插件

 @param key bone config属性对应的key
 @param value 更新的属性值
 */
- (void)set:(NSString *)key value:(id)value;

/**
 更新整个bone config 属性，慎用！！！
 
 @param config bone config属性
 */
- (void)setAll:(NSDictionary *)config;

/**
 返回所有bone config 属性
 */
- (NSDictionary *)getAll;

@end
