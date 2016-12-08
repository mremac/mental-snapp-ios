//
//  MoodViewController.m
//  MentalSnapp
//
//  Created by Systango on 08/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MoodViewController.h"
#import "EFCircularSlider.h"

@interface MoodViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *containerView;
@property (strong, nonatomic) IBOutlet UIView *videoNameView;
@property (strong, nonatomic) IBOutlet UITextField *videoNameTextField;
@property (strong, nonatomic) IBOutlet UIView *moodWheelView;
@property (strong, nonatomic) IBOutlet UIView *addFeelingView;
@property (strong, nonatomic) IBOutlet UIButton *addFeelingButton;
@property (strong, nonatomic) IBOutlet UIView *descriptionView;
@property (strong, nonatomic) IBOutlet UITextView *descriptionTextView;

- (IBAction)addFeelingButtonAction:(id)sender;

@end

@implementation MoodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarButtonTitle:@"Mental Snapp"];
    [self setRightMenuButtons:[NSArray arrayWithObjects:[self uploadButton], nil]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self addMoodWheel];
    });
    
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

- (UIBarButtonItem *)uploadButton {
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, 30, 30)];
    [leftButton setImage:[UIImage imageNamed:@"uploadButton"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(uploadButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    return leftBarButton;
}


-(void)addMoodWheel {
    CGFloat xValue = (self.moodWheelView.frame.size.width-250)/2;
    CGFloat yValue = (self.moodWheelView.frame.size.height-250)/2;
    CGRect sliderFrame = CGRectMake(xValue, yValue, 250, 250);
    EFCircularSlider* circularSlider = [[EFCircularSlider alloc] initWithFrame:sliderFrame];
    [circularSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    UITapGestureRecognizer *seekbarGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seekBarTapped:)];
    [circularSlider addGestureRecognizer:seekbarGesture];
    circularSlider.lineWidth = 25;
    circularSlider.handleType = EFDoubleCircleWithOpenCenter;
    NSArray* labels = @[@"B", @"C", @"D", @"E",@"F",@"G", @"A"];
    [circularSlider setInnerMarkingLabels:labels];
    
    [self.moodWheelView addSubview:circularSlider];
}

#pragma mark - mood wheel actions
- (void)seekBarTapped:(UIGestureRecognizer *)gestureRecognizer {
    EFCircularSlider* circularSlider = (EFCircularSlider*)gestureRecognizer.view;
    CGPoint point = [gestureRecognizer locationInView:circularSlider];
    [circularSlider moveHandle:point];
    [self sliderValueChanged:circularSlider];
}

-(void)sliderValueChanged:(EFCircularSlider*)slider {
    
    CGFloat value = 100.0/7.0;
    if(slider.currentValue<=(value)){
        [slider setFilledColor:[UIColor colorWithRed:0.0/255.0 green:255.0/255.0 blue:0.0/255.0 alpha:1.0f]];
    }else if(slider.currentValue<=(value*2)){
        [slider setFilledColor:[UIColor colorWithRed:34.0/255.0 green:139.0/255.0 blue:34.0/255.0 alpha:1.0f]];
    }else if(slider.currentValue<=(value*3)){
        [slider setFilledColor:[UIColor colorWithRed:245.0/255.0 green:130.0/255.0 blue:32.0/255.0 alpha:1.0f]];
    }else if(slider.currentValue<=(value*4)){
        [slider setFilledColor:[UIColor colorWithRed:253.0/255.0 green:185.0/255.0 blue:19.0/255.0 alpha:1.0f]];
    }else if(slider.currentValue<=(value*5)){
        [slider setFilledColor:[UIColor colorWithRed:237.0/255.0 green:28.0/255.0 blue:36.0/255.0 alpha:1.0f]];
    }else if(slider.currentValue<=(value*6)){
        [slider setFilledColor:[UIColor colorWithRed:83.0/255.0 green:79.0/255.0 blue:161.0/255.0 alpha:1.0f]];
    }else if(slider.currentValue<=(100)){
        [slider setFilledColor:[UIColor colorWithRed:50.0/255.0 green:0.0/255.0 blue:74.0/255.0 alpha:1.0f]];
    }
}

#pragma mark - IBActions
- (IBAction)uploadButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    [Util saveCustomObject:[NSNumber numberWithBool:NO] toUserDefaultsForKey:@"isMoodViewController"];
    [ApplicationDelegate.tabBarController setSelectTabIndex:0];
    [ApplicationDelegate.tabBarController setSelectedIndex:0];
}

- (IBAction)addFeelingButtonAction:(id)sender {
}
@end
