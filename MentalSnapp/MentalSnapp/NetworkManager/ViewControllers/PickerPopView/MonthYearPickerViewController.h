//
//  MonthYearPickerViewController.h
//  MentalSnapp
//
//  Created by Systango on 28/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"

typedef NS_ENUM(NSInteger, DateSelection){
    KDefault=0,
    futureDateOnly,
    pastDateOnly,
    past18Year
};

@protocol MonthYearPickerViewControllerDelegate <NSObject>

- (void)didSelectDoneButton:(NSDate *)date withDay:(NSInteger)day;
- (void)didSelectCancelButton;

@end

@interface MonthYearPickerViewController : MSViewController

@property (assign, nonatomic) id <MonthYearPickerViewControllerDelegate> delegate;
@property (assign, nonatomic) DateSelection dateSelection;
@property (assign, nonatomic) BOOL isOptionalDate;

@end
