//
//  ProfileViewController.m
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ProfileViewController.h"
#import "RequestManager.h"
#import "ChangePasswordViewController.h"

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

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.datePicker addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
    [self.maleGenderButton setSelected:YES];
    
    //show pre fileld users data
    [self showDataOfUsers];
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

-(void)showDataOfUsers {
    if(self.user){
        profilePicURL = self.user.profilePicURL;
        selectedGender = ([self.user.gender isEqualToString:@"1"])?0:1;
        [self.userNameLabel setText:self.user.userName];
        [self.emailTextFeild setText:self.user.email];
        [self.dateOfBirthButton setTitle:self.user.dateOfBirth forState:UIControlStateNormal];
        [self.phoneTextField setText:self.user.phoneNumber];
        [self.maleGenderButton setSelected:([self.user.gender isEqualToString:@"0"])?YES:NO];
        [self.femaleGenderButton setSelected:([self.user.gender isEqualToString:@"0"])?NO:YES];
        [self.profilePictureImageView sd_setImageWithURL:[NSURL URLWithString:self.user.profilePicURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    }
}

-(BOOL)isValidateFeilds {
    if([self.emailTextFeild.text isEqualToString:@""]) {
        return NO;
    }
    if(![Util isValidEmail:self.emailTextFeild.text]){
        return NO;
    }
    if([self.phoneTextField.text isEqualToString:@""]) {
        return NO;
    }
    if(![Util validatePhone:self.phoneTextField.text]){
        return NO;
    }
    if([[self.dateOfBirthButton titleForState:UIControlStateNormal] isEqualToString:@""]){
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

- (IBAction)changePasswordButtonAction:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil];
    ChangePasswordViewController *changePasswordScreen = [storyboard instantiateViewControllerWithIdentifier:KChangePasswordViewController];
    [self presentViewController:changePasswordScreen animated:YES completion:nil];
}

- (IBAction)saveButtonAction:(id)sender {
    if([self isValidateFeilds]){
        UserModel *user = [[UserModel alloc] initWithUserId:self.user.userId andEmail:self.emailTextFeild.text andUserName:self.user.userName andPhone:self.phoneTextField.text andGender:[NSString stringWithFormat:@"%ld",(long)selectedGender] andDateOfBirth:[self.dateOfBirthButton titleForState:UIControlStateNormal] andProfilePic:profilePicURL];
        
        [[RequestManager alloc] editUserWithUserModel:user withCompletionBlock:^(BOOL success, id response) {
            
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

@end
