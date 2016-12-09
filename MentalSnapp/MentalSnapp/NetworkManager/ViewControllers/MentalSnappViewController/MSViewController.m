//
//  MSViewController.m
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"
#import "ProfileViewController.h"

@interface MSViewController() <UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@implementation MSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIGestureRecognizer *viewTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    viewTapGestureRecognizer.delegate = self;
    viewTapGestureRecognizer.cancelsTouchesInView = FALSE;
    [self.view addGestureRecognizer:viewTapGestureRecognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ( ![touch.view isKindOfClass:[UIControl class]] && ![touch.view isKindOfClass:[UITextField class]] &&  ![touch.view isKindOfClass:[UITextView class]]) {
        self.touchView = touch.view;
        [self endEditing];
    }
    return true;
}

- (void)endEditing {
    [self.view endEditing:YES];
    [self.navigationController.navigationBar endEditing:YES];
}

#pragma mark - Navigation property setters

- (void)setLeftMenuButtons:(NSArray *)barButtons {
    self.navigationItem.leftBarButtonItems = barButtons;
}

- (void)setRightMenuButtons:(NSArray *)barButtons {
    self.navigationItem.rightBarButtonItems = barButtons;
}

- (UIBarButtonItem *)backButton {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 25, 30)];
    [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(backButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftBarButton;
}

- (void)backButtonTapped {
    if([self isKindOfClass:[ProfileViewController class]]){
        if([ApplicationDelegate.window.rootViewController isKindOfClass:[UINavigationController class]]){
            UINavigationController *navController = (UINavigationController *)ApplicationDelegate.window.rootViewController;
            NSArray *array = navController.viewControllers;
            if(array.count>0 && [[array firstObject] isKindOfClass:[ProfileViewController class]]) {
                [[UserManager sharedManager] setValueInLoggedInUserObjectFromUserDefault];
                MainTabBarController *tabBarController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabController"];
                ApplicationDelegate.window.rootViewController = tabBarController;
            } else {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)setNavigationBarButtonTitle:(NSString *)title
{
    UIButton* centralButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    [centralButton setTitle:title forState:UIControlStateNormal];
    [centralButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:18.0f]];
    [centralButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    centralButton.userInteractionEnabled = NO;
    [centralButton addTarget:self action:@selector(centerTitleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:15/255.f green:175/255.f blue:199/255.f alpha:1.f];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance]  setTranslucent:NO];
    self.navigationItem.titleView = centralButton;
    
}

- (void)centerTitleButtonTapped {
}

#pragma mark - Public Methods

- (void)showInProgress:(BOOL)state {
    if(state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JTProgressHUD show];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [JTProgressHUD hide];
        });
    }
}

- (void)showDefaultIndicatorProgress:(BOOL)state {
    if(state) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator startAnimating];
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.activityIndicator stopAnimating];
        });
    }
}


@end
