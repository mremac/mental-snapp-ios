//
//  MSViewController.h
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAI.h>
#import <Google/Analytics.h>

@interface MSViewController : UIViewController

@property (strong, nonatomic) UIView *touchView;
- (void)showInProgress:(BOOL)state;

- (void)setLeftMenuButtons:(NSArray *)barButtons;
- (void)setRightMenuButtons:(NSArray *)barButtons;
- (UIBarButtonItem *)backButton;
- (void)backButtonTapped;
- (void)setNavigationBarButtonTitle:(NSString *)title;
- (void)showDefaultIndicatorProgress:(BOOL)state;
@end
