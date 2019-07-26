//
//  IMSBonePackagePlugin.h
//  BonePluginKit
//
//  Created by dujin on 2017/11/7.
//  Copyright © 2017年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>


@class BoneBaseSDKModel;
@class BonePluginModel;

extern NSString * const kBPKBoneMobileConfigKey;
extern NSString * const kBPKBoneMobilePluginKey;

/**
 Bone 管理协议，运行 Bone 容器实例时需查询当前可用的 RN 基础包列表和插件信息
 */
@protocol BonePackagePluginProtocol <NSObject>

@required


/**
 查询当前可用的 RN 基础包列表

 @param completion 返回可用的 RN 基础包列表
 */
- (void)queryBoneBaseSDKs:(void (^)(NSArray<BoneBaseSDKModel *> *sdks))completion;

/**
 @brief 查询对应插件的基本信息
 @discusstion 只会从当前离线包维护的内存里查询插件基本信息
 @param code 资源ID
 @param params 用户自定义参数
 @return 返回 BonePluginModel 实例
 */
- (BonePluginModel *)queryBonePluginInMemoryWithCode:(NSString *)code
                                              params:(NSDictionary *)params;

/**
 @brief 查询对应插件的基本信息
 @discusstion 先在当前离线包维护的内存里查询，如果查不到会向服务端发送单补请求查询插件信息
 @param uri 资源查询协议
 @param params 用户自定义参数
 @param completion 插件对象 BonePluginModel 及其 JSON 格式数据
 */
- (void)queryBonePluginWithURI:(NSString *)uri
                        params:(NSDictionary *)params
                    completion:(void (^)(BonePluginModel *plugin, NSDictionary *props))completion;

/**
 @brief 查询插件的配置
 @discusstion 先在当前内存里查询配置，如果查不到会向服务端发送查询请求
 @param params 参数格式为 {@"cid": pluginID}
 @param completion 异常信息 NSError 及 JSON 格式的插件配置
 */
- (void)queryPluginConfigWithParams:(NSDictionary *)params
                         completion:(void (^)(NSError *, NSDictionary *config))completion;

@end



/**
 运行 Bone 时需加载的 RN 基础包信息
 */
@interface BoneBaseSDKModel : NSObject

/**
 基础包版本号，格式为"xx.xx.xx"
 */
@property (nonatomic, strong) NSString *version;

/**
 基础包运行环境，在 Bone 容器中的值是 "bone-aep-rn"
 */
@property (nonatomic, strong) NSString *runtime;

/**
 基础包的URL地址
 */
@property (nonatomic, strong) NSString *url;

/**
 基础包压缩文件的URL地址，离线包会提前把该压缩文件下载到本地
 */
@property (nonatomic, strong) NSString *zipUrl;


/**
 @brief 对比运行 Bone 时加载的 RN 基础包版本号
 @discusstion 基础包版本号格式为"xx.xx.xx"
 @param model RN 基础包对象
 @return 返回 NSComparisonResult 来表示比较结果，NSOrderedAscending 表示对象 model 的版本号大，NSOrderedAscending 表示相同，NSOrderedDescending 表示对象 model 的版本号小
 */
- (NSComparisonResult)versionCompare:(BoneBaseSDKModel *)model;

@end

/**
 运行 Bone 时需加载的插件信息
 */
@interface BonePluginModel : NSObject

/**
 插件的ID标识
 */
@property (nonatomic, strong) NSString *pId;

/**
 当前插件的API版本信息
 */
@property (nonatomic, assign) NSInteger apiLevel;

/**
 插件的配置ID标识
 */
@property (nonatomic, strong) NSString *cfgID;

/**
 插件运行环境，在 Bone 容器中的值是 "bone-aep-rn"
 */
@property (nonatomic, strong) NSString *runtime;

/**
 插件版本号，格式为"xx.xx.xx"
 */
@property (nonatomic, strong) NSString *version;

/**
 插件运行所需 RN 基础包的版本号，格式为"xx.xx.xx"
 */
@property (nonatomic, strong) NSString *sdkVersion;

/**
 插件的URL地址
 */
@property (nonatomic, strong) NSString *url;

/**
 插件压缩文件的URL地址，离线包会提前把该压缩文件下载到本地
 */
@property (nonatomic, strong) NSString *zipUrl;

@end


/**
 @brief 往 Bone 容器注册实现 BonePackagePluginProtocol 协议的对象
 @discusstion Bone 容器会从 plugin 查询 RN 基础包信息和插件信息
 @param plugin 实现 BonePackagePluginProtocol 协议的对象
 @return YES 表示注册成功，NO 表示注册失败
 */
extern BOOL InstallBonePackagePlugin(id<BonePackagePluginProtocol>plugin);

