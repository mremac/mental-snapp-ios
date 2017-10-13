//.
//  AppDelegate.h
//  Skeleton
//
//  Created by Systango on 25/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MainTabBarController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainTabBarController *tabBarController;

- (BOOL)hasNetworkAvailable;

@end

