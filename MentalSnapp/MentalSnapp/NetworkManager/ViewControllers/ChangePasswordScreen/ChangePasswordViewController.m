//
//  ChangePasswordViewController.m
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "RequestManager.h"

@interface ChangePasswordViewController ()
@property (strong, nonatomic) IBOutlet UITextField *currentPasswordTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordNewTextField;
@property (strong, nonatomic) IBOutlet UITextField *reNewPasswordTextField;

- (IBAction)saveButtonAction:(id)sender;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationBarButtonTitle:@"Change Password"];
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];
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

#pragma mark - Private method

-(BOOL)isValidateFeilds {
    if([self.currentPasswordTextField.text isEqualToString:@""]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:LocalizedString(@"CurrentPasswordMessage")];
        return NO;
    }
       if([self.passwordNewTextField.text isEqualToString:@""]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:LocalizedString(@"NewPasswordMessage")];
        return NO;
    }
    if([self.reNewPasswordTextField.text isEqualToString:@""]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:LocalizedString(@"ConfirmPasswordMessage")];
        return NO;
    }
    if(![self.reNewPasswordTextField.text isEqualToString:self.passwordNewTextField.text]) {
        [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:LocalizedString(@"NewAndConfirmPasswordMismatchMessage")];
        return NO;
    }
    return YES;
}


#pragma mark  - TextField Delegates

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
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
    
    if([textField isEqual:self.currentPasswordTextField]){
        [self.passwordNewTextField becomeFirstResponder];
    } else  if([textField isEqual:self.passwordNewTextField]){
        [self.reNewPasswordTextField becomeFirstResponder];
    }else  if([textField isEqual:self.reNewPasswordTextField]){
        if(![self.reNewPasswordTextField.text isEqualToString:self.passwordNewTextField.text]) {
            [Banner showFailureBannerOnTopWithTitle:@"Error" subtitle:LocalizedString(@"NewAndConfirmPasswordMismatchMessage")];
            return YES;
        }
        [self.reNewPasswordTextField resignFirstResponder];
    }
        return YES;
}


#pragma mark - IBActions

- (IBAction)saveButtonAction:(id)sender {
    if([self isValidateFeilds]){
        [self showInProgress:YES];
        [[RequestManager alloc] changePassword:self.currentPasswordTextField.text andNewPassword:self.passwordNewTextField.text withCompletionBlock:^(BOOL success, id response) {
            [self showInProgress:NO];
            if(success) {
                [Banner showSuccessBannerWithSubtitle:LocalizedString(@"PasswordChangeSuccess")];
                [self backButtonTapped];
            }
        }];
    }

}
@end
