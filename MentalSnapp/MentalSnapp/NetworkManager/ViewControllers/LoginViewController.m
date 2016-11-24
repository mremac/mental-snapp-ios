//
//  LoginViewController.m
//  MentalSnapp
//

#import "LoginViewController.h"
#import "RequestManager.h"
//#import "ForgotPasswordViewController.h"

@interface LoginViewController() <UITextFieldDelegate> {
    NSInteger kLogoTopConstraintDefaultValue;
    CGRect keyboardBounds;
}

@property(weak, nonatomic) IBOutlet UILabel *titleLabel;
@property(weak, nonatomic) IBOutlet UIView *userNameView;
@property(weak, nonatomic) IBOutlet UIView *passwordView;
@property(weak, nonatomic) IBOutlet UIButton *loginButton;
@property(weak, nonatomic) IBOutlet UIButton *rememberMeButton;

@property(weak, nonatomic) IBOutlet UITextField *userEmailTextField;
@property(weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property(weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConstraint;

@end

@implementation LoginViewController

#pragma mark - View Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kRememberMe]) {
        self.userEmailTextField.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUserEmail];
        self.passwordTextField.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUserPassword];
        self.rememberMeButton.selected = YES;
    }
}

#pragma mark - IBAction methods

- (IBAction)loginButtonTapped:(id)sender {
    if (self.userEmailTextField.text.length < 1) {
        [Banner showSuccessBannerWithSubtitle:@"Enter email"];
    } else if (self.passwordTextField.text.length < 1) {
        [Banner showSuccessBannerWithSubtitle:@"Enter password"];
    } else {
        
        UserModel *userModel = [[UserModel alloc]initWithUserEmail:self.userEmailTextField.text andPassword:self.passwordTextField.text];
        [[RequestManager alloc] loginWithUserModel:userModel withCompletionBlock:^(BOOL success, id response) {
            if (success){
                [UserDefaults setBool:self.rememberMeButton.selected forKey:kRememberMe];
                [UserDefaults setValue:self.userEmailTextField.text forKey:kUserEmail];
                [UserDefaults setValue:self.passwordTextField.text forKey:kUserPassword];
                [UserDefaults setBool:YES forKey:kIsUserLoggedIn];
                [UserDefaults synchronize];
                
//                [self getUserCall:userId];
                
//                NSMutableDictionary *deviceDetailDict = [NSMutableDictionary dictionary];
                //                [[RequestManager alloc] postDeviceDetailWithDataDictionary:deviceDetailDict withCompletionBlock:^(BOOL success, id response) {
                //
                //                }];
            } else {
                [Banner showFailureBannerWithSubtitle:response];
            }
        }];
    }
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
//    ForgotPasswordViewController *forgotPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
//    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}

- (IBAction)rememberMeButtonTapped:(id)sender {
    self.rememberMeButton.selected = !self.rememberMeButton.selected;
}

#pragma mark - Private methods

- (void)getUserCall:(NSString *)userID {
//    [[RequestManager alloc] getUserWithID:userID
//                      withCompletionBlock:^(BOOL success, id response) {
//                          if (success) {
//                              User *user = (User *)response;
//                              [[Util sharedInstance] saveUser:user];
//                              [self.navigationController dismissViewControllerAnimated:NO completion:nil];
//                          } else {
//                              [self showToastWithText:response on:Failure];
//                          }
//                      }];
}

#pragma mark - TextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.userEmailTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else {
        [textField resignFirstResponder];
        [self loginButtonTapped:self.loginButton];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
