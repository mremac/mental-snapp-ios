//
//  AppSettingsManager.m
//  Skeleton
//
//  Created by Systango on 06/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "AppSettingsManager.h"

@implementation AppSettingsManager

+ (AppSettingsManager *)sharedInstance
{
    static AppSettingsManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (AppSettings *)fetchSettings
{
    // Find out the path of AppSettings.plist
    NSString *path = [[NSBundle mainBundle] pathForResource:kPlistFileName ofType:@"plist"];
    
    // Load the file content and initialise the AppSettings obj.
    NSDictionary *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    
   self.appSettings = [[AppSettings alloc] initWithDictionary:dict error:nil];
    
    NSLog([NSString stringWithFormat:@"%@", self.appSettings]);
    
    return self.appSettings;    
}

@end
