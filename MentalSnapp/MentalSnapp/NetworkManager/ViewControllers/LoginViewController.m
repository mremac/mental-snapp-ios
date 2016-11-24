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

@property(weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(strong, nonatomic) NSNotification *notification;

@end

@implementation LoginViewController

#pragma mark - View Life cycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initialSetup];
}

- (void)showOrderScreen:(NSNotification *)bnoti {
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults]boolForKey:kRememberMe]) {
        self.userEmailTextField.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUserEmail];
        self.passwordTextField.text = [[NSUserDefaults standardUserDefaults]valueForKey:kUserPassword];
        self.rememberMeButton.selected = YES;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:kRememberMe]) {
        [self.userEmailTextField becomeFirstResponder];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - IBAction methods

- (IBAction)loginButtonTapped:(id)sender {
    if (self.userEmailTextField.text.length < 1) {
        [Banner showFailureBannerWithSubtitle:@"Enter username"];
    } else if (self.passwordTextField.text.length < 1) {
        [Banner showFailureBannerWithSubtitle:@"Enter password"];
    } else {
        [self.activityIndicator startAnimating];
        
        UserModel *userModel = [[UserModel alloc]initWithUserEmail:self.userEmailTextField.text andPassword:self.passwordTextField.text];
        [[RequestManager alloc] loginWithUserModel:userModel withCompletionBlock:^(BOOL success, id response) {
            if (success){
                [[NSUserDefaults standardUserDefaults]setBool:self.rememberMeButton.selected forKey:kRememberMe];
                [[NSUserDefaults standardUserDefaults]setValue:self.userEmailTextField.text forKey:kUserEmail];
                [[NSUserDefaults standardUserDefaults]setValue:self.passwordTextField.text forKey:kUserPassword];
                
                NSString *userId = (NSString *)response;
                
                NSLog(@"UserId: %@", userId);
                
                [self getUserCall:userId];
                
                NSMutableDictionary *deviceDetailDict = [NSMutableDictionary dictionary];
                //                [[RequestManager alloc] postDeviceDetailWithDataDictionary:deviceDetailDict withCompletionBlock:^(BOOL success, id response) {
                //
                //                }];
            } else {
                [Banner showFailureBannerWithSubtitle:response];
                [self.activityIndicator stopAnimating];
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
//                          [self.activityIndicator stopAnimating];
//                          if (success) {
//                              User *user = (User *)response;
//                              [[Util sharedInstance] saveUser:user];
//                              [self.navigationController dismissViewControllerAnimated:NO completion:nil];
//                          } else {
//                              [self showToastWithText:response on:Failure];
//                          }
//                      }];
}

- (void)openLoginViewController {
    dispatch_async(dispatch_get_main_queue(), ^{

    });
}

- (void)initialSetup {
    self.userEmailTextField.delegate = self;
    self.passwordTextField.delegate = self;
    
    self.titleLabel.text = @"The Evolution of\nDry Cleaning & Laundry";
    
    self.userNameView.layer.cornerRadius = 3;
    self.userNameView.clipsToBounds = YES;
    self.userNameView.layer.borderWidth = 1;
    [self.userNameView.layer setBorderColor:[UIColor colorWithRed:134/255.0f green:134/255.0f blue:134/255.0f alpha:1.0].CGColor];
    
    self.passwordView.layer.cornerRadius = 3;
    self.passwordView.clipsToBounds = YES;
    self.passwordView.layer.borderWidth = 1;
    [self.passwordView.layer setBorderColor:[UIColor colorWithRed:134/255.0f green:134/255.0f blue:134/255.0f alpha:1.0].CGColor];
    
    self.loginButton.layer.cornerRadius = 3;
    
    kLogoTopConstraintDefaultValue = self.logoTopConstraint.constant;
}

#pragma mark Notification Methods

- (void)keyboardWillShow:(NSNotification *)notification {
    _notification = notification;
    UITextField *textField = nil;
    UIView *viewOfTextField = nil;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    if ([self.userEmailTextField isFirstResponder]) {
        textField = self.userEmailTextField;
        viewOfTextField = self.userNameView;
    } else if ([self.passwordTextField isFirstResponder]) {
        textField = self.passwordTextField;
        viewOfTextField = self.passwordView;
    }
    
    CGFloat difference = ( self.view.frame.size.height - keyboardBounds.size.height) - (textField.frame.size.height + viewOfTextField.frame.origin.y) ;
    
    if (difference < 0) {
        //Note: difference is negative so it's added
        self.logoTopConstraint.constant = kLogoTopConstraintDefaultValue + difference - (kLogoTopConstraintDefaultValue - self.logoTopConstraint.constant);
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    _notification = notification;
    [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    self.logoTopConstraint.constant = kLogoTopConstraintDefaultValue;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - TextField Delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if(textField == self.userEmailTextField) {
        [self.passwordTextField becomeFirstResponder];
        [self keyboardWillShow:_notification];
    } else {
        [textField resignFirstResponder];
        [self loginButtonTapped:self.loginButton];
    }
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (self.userNameTextField == textField) {
//        return YES;
//    } else {
//        NSString *modifiedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//        textField.text = modifiedString;
//        return NO;
//    }
//}

@end
