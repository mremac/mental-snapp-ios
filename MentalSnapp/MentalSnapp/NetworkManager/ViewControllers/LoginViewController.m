//
//  LoginViewController.m
//  MentalSnapp
//

#import "LoginViewController.h"
#import "RequestManager.h"
#import "WelcomeBackViewController.h"

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
    [[UIApplication sharedApplication] setStatusBarHidden:YES
                                            withAnimation:UIStatusBarAnimationFade];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kRememberMe]) {
        self.userEmailTextField.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUserEmail];
        self.passwordTextField.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUserPassword];
        self.rememberMeButton.selected = YES;
    } else if ([UserManager sharedManager].userModel.email.trim.length != 0) {
        _userEmailTextField.text = [UserManager sharedManager].userModel.email;
    }
    [UserDefaults setBool:NO forKey:kIsUserLoggedIn];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

#pragma mark - IBAction methods

- (IBAction)loginButtonTapped:(id)sender {
    if (self.userEmailTextField.text.length < 1) {
        [Banner showSuccessBannerWithSubtitle:LocalizedString(@"LoginScreenEmailMessage")];
    } else if (![UserManager isValidEmail:self.userEmailTextField.text.trim]) {
        [Banner showSuccessBannerWithSubtitle:LocalizedString(@"LoginScreenValidEmailMessage")];
    } else if (self.passwordTextField.text.length < 1) {
        [Banner showSuccessBannerWithSubtitle:LocalizedString(@"LoginScreenPasswordMessage")];
    } else {
        [ALAlertBanner hideAllAlertBanners];
    
        [self showInProgress:YES];
        UserModel *userModel = [[UserModel alloc]initWithUserEmail:self.userEmailTextField.text andPassword:self.passwordTextField.text];
        [[RequestManager alloc] loginWithUserModel:userModel withCompletionBlock:^(BOOL success, id response) {
            [self showInProgress:NO];
            if (success){
                [UserDefaults setBool:self.rememberMeButton.selected forKey:kRememberMe];
                [UserDefaults setValue:self.userEmailTextField.text forKey:kUserEmail];
                [UserDefaults setValue:self.passwordTextField.text forKey:kUserPassword];
                [UserDefaults setBool:YES forKey:kIsUserLoggedIn];
                [UserDefaults synchronize];
    
                if ([UserManager sharedManager].isFirstTime) {
                    [UIView transitionWithView:ApplicationDelegate.window
                                      duration:0.5f
                                       options:UIViewAnimationOptionTransitionFlipFromLeft
                                    animations:^{
                                        ApplicationDelegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:KProfileViewControllerIdentifier]];
                                    } completion:nil];
                } else {
                    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    [self.navigationController pushViewController:[mainStoryboard instantiateViewControllerWithIdentifier:@"WelcomeBackViewController"] animated:YES];
                }
            } 
        }];
    }
}

- (IBAction)signUpButtonTapped:(id)sender {
    [self performSegueWithIdentifier:kGoToSignUp sender:self];
}

- (IBAction)forgotPasswordButtonTapped:(id)sender {
    [self performSegueWithIdentifier:kGoToForgotPasswordFirstScreen sender:self];
}

- (IBAction)rememberMeButtonTapped:(id)sender {
    self.rememberMeButton.selected = !self.rememberMeButton.selected;
}

#pragma mark - Private methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:kGoToSignUp]) {
        segue.destinationViewController.navigationController.navigationBar.hidden = NO;
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
