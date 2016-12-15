//
//  VideosViewController.h
//  MentalSnapp
//
//  Created by Systango on 13/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPPopoverController.h"
#import "FPPopoverKeyboardResponsiveController.h"

@interface VideosViewController : MSViewController<FPPopoverControllerDelegate>
{
    FPPopoverKeyboardResponsiveController *popover;
}

-(void)selectedFilter:(FilterModel *)filter;

@end
