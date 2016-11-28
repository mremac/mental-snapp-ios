 //
//  ProfileViewController.m
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ProfileViewController.h"
#import "RequestManager.h"
#import "ChangePasswordViewController.h"
#import "UserManager.h"

@interface ProfileViewController () <UITextFieldDelegate>
{
    NSInteger selectedGender;
    NSString *profilePicURL;
}
    
@property (strong, nonatomic) IBOutlet UITextField *emailTextFeild;
@property (strong, nonatomic) IBOutlet UIButton *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *dateOfBirthButton;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIButton *maleGenderButton;
@property (strong, nonatomic) IBOutlet UIButton *femaleGenderButton;
@property (strong, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *emailFieldview;
@property (strong, nonatomic) IBOutlet UIView *phoneFieldView;
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UIView *dateOfBirthView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *datePickerViewBottomConstraint;

- (IBAction)genderButtonAction:(id)sender;
- (IBAction)changePasswordButtonAction:(id)sender;
- (IBAction)saveButtonAction:(id)sender;
- (IBAction)toolBarDoneButtonAction:(id)sender;
- (IBAction)dateOfBirthButtonAction:(id)sender;
- (IBAction)addPictureProfileAction:(id)sender;
- (IBAction)deleteProfileAction:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.maleGenderButton setSelected:YES];
    self.user = [UserManager sharedManager].userModel;
    [self setNavigationBarButtonTitle:@"Profile"];
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];
    [self setRightMenuButtons:[NSArray arrayWithObject:[self logoutButtonAction]]];
    //show pre fileld users data
    [self showDataOfUsers];
    [self getUserDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark  - TextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [self toolBarCancelButtonAction:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self.scrollView setContentOffset:(([textField isEqual:self.emailTextFeild])?self.emailFieldview.frame.origin:self.phoneFieldView.frame.origin)];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}  // return NO to not change text

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Date picker Selector method
- (void)dateIsChanged:(id)sender{
    [self.dateOfBirthButton setTitle:[NSDate stringFromDate:self.datePicker.date format:@"MM/dd/yyyy"] forState:UIControlStateNormal];
}

#pragma mark - Private methods

- (UIBarButtonItem *)logoutButtonAction {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 25, 30)];
    [leftButton setImage:[UIImage imageNamed:@"logout"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(logoutButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftBarButton;
}


- (void)getUserDetail {
    [self showInProgress:YES];
    [[RequestManager alloc] getUserDetailWithUserModel:self.user withCompletionBlock:^(BOOL success, id response) {
        if(success){
            self.user = response;
            [self showDataOfUsers];
        }
         [self showInProgress:NO];
    }];
}

-(void)showDataOfUsers {
    if(self.user){
        profilePicURL = self.user.profilePicURL;
        selectedGender = ([self.user.gender caseInsensitiveCompare:@"male"])?0:1;
        [self.userNameLabel setText:self.user.userName];
        [self.emailTextFeild setText:self.user.email];
        [self.dateOfBirthButton setTitle:self.user.dateOfBirth forState:UIControlStateNormal];
        [self.phoneTextField setText:self.user.phoneNumber];
        [self.maleGenderButton setSelected:([self.user.gender caseInsensitiveCompare:@"male"])?YES:NO];
        [self.femaleGenderButton setSelected:([self.user.gender caseInsensitiveCompare:@"male"])?NO:YES];
        [self.profilePictureImageView sd_setImageWithURL:[NSURL URLWithString:self.user.profilePicURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"profile-image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
}

-(BOOL)isValidateFeilds {
    if([self.emailTextFeild.text isEqualToString:@""]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter email."];
        return NO;
    }
    if(![Util isValidEmail:self.emailTextFeild.text]){
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:@"Please enter valid email."];
        return NO;
    }
    if([self.phoneTextField.text isEqualToString:@""]) {
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
    return YES;
}

#pragma mark - IBActions

- (void)logoutButtonTapped {
    [self showInProgress:YES];
    [[RequestManager alloc] userLogoutWithUserModel:self.user withCompletionBlock:^(BOOL success, id response) {
        if(success){
            [[UserManager sharedManager] logoutUser];
        }
        [self showInProgress:NO];
    }];
}


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

- (IBAction)changePasswordButtonAction:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil];
    ChangePasswordViewController *changePasswordScreen = [storyboard instantiateViewControllerWithIdentifier:KChangePasswordViewController];
    [self.navigationController pushViewController:changePasswordScreen animated:YES];
}

- (IBAction)saveButtonAction:(id)sender {
    if([self isValidateFeilds]){
        UserModel *user = [[UserModel alloc] initWithUserId:self.user.userId andEmail:self.emailTextFeild.text andUserName:self.user.userName andPhone:self.phoneTextField.text andGender:[NSString stringWithFormat:@"%@",(selectedGender == MaleGender)?@"male":@"female"] andDateOfBirth:[self.dateOfBirthButton titleForState:UIControlStateNormal] andProfilePic:profilePicURL];
        [self showInProgress:YES];
        [[RequestManager alloc] editUserWithUserModel:user withCompletionBlock:^(BOOL success, id response) {
            if(success){
                [Banner showSuccessBannerWithSubtitle:@"Successfully updated."];
            }
            [self showInProgress:NO];
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
    [self.dateOfBirthButton setTitle:[NSDate stringFromDate:self.datePicker.date format:@"MM/dd/yyyy"] forState:UIControlStateNormal];
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

- (IBAction)addPictureProfileAction:(id)sender {
}

- (IBAction)deleteProfileAction:(id)sender {

    [[RequestManager alloc] userDeactivateWithUserModel:self.user withCompletionBlock:^(BOOL success, id response) {
        if(success){
            [[UserManager sharedManager] logoutUser];
        }
    }];
}

@end
