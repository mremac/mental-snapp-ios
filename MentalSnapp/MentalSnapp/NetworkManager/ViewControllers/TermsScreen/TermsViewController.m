//
//  TermsViewController.m
//  MentalSnapp
//

#import "TermsViewController.h"

@interface TermsViewController ()

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.navigationController != nil) {
        self.navigationController.navigationBar.hidden = NO;
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    if (self.navigationController != nil) {
        self.navigationController.navigationBar.hidden = self.tabBarController == nil;
    }
}

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Terms and Conditions"];
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
}

@end
