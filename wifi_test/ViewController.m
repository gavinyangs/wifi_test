//
//  ViewController.m
//  wifi_test
//
//  Created by Yang Xiong on 23/7/2019.
//  Copyright © 2019 qevdo_Company. All rights reserved.
//

#import "ViewController.h"
#import <IMSDeviceCenter/IMLDeviceCenter/IMLDeviceCenter.h>
#import <IMSDeviceCenter/IMLDeviceCenter/IMLCandDeviceModel.h>
#import <IMSApiClient/IMSConfiguration.h>
#import <IMSApiClient/IMSApiClient.h>
#import <ALBBOpenAccountCloud/ALBBOpenAccountSDK.h>
#import <ALBBOpenAccountCloud/ALBBOpenAccountUser.h>
#import <IMSAuthentication/IMSAuthentication.h>
#import <IMSAccount/IMSAccount.h>
#import <IMSInitCode/IMSOpenAccount.h>
#import "LoginViewController.h"

@interface ViewController () <ILKAddDeviceNotifier, ALBBOpenAccountLoginViewDelegate>
@property (nonatomic, strong) IMLAddDeviceBiz *addDeviceBize;
@property (nonatomic, strong) IMLCandDeviceModel *candDeviceModel;
@property (nonatomic, strong) LoginViewController *loginVC;
@property (nonatomic, strong) ALBBOpenAccountLoginViewController *baseController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [IMSConfiguration initWithHost:@"api.link.aliyun.com" serverEnv:IMSServerRelease];
    
    self.addDeviceBize = [[IMLAddDeviceBiz alloc] init];
    self.baseController = [[ALBBOpenAccountLoginViewController alloc] init];


    self.candDeviceModel = [[IMLCandDeviceModel alloc] init];
    self.candDeviceModel.productKey = @"a1jNfGZo5Kc";
    [self.addDeviceBize setDevice:self.candDeviceModel];

    
    UIButton *smartConfigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    smartConfigBtn.frame =  CGRectMake(100, 100, 170, 44);
    smartConfigBtn.backgroundColor = [UIColor redColor];
    [smartConfigBtn setTitle:[NSString stringWithFormat:@"一键配网"] forState:UIControlStateNormal];
    [smartConfigBtn addTarget:self action:@selector(smartConfigOnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:smartConfigBtn];
}

- (void)notifyPrecheck:(BOOL)success withError:(NSError *)err
{
    dispatch_async(dispatch_get_main_queue(), ^{
        //[self inputSsidAndPassword];
        //[self notifyProgress:LKAddStatePrechecking result:nil withError:err];
    });
}

- (void)inputSsidAndPassword {
    NSString *ssid = @"QEVDO_2G4";
    NSString *password = @"DL123456789";
    int timeout = 60;
    [self.addDeviceBize toggleProvision:ssid pwd:password timeout:timeout];
}

- (void)notifyProvisionPrepare:(LKPUserGuideCode)guideCode {
   
    if(guideCode == LKPGuideCodeOnlyInputPwd){
        NSLog(@"_________ lkpuserguidecode is %ld", guideCode);
        [self inputSsidAndPassword];
        // TODO:一键广播配网相关引导
    } else if(guideCode == LKPGuideCodeWithUserGuide){
        // TODO:热点配网相关引导
    }
}

- (void)notifyProvisioning {
    NSLog(@"配网方式获取 %ld", [self.addDeviceBize getProcedureState]);
}

- (void)notifyProvisionResult:(IMLCandDeviceModel *)candDeviceModel withProvisionError:(NSError *)provisionError {
    NSLog(@"返回配网结果后的配网方式 %ld", [self.addDeviceBize getProcedureState]);
    NSLog(@"配网结果 %@  错误结果是 %@", candDeviceModel, provisionError);
}

- (void)smartConfigOnClick:(UIButton *)sender {
    /* 以下注释的代码是 API 通道初始化陈宫之后，我开始进行配网，遵守配网的代理协议，之前测试是没有验证用户是否登录成功，直接触发 button 的 click 事件进行配网 */
    [self.addDeviceBize setAliProvisionMode:ForceAliLinkTypeBroadcast];
    [self.addDeviceBize startAddDevice:self];

    /* 以下注释的代码是初始化登录系统 */
//    IMSAccountService *accountService = [IMSAccountService sharedService];
//    IMSOpenAccount *openAccount = [IMSOpenAccount sharedInstance];
//    [IMSAccountService sharedService].sessionProvider = openAccount;
//    [IMSAccountService sharedService].accountProvider = openAccount;
//
//    [IMSCredentialManager initWithAccountProtocol:accountService.sessionProvider];
//    IMSIoTAuthentication *iotAuthDelegate = [[IMSIoTAuthentication alloc] initWithCredentialManager:IMSCredentialManager.sharedManager];
//    [IMSRequestClient registerDelegate:iotAuthDelegate forAuthenticationType:IMSAuthenticationTypeIoT];
    
    /* 以下代码就看不懂了，尤其是 presentLoginViewController 函数中的第一个参数，我不知道调用那个 VC */
//     //获取账号UI服务
//    id<ALBBOpenAccountUIService> uiService = ALBBService(ALBBOpenAccountUIService);
//    // 显示登录窗口
//    [uiService presentLoginViewController:self.baseController success:^(ALBBOpenAccountSession *currentSession) {
//
//        // 登录成功之后，直接调用设备配网的代理事件
//        [self.addDeviceBize setAliProvisionMode:ForceAliLinkTypeBroadcast];
//        [self.addDeviceBize startAddDevice:self];
//
//        // 登录成功，currentSession为当前会话信息
//        // 获取当前会话标识
//        NSLog(@"sessionId:%@", currentSession.sessionID);
//        // 获取当前用户信息
//        ALBBOpenAccountUser *currentUser = [currentSession getUser];
//        NSLog(@"mobile:%@", [currentUser mobile]);
//        NSLog(@"avatarUrl:%@", [currentUser avatarUrl]);
//        NSLog(@"accountId:%@", [currentUser accountId]);
//        NSLog(@"displayName:%@", [currentUser displayName]);
//    } failure:^(NSError *error) {
//        // 登录失败对应的错误；取消登录同样会返回一个错误码
//    }];
    
}

@end
