//
//  MSViewController.h
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MSViewController : UIViewController

@property (strong, nonatomic) UIView *touchView;

- (void)setLeftMenuButtons:(NSArray *)barButtons;
- (void)setRightMenuButtons:(NSArray *)barButtons;
- (UIBarButtonItem *)backButton;
- (void)backButtonTapped;
- (void)setNavigationBarButtonTitle:(NSString *)title;

@end
