//
//  PickerViewController.m
//  MentalSnapp
//
//  Created by Systango on 05/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (strong, nonatomic) IBOutlet UIToolbar *toolBar;
- (IBAction)toolBarDoneButtonAction:(id)sender;
- (IBAction)toolBarCancelButtonAction:(id)sender;

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if(self.selectedDate){
        [self.datePickerView setDate:self.selectedDate];
    }
    [self.datePickerView setMaximumDate:[NSDate date]];
    switch (self.pickerType) {
        case dateOnly:
            [self.datePickerView setDatePickerMode:UIDatePickerModeDate];
            break;
        case dateTime:
            [self.datePickerView setDatePickerMode:UIDatePickerModeDateAndTime];
            break;
        case timeOnly:
            [self.datePickerView setDatePickerMode:UIDatePickerModeTime];
            break;

        default:
            [self.datePickerView setDatePickerMode:UIDatePickerModeDate];
            break;
    }
    
    [self.datePickerView addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
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

#pragma mark - Date picker Selector method
- (void)dateIsChanged:(id)sender{
//    if([self.delegate respondsToSelector:@selector(didSelectDoneButton:)]){
//        [self.delegate didSelectDoneButton:self.datePickerView.date];
//    }
}


- (IBAction)toolBarDoneButtonAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(didSelectDoneButton:)]){
        [self.delegate didSelectDoneButton:self.datePickerView.date];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toolBarCancelButtonAction:(id)sender {
    if([self.delegate respondsToSelector:@selector(didSelectCancelButton)]){
        [self.delegate didSelectCancelButton];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
