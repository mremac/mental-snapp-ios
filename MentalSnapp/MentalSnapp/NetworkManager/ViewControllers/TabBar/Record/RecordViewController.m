//
//  RecordViewController.m
//  MentalSnapp
//

#import "RecordViewController.h"
#import "RecordAlertViewController.h"
#import "MoodViewController.h"

@interface RecordViewController () <UIImagePickerControllerDelegate>

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanRVC) name:kCleanRecordViewControllerNotification object:nil];

}

- (void)viewWillAppear:(BOOL)animated {
    [self setNavigationBarButtonTitle:@"Mental Snapp"];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if(![UserDefaults boolForKey:kIsCameraDurationAlertShown])
        {
            [UserDefaults setBool:YES forKey:kIsCameraDurationAlertShown];
            RecordAlertViewController *recordAlertView = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kRecordAlertViewController];
            recordAlertView.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.presentedViewController presentViewController:recordAlertView animated:NO completion:nil];
        }
    });
}

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:^{
        MoodViewController *moodViewController = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kMoodViewController];
        NSURL *urlvideo = [info objectForKey:UIImagePickerControllerMediaURL];
        moodViewController.videoURL = urlvideo;
        if(self.exercise)
        {
            moodViewController.excercise = self.exercise;
        }
        
        [ApplicationDelegate.tabBarController setSelectTabIndex:2];
        [self.navigationController pushViewController:moodViewController animated:YES];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    self.exercise = nil;
    [ApplicationDelegate.tabBarController setSelectTabIndex:0];
    [ApplicationDelegate.tabBarController setSelectedIndex:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark - Private methods

- (void)cleanRVC
{
    self.exercise = nil;
}


@end
