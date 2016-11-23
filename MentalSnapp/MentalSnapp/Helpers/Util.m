//
//  Util.m
//  Skeleton
//
//  Created by Systango on 31/05/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Util.h"
#import "NSUserDefaults+RMSaveCustomObject.h"

@implementation Util

+ (void)postNotification:(NSString *)name withDict:(NSDictionary *)dict
{
    NSNotification *notif = [NSNotification notificationWithName:name
                                                          object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

+ (void)saveCustomObject:(id)object toUserDefaultsForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults rm_setCustomObject:object forKey:key];
}

+ (id)fetchCustomObjectForKey:(NSString *)key
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    return [defaults rm_customObjectForKey:key];
}

@end