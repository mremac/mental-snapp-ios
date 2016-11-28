//
//  MSViewController.m
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"

@interface MSViewController() <UIGestureRecognizerDelegate>

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
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNavigationBarButtonTitle:(NSString *)title
{
    UIButton* centralButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 44)];
    [centralButton setTitle:title forState:UIControlStateNormal];
    [centralButton.titleLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:16.0f]];
    [centralButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    centralButton.userInteractionEnabled = NO;
    [centralButton addTarget:self action:@selector(centerTitleButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:16/255.f green:166/255.f blue:192/255.f alpha:1.f];
    self.navigationItem.titleView = centralButton;
    
}

- (void)centerTitleButtonTapped {
}

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

@end
