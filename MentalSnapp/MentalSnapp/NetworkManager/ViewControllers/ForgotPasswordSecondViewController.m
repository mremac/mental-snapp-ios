//
//  ForgotPasswordSecondViewController.m
//  MentalSnapp
//

#import "ForgotPasswordSecondViewController.h"

@interface ForgotPasswordSecondViewController () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property(weak, nonatomic) IBOutlet UITextField *reEnterPasswordTextField;

@end

@implementation ForgotPasswordSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initialSetup {
    [self setNavigationBarButtonTitle:@"Forgot Password"];
    [self setLeftMenuButtons:[NSArray arrayWithObject:self.backButton]];
}

#pragma mark - IBAction methods

- (IBAction)saveButtonTapped:(id)sender {
    if (![_passwordTextField.text isEqualToString:_reEnterPasswordTextField.text]) {
        [Banner showSuccessBannerWithSubtitle:@"Enter same values in both fields."];
    } else {
        
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([_passwordTextField isFirstResponder]) {
        [_reEnterPasswordTextField becomeFirstResponder];
    } else if ([_reEnterPasswordTextField isFirstResponder]) {
        [self.view endEditing:YES];
    }
    return YES;
}

@end
