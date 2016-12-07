//
//  RecordViewController.m
//  MentalSnapp
//

#import "RecordViewController.h"
#import "RecordAlertViewController.h"

@interface RecordViewController () <UIImagePickerControllerDelegate>

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated {
    [self setNavigationBarButtonTitle:@"Mental Snapp"];
    [Util openCameraView:self WithAnimation:NO];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            RecordAlertViewController *recordAlertView = [[UIStoryboard storyboardWithName:KProfileStoryboard bundle:nil] instantiateViewControllerWithIdentifier:kRecordAlertViewController];
            recordAlertView.modalPresentationStyle = UIModalPresentationOverFullScreen;
            [self.presentedViewController presentViewController:recordAlertView animated:NO completion:nil];
        });
    });
}

#pragma mark - Image picker delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [ApplicationDelegate.tabBarController setSelectTabIndex:0];
    [ApplicationDelegate.tabBarController setSelectedIndex:0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [picker dismissViewControllerAnimated:YES completion:nil];
    });
}


@end
