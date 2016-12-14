//
//  ForgotPasswordFirstViewController.m
//  MentalSnapp
//

#import "ForgotPasswordFirstViewController.h"
#import "RequestManager.h"

@interface ForgotPasswordFirstViewController () <UITextFieldDelegate>

@property(weak, nonatomic) IBOutlet UITextField *emailTextField;

@end

@implementation ForgotPasswordFirstViewController

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

- (IBAction)submitButtonTapped:(id)sender {
    if([_emailTextField.text.trim isEqualToString:@""]){
        [Banner hideAllBanners];
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter email"];
        return;
    }
    [self.emailTextField resignFirstResponder];
    if ([Util isValidEmail:_emailTextField.text.trim]) {
        [self showInProgress:YES];
        [[RequestManager alloc] forgotPasswordWithEmail:_emailTextField.text.trim withCompletionBlock:^(BOOL success, id response) {
            if (success) {
                [self showPopup];
            }
            [self showInProgress:NO];
        }];
    } else {
        [Banner hideAllBanners];
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter valid email"];
    }
}

#pragma mark - Private methods

- (void)showPopup {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Mental Snapp" message:@"Forgot password link has been sent to your email." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
    [alertController addAction:okAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - TextField delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

@end
