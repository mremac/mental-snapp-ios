//
//  UIApplication+Veromuse.m
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "UIApplication+Properties.h"

@implementation UIApplication (Veromuse)

- (void)clearBadgeNumbers
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)resetBadgeNumbers
{
    NSInteger badgeNumber = self.applicationIconBadgeNumber;
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}

- (void)updateBadgeNumbers:(NSInteger)badgeNumber
{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:-1];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:badgeNumber];
}


- (BOOL)isApplicationActive
{
    return ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive);
}

@end
