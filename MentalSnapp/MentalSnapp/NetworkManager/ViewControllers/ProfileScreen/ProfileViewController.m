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
#import "PickerViewController.h"

@interface ProfileViewController () <UITextFieldDelegate, PickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSInteger selectedGender;
    NSString *profilePicURL;
    NSDate *selectedDate;
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
@property (strong, nonatomic) PickerViewController *pickerViewController;
@property (strong, nonatomic) UIImage *userImage;

- (IBAction)genderButtonAction:(id)sender;
- (IBAction)changePasswordButtonAction:(id)sender;
- (IBAction)saveButtonAction:(id)sender;
- (IBAction)addPictureProfileAction:(id)sender;
- (IBAction)deleteProfileAction:(id)sender;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.maleGenderButton setSelected:YES];
    [[UserManager sharedManager] setValueInLoggedInUserObjectFromUserDefault];
    self.user = [UserManager sharedManager].userModel;
    [self setNavigationBarButtonTitle:@"Profile"];
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];
    [self setRightMenuButtons:[NSArray arrayWithObject:[self logoutButtonAction]]];
    //show pre fileld users data
    [self showDataOfUsers];
    [self getUserDetail];
    self.pickerViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kPickerViewController];
    self.pickerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.pickerViewController setPickerType:dateOnly];
    [self.pickerViewController setDelegate:self];
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
    //[self toolBarCancelButtonAction:nil];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    CGPoint point = (([textField isEqual:self.emailTextFeild])?self.emailFieldview.frame.origin:self.phoneFieldView.frame.origin);
    point.y = point.y+20;
    [self.scrollView setContentOffset:point];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if([textField isEqual:self.phoneTextField]){
        return [Util formatePhoneNumberOftextField:textField withRange:range ReplacemenString:string];
    }
    
    return YES;
}  // return NO to not change text

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
        NSMutableString *phoneNumber = [NSMutableString stringWithString:self.user.phoneNumber] ;
        [phoneNumber insertString:@" " atIndex:0];
        [phoneNumber insertString:@" " atIndex:5];
        [self.phoneTextField setText:phoneNumber];
        [self.maleGenderButton setSelected:([self.user.gender caseInsensitiveCompare:@"male"])?YES:NO];
        [self.femaleGenderButton setSelected:([self.user.gender caseInsensitiveCompare:@"male"])?NO:YES];
        [self displayProfileImageFromURL];
        selectedDate = [NSDate dateFromString:self.user.dateOfBirth format:@"yyyy-MM-dd"];
        [self.dateOfBirthButton setTitle:[NSDate stringFromDate:selectedDate format:@"dd MMM yyyy"] forState:UIControlStateNormal];
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

- (void)willPerformUpdateUserDetailsAPICall
{
    [self showInProgress:YES];
    if(self.userImage)
    {
        [[[Util alloc] init] didFinishPickingImageFile:self.userImage fileType:ImageProfile completionBlock:^(BOOL success, id response)
         {
             NSLog([NSString stringWithFormat:@"response : : %@", response]);
             if(success)
             {
                 AppSettings *appSettings = [AppSettingsManager sharedInstance].appSettings;
                 NSString *bucketName = ([appSettings.NetworkMode isEqualToString:kLiveEnviroment]) ? kLiveProfileImageBucket : kStagingProfileImageBucket;
                 profilePicURL = [NSString stringWithFormat:@"https://s3-eu-west-1.amazonaws.com/%@/%@", bucketName, response];
                 [self didPerformUpdateUserDetailsAPICall];
             }
             else
             {
                 [Banner showFailureBannerWithSubtitle:@"Image could not be uploaded. Please try again"];
                 [self removeProfileImage];
                 [self showInProgress:NO];
             }
         }];
    }
    else
    {
        [self didPerformUpdateUserDetailsAPICall];
    }
}

- (void)didPerformUpdateUserDetailsAPICall
{
    NSString *phoneNumber = self.phoneTextField.text;
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"+44" withString:@""];
    phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    UserModel *user = [[UserModel alloc] initWithUserId:self.user.userId andEmail:self.emailTextFeild.text andUserName:self.user.userName andPhone:phoneNumber andGender:[NSString stringWithFormat:@"%@",(selectedGender == MaleGender)?@"male":@"female"] andDateOfBirth:[self.dateOfBirthButton titleForState:UIControlStateNormal] andProfilePic:profilePicURL];
    
    [[RequestManager alloc] editUserWithUserModel:user withCompletionBlock:^(BOOL success, id response) {
        if(success)
        {
            [[UserManager sharedManager] updateProfileURL:profilePicURL];
            self.userImage = nil;
            [self backButtonTapped];
            [Banner showSuccessBannerWithSubtitle:@"Successfully updated."];
        }
        [self showInProgress:NO];
    }];
}


