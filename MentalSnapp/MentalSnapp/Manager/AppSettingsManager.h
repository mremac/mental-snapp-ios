//
//  AppSettingsManager.h
//  Skeleton
//
//  Created by Systango on 06/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AppSettings;

@interface AppSettingsManager : NSObject

@property (nonatomic, strong) AppSettings *appSettings;

+ (AppSettingsManager *)sharedInstance;
- (AppSettings *)fetchSettings;

@end
