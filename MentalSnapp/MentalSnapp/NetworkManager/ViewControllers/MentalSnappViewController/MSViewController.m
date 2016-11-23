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

@end
