//
//  UIApplication+Veromuse.h
//  Skeleton
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Veromuse)

- (void)clearBadgeNumbers;

- (void)resetBadgeNumbers;

- (void)updateBadgeNumbers:(NSInteger)badgeNumber;

- (BOOL)isApplicationActive;

@end
