//
//  Banner.m
//  GlowVita
//
//  Created by Systango on 28/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Banner.h"

@implementation Banner

+ (ALAlertBanner *)showSuccessBannerWithSubtitle:(NSString *)subtitle {
    return [self showSuccessBannerOnTopWithTitle:@"Mental Snapp" subtitle:subtitle];
}

+ (ALAlertBanner *)showSuccessBannerOnTopWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    return [self showBannerWithTitle:title subtitle:subtitle style:ALAlertBannerStyleCustomSuccess position:ALAlertBannerPositionTop];
}

+ (ALAlertBanner *)showFailureBannerWithSubtitle:(NSString *)subtitle {
    ALAlertBanner *banner = [self showFailureBannerOnTopWithTitle:@"Mental Snapp" subtitle:subtitle];
    return banner;
}

+ (ALAlertBanner *)showRigidBannerWithSubtitle:(NSString *)subtitle {
    ALAlertBanner *banner = [self showRigidBannerOnTopWithTitle:@"Mental Snapp" subtitle:subtitle];
    return banner;
}

+ (ALAlertBanner *)showFailureBannerOnTopWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    return [self showBannerWithTitle:title subtitle:subtitle style:ALAlertBannerStyleCustomFailure position:ALAlertBannerPositionTop];
}

+ (ALAlertBanner *)showRigidBannerOnTopWithTitle:(NSString *)title subtitle:(NSString *)subtitle {
    return [self showBannerWithTitle:title subtitle:subtitle style:ALAlertBannerStyleCustomRigid position:ALAlertBannerPositionTop];
}

+ (ALAlertBanner *)showBannerWithTitle:(NSString *)title subtitle:(NSString *)subtitle style:(ALAlertBannerStyle)style position:(ALAlertBannerPosition)position
{
    [ALAlertBanner hideAllAlertBanners];
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:ApplicationDelegate.window
                                                        style:style
                                                     position:position
                                                        title:title
                                                     subtitle:subtitle];
    if(style == ALAlertBannerStyleCustomFailure)
        banner.secondsToShow = 3.0f;
    
    if (style == ALAlertBannerStyleCustomRigid) {
        banner.secondsToShow = 0;
    }
    [banner show];
    return banner;
}

+ (ALAlertBanner *)showNetworkFailureBanner
{
    ALAlertBanner *banner = [ALAlertBanner alertBannerForView:ApplicationDelegate.window
                                                        style:ALAlertBannerStyleCustomFailure
                                                     position:ALAlertBannerPositionTop
                                                        title:@"No Network Connection"
                                                     subtitle:@"You have lost your network connection. Please check your connection and try again."];
    banner.secondsToShow = 3.0f;
    [banner show];
    return  banner;
}

+ (void)hideAllBanners {
    [ALAlertBanner hideAllAlertBanners];
}

@end
