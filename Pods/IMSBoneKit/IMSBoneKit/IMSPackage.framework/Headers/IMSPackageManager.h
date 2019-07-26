//
//  IMSPackageManager.h
//  Pods
//
//  Created by dujin on 2017/11/7.
//
//

#import <Foundation/Foundation.h>
#import "IMSBonePackagePlugin.h"

extern NSString * const IMSApiLevel;

@class PKGLocalPackageConfig;

/**
 Bone 容器 RN 基础包和插件资源文件的包管理类
 */
@interface IMSPackageManager : NSObject <BonePackagePluginProtocol>

/**
 设置应用程序的版本号，默认取 Info.plist 文件里的 CFBundleShortVersionString 字段
 */
@property (nonatomic, strong) NSString *appVersion;

/**
 设置包管理类的运行环境，默认取值为 @[@"bone-aep-rn"]
 */
@property (nonatomic, strong) NSArray *runTypes;

/**
 设置包管理类的插件运行环境，开发环境为"test"，生产环境为"release"，默认为生产环境
 */
@property (nonatomic, strong) NSString *pluginEnv;

/**
 获取服务端返回的 key 和 host 映射表
 */
@property (nonatomic, copy, readonly) NSDictionary *hostDict;

/**
 包管理类的单例实例，维护基本配置信息，管理 RN 基础包和插件信息

 @return 返回 IMSPackageManager 单例对象
 */
+ (instancetype)defaultManager;

/**
 @brief 更新 RN 基础包和插件资源文件数据
 @discusstion 向服务端请求当前可用的 RN 基础包和插件，使用异步线程下载文件并持久化缓存到本地
 @param error 输入参数有错误时返回的错误信息
 @return YES 表示请求发送成功，NO 表示请求发送失败
 */
- (BOOL)fetchOfflinePackageUpdate:(NSError **)error;

/**
 清空 RN 基础包和插件文件在内存和已持久化的本地缓存
 */
- (void)deleteOfflinePackage;

@end
