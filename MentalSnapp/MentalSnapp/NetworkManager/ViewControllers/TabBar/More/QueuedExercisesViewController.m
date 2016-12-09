//
//  QueuedExercisesViewController.m
//  MentalSnapp
//

#import "QueuedExercisesViewController.h"

@interface QueuedExercisesViewController ()

@end

@implementation QueuedExercisesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarButtonTitle:@"Queued Excercises"];
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.tabBarController) {
        self.tabBarController.tabBar.hidden = NO;
    }
}

@end
