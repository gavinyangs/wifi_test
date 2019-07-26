//
//  AppDelegate.h
//  wifi_test
//
//  Created by Yang Xiong on 23/7/2019.
//  Copyright © 2019 qevdo_Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