-(void)displayProfileImageFromURL
{
    if(profilePicURL.length > 0)
    {
        [self.profilePictureImageView sd_setImageWithURL:[NSURL URLWithString:profilePicURL] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"profile-image"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [self.profilePictureImageView setClipsToBounds:YES];
        }];
    }
    else
    {
        [self.profilePictureImageView setImage:[UIImage imageNamed:@"profile-image"] forState:UIControlStateNormal];
    }
}

- (void)performImageChangeAction
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *alertActionGallery = [UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhoto:Gallery];
    } ];
    UIAlertAction *alertActionCamera = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self selectPhoto:Camera];
    }];
    UIAlertAction *alertActionCancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    if(self.userImage || profilePicURL.trim.length > 0)
    {
        UIAlertAction *alertActionDeleteImage = [UIAlertAction actionWithTitle:@"Delete Photo" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            [self selectPhoto:DeleteImage];
        }];
        
        [alertController addAction:alertActionDeleteImage];
    }
    
    [alertController addAction:alertActionGallery];
    [alertController addAction:alertActionCamera];
    [alertController addAction:alertActionCancel];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)removeProfileImage
{
    profilePicURL = kEmptyString;
    self.userImage = nil;
    [self.profilePictureImageView setImage:[UIImage imageNamed:@"profile-image"] forState:UIControlStateNormal];
}

#pragma mark - ImagePicker Delegate Method

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.userImage = info[UIImagePickerControllerEditedImage];
    CGSize profileImageSize = CGSizeMake(self.profilePictureImageView.frame.size.width * 3, self.profilePictureImageView.frame.size.height * 3);
    self.userImage = [self.userImage imageByScalingProportionallyToSize:profileImageSize withPriority:PriorityWidth];
    if (self.userImage)
    {
        [self.profilePictureImageView setImage:self.userImage forState:UIControlStateNormal];
    }
    else
    {
        [self.profilePictureImageView setImage:[UIImage imageNamed:@"profile-image"] forState:UIControlStateNormal];
    }
    
    [self.profilePictureImageView setClipsToBounds:YES];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)selectPhoto:(ImagePickerType)type
{
    if(type == Camera && (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]))
    {
        return;
    }
    else if (type == DeleteImage)
    {
        [self removeProfileImage];
    }
    else
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.allowsEditing = YES;
        picker.delegate = self;
        if (type == Gallery)
        {
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        else if (type == Camera) {
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        
        [picker setMediaTypes:[NSArray arrayWithObjects:(NSString *)kUTTypeImage, nil]];
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

#pragma mark - Date Picker view Delegate
- (void)didSelectDoneButton:(NSDate *)date {
    selectedDate = date;
    [self.dateOfBirthButton setTitle:[NSDate stringFromDate:date format:@"dd MMM yyyy"] forState:UIControlStateNormal];
}
- (void)didSelectCancelButton {
    selectedDate = [NSDate dateFromString:self.user.dateOfBirth format:@"yyyy-dd-MM"];
    [self.dateOfBirthButton setTitle:[NSDate stringFromDate:selectedDate format:@"dd MMM yyyy"] forState:UIControlStateNormal];
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

- (IBAction)saveButtonAction:(id)sender
{
    if([self isValidateFeilds])
    {
        [self willPerformUpdateUserDetailsAPICall];
    }
}

- (IBAction)dateOfBirthButtonAction:(id)sender {
    [self.view endEditing:YES];
    [self.navigationController.navigationBar endEditing:YES];
    if(selectedDate){
        [self.pickerViewController setSelectedDate:selectedDate];
    }
    [[[ApplicationDelegate window] rootViewController] presentViewController:self.pickerViewController animated:YES completion:nil];
}

- (IBAction)addPictureProfileAction:(id)sender {
    [self performImageChangeAction];
}

- (IBAction)deleteProfileAction:(id)sender {

    [[RequestManager alloc] userDeactivateWithUserModel:self.user withCompletionBlock:^(BOOL success, id response) {
        if(success){
            [[UserManager sharedManager] logoutUser];
        }
    }];
}

@end
