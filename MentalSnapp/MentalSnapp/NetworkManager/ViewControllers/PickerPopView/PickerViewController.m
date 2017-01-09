//
//  PickerViewController.m
//  MentalSnapp
//
//  Created by Systango on 05/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "PickerViewController.h"

@interface PickerViewController ()

@property (strong, nonatomic) NSDate *selectedDate;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)toolBarDoneButtonAction:(id)sender;
- (IBAction)toolBarCancelButtonAction:(id)sender;

@end

@implementation PickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    switch (_dateSelection) {
        case futureDateOnly:
            [self.datePickerView setMinimumDate:[[NSDate date] dateByAddingTimeInterval:(NSTimeInterval)((u_int32_t)6*60)]];
            break;
        case pastDateOnly:
            [self.datePickerView setMaximumDate:[NSDate date]];
            break;
        case past18Year:
        {
            NSCalendar * gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
            NSDate * currentDate = [NSDate date];
            NSDateComponents * comps = [[NSDateComponents alloc] init];
            [comps setYear: -18];
            NSDate * maxDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
            [comps setYear: -120];
            NSDate * minDate = [gregorian dateByAddingComponents: comps toDate: currentDate options: 0];
            
            self.datePickerView.minimumDate = minDate;
            self.datePickerView.maximumDate = maxDate;
            self.datePickerView.date = maxDate;
            break;
        }

        default:
            break;
    }
    
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
    if(self.selectedDate){
        [self.datePickerView setDate:self.selectedDate];
    }
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];;
    [self.datePickerView setLocale:locale];

    [self.datePickerView addTarget:self action:@selector(dateIsChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public methods
- (void)updatePickerDate:(NSDate *)date
{
    self.selectedDate = date;
    if(self.selectedDate){
        [self.datePickerView setDate:self.selectedDate];
    }
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
    
    if(self.selectedDate){
        [self.datePickerView setDate:self.selectedDate];
    }
    
    if([self.delegate respondsToSelector:@selector(didSelectCancelButton)]){
        [self.delegate didSelectCancelButton];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
