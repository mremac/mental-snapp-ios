//
//  SubCategoryDetailViewController.m
//  MentalSnapp
//
//  Created by Systango on 12/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "SubCategoryDetailViewController.h"
#import "PickerViewController.h"
#import "RequestManager.h"

@interface SubCategoryDetailViewController () <PickerViewControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainContainerView;
@property (strong, nonatomic) IBOutlet UILabel *detailTextView;
@property (strong, nonatomic) PickerViewController *pickerViewController;
@property (strong, nonatomic) IBOutlet UIImageView *subcategoryImage;
@property (strong, nonatomic) IBOutlet UILabel *subcategoryNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *nextButton;
@property (strong, nonatomic) IBOutlet UIButton *previouseButton;
- (IBAction)nextButtonAction:(id)sender;
- (IBAction)previouseButtonAction:(id)sender;


@end

@implementation SubCategoryDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pickerViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kPickerViewController];
    self.pickerViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.pickerViewController setPickerType:dateTime];
     [self.pickerViewController setDateSelection:futureDateOnly];
    [self.pickerViewController setDelegate:self];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showDetailofCategory];
    [self.previouseButton setEnabled:(((self.index-1)<0)?NO:YES)];
    [self.nextButton setEnabled:((self.index+1>=self.allSubExcercises.count)?NO:YES)];
    [self.previouseButton setAlpha:(((self.index-1)<0)?0.2:1.0)];
    [self.nextButton setAlpha:((self.index+1>=self.allSubExcercises.count)?0.2:1.0)];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.subcategoryImage sd_setImageWithURL:[NSURL URLWithString:self.selectedExcercise.coverURL] placeholderImage:[UIImage imageNamed:@"defaultExcerciseImage"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if(image){
                [self.subcategoryImage setImage:image];
            }
        }];
        [self.subcategoryNameLabel setText:self.selectedExcercise.excerciseName];
        [self.detailTextView setText:self.selectedExcercise.excerciseDescription];
    });
}

#pragma mark - API Call

- (void)editRecordWithDate:(NSDate *)date
{
    [self showInProgress:YES];
    ScheduleModel *schedule = [[ScheduleModel alloc] init];
    schedule.exercise = self.selectedExcercise;
    
    schedule.executeAt = [NSString stringWithFormat:@"%f", [date timeIntervalSince1970]];
    [[RequestManager alloc] createSchedule:schedule withCompletionBlock:^(BOOL success, id response) {
        if(success && [response isKindOfClass:[ScheduleModel class]])
        {
            ScheduleModel *scheduleModel = response;
            NSString *dateTimeValue = [Util displayDateWithTimeInterval:[scheduleModel.executeAt integerValue]];
            NSString *message = [NSString stringWithFormat:@"Exercise scheduled on %@.", dateTimeValue];
            [[ScheduleManager sharedInstance] modifyScheduledNotifications:scheduleModel];
            [Banner showSuccessBannerWithSubtitle:message];
        }
        [self showInProgress:NO];
    }];
}

#pragma mark - Date Picker view Delegate
- (void)didSelectDoneButton:(NSDate *)date {
    [self editRecordWithDate:date];
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
    [Util openCameraForRecordExercise:self.selectedExcercise];
}



- (IBAction)nextButtonAction:(id)sender {
    [self.pageControl setSelectedViewControllerAtIndex:self.index+1];
}

- (IBAction)previouseButtonAction:(id)sender {
     [self.pageControl setSelectedViewControllerAtIndex:self.index-1];
}
@end
