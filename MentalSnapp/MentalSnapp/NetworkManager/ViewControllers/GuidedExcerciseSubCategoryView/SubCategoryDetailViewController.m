//
//  SubCategoryDetailViewController.m
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SubCategoryDetailViewController.h"
#import "PickerViewController.h"

@interface SubCategoryDetailViewController () <PickerViewControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainContainerView;
@property (strong, nonatomic) IBOutlet UITextView *detailTextView;
@property (strong, nonatomic) PickerViewController *pickerViewController;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *mainViewTopConstraint;

@end

@implementation SubCategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UserManager sharedManager].isBackFromView = YES;
    [self.navigationController setNavigationBarHidden:YES];
    [self.navigationController setNavigationBarHidden:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self setNavigationBarButtonTitle:[NSString stringWithFormat:@"%@",self.selectedExcercise.excerciseName]];
        [self showDetailofCategory];
    });
    [self setLeftMenuButtons:[NSArray arrayWithObject:[self backButton]]];
    
    self.pickerViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kPickerViewController];
    self.pickerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.pickerViewController setPickerType:dateTime];
     [self.pickerViewController setDateSelection:futureDateOnly];
    [self.pickerViewController setDelegate:self];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.mainViewTopConstraint.constant = [self.topLayoutGuide length];
    [self.view layoutIfNeeded];
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

#pragma mark - Private methods
- (void)showDetailofCategory {
    [self.detailTextView setText:self.selectedExcercise.excerciseDescription];
}

#pragma mark - Date Picker view Delegate
- (void)didSelectDoneButton:(NSDate *)date {
    
}
- (void)didSelectCancelButton {
    
}

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - IBActions

-(IBAction)subcategoryCalenderAction:(id)sender {
    [[[ApplicationDelegate window] rootViewController] presentViewController:self.pickerViewController animated:YES completion:nil];
}

-(IBAction)subcategoryRecordAction:(id)sender {
    [Util openCameraView:self];
}



@end
