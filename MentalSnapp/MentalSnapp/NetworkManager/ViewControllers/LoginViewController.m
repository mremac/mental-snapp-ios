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
    } else if (![UserManager isValidEmail:self.userEmailTextField.text.trim]) {
        [Banner showSuccessBannerWithSubtitle:@"Enter valid email"];
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
    
                MainTabBarController *tabBarController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainTabController"];
                ApplicationDelegate.window.rootViewController = tabBarController;
            } else {
                [Banner showFailureBannerWithSubtitle:response];
            }
        }];
    }
}

- (IBAction)signUpButtonTapped:(id)sender {
    [self performSegueWithIdentifier:kGoToSignUp sender:self];
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
//    ForgotPasswordViewController *forgotPasswordViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
//    [self.navigationController pushViewController:forgotPasswordViewController animated:YES];
}

- (IBAction)rememberMeButtonTapped:(id)sender {
    self.rememberMeButton.selected = !self.rememberMeButton.selected;
}

#pragma mark - Private methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGoToSignUp]) {
        
    }
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
