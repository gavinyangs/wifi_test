//
//  BoneRCTViewController.h
//  IMSBoneKit
//
//  Created by Aliyun on 2017/11/30.
//  Copyright © 2017年 Aliyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoneRCTContext;

/**
 Bone 容器的 UIViewController
 */
@interface BoneRCTViewController : UIViewController

/**
 封装了运行 Bone 容器的基本组件
 */
@property (nonatomic, readonly) BoneRCTContext *boneContext;

/**
 打开一个 UIViewController，运行 Bone 插件
 
 @param url 插件资源文件的 CDN 地址
 @param props 用户自定义参数
 */
- (void)openUrl:(NSURL *)url props:(NSDictionary *)props;

@end
