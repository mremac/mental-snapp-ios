//
//  SignUpViewController.m
//  MentalSnapp
//

#import "SignUpViewController.h"
#import "RequestManager.h"

@interface SignUpViewController () {
    NSInteger selectedGender;
}

@property (nonatomic, strong) UserModel *user;

@property (strong, nonatomic) IBOutlet UITextField *nameTextFeild;
@property (strong, nonatomic) IBOutlet UITextField *emailTextFeild;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@property (strong, nonatomic) IBOutlet UIButton *dateOfBirthButton;
@property (strong, nonatomic) IBOutlet UIButton *maleGenderButton;
@property (strong, nonatomic) IBOutlet UIButton *femaleGenderButton;
@property (strong, nonatomic) IBOutlet UIButton *signUpButton;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *emailFieldview;
@property (strong, nonatomic) IBOutlet UIView *phoneFieldView;
@property (strong, nonatomic) IBOutlet UIView *dateOfBirthView;

@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *datePickerViewBottomConstraint;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.maleGenderButton setSelected:YES];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
}

- (void)keyboardDidHide {
    if (_scrollView.frame.size.height + _scrollView.contentOffset.y > _containerView.frame.size.height) {
        [UIView animateWithDuration:0.3f animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, _containerView.frame.size.height - _scrollView.frame.size.height)];
        }];
    }
}

#pragma mark  - TextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self toolBarCancelButtonAction:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGRect superRect = [textField convertRect:textField.frame toView:_containerView];
    [UIView animateWithDuration:0.3f animations:^{
        //This calculation ensures that the selected textField will be in the upper 3rd part of view
        [self.scrollView setContentOffset:CGPointMake(0, superRect.origin.y - _scrollView.frame.size.height / 3)];
    }];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:self.phoneTextField]){
        return [Util formatePhoneNumberOftextField:textField withRange:range ReplacemenString:string];
    }
    return YES;
}  // return NO to not change text


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:_nameTextFeild]) {
        [_emailTextFeild becomeFirstResponder];
    } else if ([textField isEqual:_emailTextFeild]) {
        [_phoneTextField becomeFirstResponder];
    } else if ([textField isEqual:_phoneTextField]) {
        [_passwordTextField becomeFirstResponder];
    } else if ([textField isEqual:_passwordTextField]) {
        [_confirmPasswordTextField becomeFirstResponder];
    } else if ([textField isEqual:_confirmPasswordTextField]) {
        [_confirmPasswordTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Date picker Selector method
- (void)dateIsChanged:(id)sender{
    [self.dateOfBirthButton setTitle:[NSDate stringFromDate:self.datePicker.date format:@"dd MMM yyyy"] forState:UIControlStateNormal];
}

#pragma mark - Private methods

-(BOOL)isValidateFields {
    if ([self.nameTextFeild.text.trim isEqualToString:@""]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter name."];
        return NO;
    }
    if([self.emailTextFeild.text.trim isEqualToString:@""]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter email."];
        return NO;
    }
    if(![Util isValidEmail:self.emailTextFeild.text]){
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter valid email."];
        return NO;
    }
    if([self.phoneTextField.text.trim isEqualToString:@""]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter phone."];
        return NO;
    }
    if(![Util validatePhone:self.phoneTextField.text]){
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter valid phone."];
        return NO;
    }
    if([[self.dateOfBirthButton titleForState:UIControlStateNormal] isEqualToString:@""]){
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter date of birth."];
        return NO;
    }
    if ([self.passwordTextField.text.trim isEqualToString:@""]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter password."];
        return NO;
    }
    if ([self.confirmPasswordTextField.text.trim isEqualToString:@""]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter confirm password."];
        return NO;
    }
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Password and confirm password fields don't match."];
        return NO;
    }
    return YES;
}

#pragma mark - IBActions

- (IBAction)genderButtonAction:(id)sender {
    selectedGender = [sender tag];
    if([sender tag] == MaleGender){
        self.maleGenderButton.selected = YES;
        self.femaleGenderButton.selected = NO;
    } else {
        self.maleGenderButton.selected = NO;
        self.femaleGenderButton.selected = YES;
    }
}

- (IBAction)signUpButtonTapped:(id)sender {
    if([self isValidateFields]){
        NSString *phoneNumber = self.phoneTextField.text;
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+44" withString:@""];
        phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        UserModel *user = [UserModel new];
        user.userName = self.nameTextFeild.text.trim;
        user.email = self.emailTextFeild.text.trim;
        user.phoneNumber = phoneNumber;
        user.dateOfBirth = self.dateOfBirthButton.titleLabel.text;
        user.gender = [NSString stringWithFormat:@"%@",(selectedGender == MaleGender)?@"male":@"female"];
        user.password = self.passwordTextField.text;
        user.confirmPassword = self.confirmPasswordTextField.text;
        user.phoneCountryCode = @"+44";

        [[RequestManager alloc] signUpWithUserModel:user withCompletionBlock:^(BOOL success, id response) {
            if (success) {
                [[UserManager sharedManager] saveLoggedinUserInfoInUserDefault];
                [UIView transitionWithView:ApplicationDelegate.window
                                  duration:0.5f
                                   options:UIViewAnimationOptionTransitionFlipFromLeft
                                animations:^{
                                    ApplicationDelegate.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:KProfileViewControllerIdentifier]];
                                } completion:nil];
            }
        }];
    }
}

- (IBAction)toolBarCancelButtonAction:(id)sender {
    self.datePickerViewBottomConstraint.constant = -self.dateOfBirthView.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)toolBarDoneButtonAction:(id)sender {
    [self.dateOfBirthButton setTitle:[NSDate stringFromDate:self.datePicker.date format:@"dd MMM yyyy"] forState:UIControlStateNormal];
    self.datePickerViewBottomConstraint.constant = -self.dateOfBirthView.frame.size.width;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)dateOfBirthButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController.navigationBar endEditing:YES];
    self.datePickerViewBottomConstraint.constant = 0;
    [UIView animateWithDuration:0.5 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - IBAction methods

- (IBAction)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
