//
//  RecordAlertViewController.m
//  MentalSnapp
//
//  Created by Systango on 07/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "RecordAlertViewController.h"
#import <GoogleAnalytics/GAI.h>

@interface RecordAlertViewController ()
@property (strong, nonatomic) IBOutlet UIView *alertContainerView;

- (IBAction)okButtonAction:(id)sender;

@end

@implementation RecordAlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shakeAnimation];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)shakeAnimation {
    CABasicAnimation *animation =
    [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:8];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.alertContainerView center].x - 20.0f, [self.alertContainerView center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.alertContainerView center].x + 20.0f, [self.alertContainerView center].y)]];
    [[self.alertContainerView layer] addAnimation:animation forKey:@"position"];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)okButtonAction:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
@end
