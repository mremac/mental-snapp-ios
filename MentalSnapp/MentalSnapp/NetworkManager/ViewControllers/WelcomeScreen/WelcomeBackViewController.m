//
//  WelcomeBackViewController.m
//  MentalSnapp
//
//  Created by stplmacmini11 on 04/01/17.
//  Copyright © 2017 Systango. All rights reserved.
//

#import "WelcomeBackViewController.h"

@interface WelcomeBackViewController ()

@property(weak, nonatomic) IBOutlet UILabel *welcomeBackLabel;
@property(weak, nonatomic) IBOutlet UIView *welcomeView;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;
@property(weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation WelcomeBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *userName = [UserManager sharedManager].userModel.userName;
    _welcomeBackLabel.text = [NSString stringWithFormat:@"Welcome back\n%@!!",userName];
    
    UIFont *boldFont = [UIFont fontWithName:@"Helvetica Neue" size:27.0f];
    NSMutableAttributedString *attText = [[NSMutableAttributedString alloc] initWithString:_welcomeBackLabel.text];
    [attText addAttribute:NSFontAttributeName value:boldFont range:[_welcomeBackLabel.text rangeOfString:userName]];
//    [attText addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:[_welcomeBackLabel.text rangeOfString:userName]];
    _welcomeBackLabel.attributedText = attText;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self animateWelcomeView];
}

- (IBAction)tapToContinue:(id)sender {
    ApplicationDelegate.tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabController"];
    ApplicationDelegate.window.rootViewController = ApplicationDelegate.tabBarController;
}

- (void)animateWelcomeView {
    self.widthConstraint.constant = 400;
    self.heightConstraint.constant = 400;
    
    [UIView animateWithDuration:2.f animations:^{
        [self.view layoutIfNeeded];
    }];
}

@end
