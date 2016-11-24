//
//  Banner.h
//  GlowVita
//
//  Created by Systango on 28/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ALAlertBanner.h"

@interface Banner : NSObject

+ (ALAlertBanner *)showSuccessBannerWithSubtitle:(NSString *)subtitle;
+ (ALAlertBanner *)showSuccessBannerOnTopWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

+ (ALAlertBanner *)showFailureBannerWithSubtitle:(NSString *)subtitle;
+ (ALAlertBanner *)showFailureBannerOnTopWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

+ (ALAlertBanner *)showBannerWithTitle:(NSString *)title subtitle:(NSString *)subtitle style:(ALAlertBannerStyle)style position:(ALAlertBannerPosition)position;

+ (ALAlertBanner *)showNetworkFailureBanner;

@end
