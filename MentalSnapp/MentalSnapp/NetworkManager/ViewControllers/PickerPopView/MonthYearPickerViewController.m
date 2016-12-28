//
//  MonthYearPickerViewController.m
//  MentalSnapp
//
//  Created by Systango on 28/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MonthYearPickerViewController.h"
#import "UIMonthYearPicker.h"

@interface MonthYearPickerViewController ()<UIMonthYearPickerDelegate>

@property (weak, nonatomic) IBOutlet UIMonthYearPicker *datePicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@end

@implementation MonthYearPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.datePicker._delegate = self;
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setLocale:[NSLocale currentLocale]];
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    
    switch (_dateSelection) {
        case futureDateOnly:
        {
            NSDate *currentDate = [NSDate date];
            [self.datePicker setMinimumDate:currentDate];
            [self.datePicker setMaximumDate:[currentDate dateByAddingYears:50]];
        }
            break;
        case pastDateOnly:
        {
            NSDate * maxDate = [NSDate date];
            [self.datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
            [self.datePicker setMaximumDate:maxDate];
            self.datePicker.date = maxDate;
        }
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
            
            self.datePicker.minimumDate = minDate;
            self.datePicker.maximumDate = maxDate;
            self.datePicker.date = maxDate;
            break;
        }
            
        default:
            break;
    }
}

- (void)viewDidUnload
{
    [self setDatePicker:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIMonthYearPickerDelegate
- (void) pickerView:(UIPickerView *)pickerView didChangeDate:(NSDate *)newDate{
}

#pragma mark Toolbar IBActions
- (IBAction)toolBarDoneButtonAction:(id)sender
{
    if([self.delegate respondsToSelector:@selector(didSelectDoneButton:)]){
        [self.delegate didSelectDoneButton:self.datePicker.date];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)toolBarCancelButtonAction:(id)sender
{
    self.datePicker.date = [NSDate date];
    
   if([self.delegate respondsToSelector:@selector(didSelectCancelButton)]){
        [self.delegate didSelectCancelButton];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
