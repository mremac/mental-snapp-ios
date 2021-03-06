//
//  PickerViewController.h
//  MentalSnapp
//
//  Created by Systango on 05/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"

typedef NS_ENUM(NSInteger, DatePickerType){
    dateOnly,
    dateTime,
    timeOnly,
};

typedef NS_ENUM(NSInteger, DateSelection){
    KDefault=0,
    futureDateOnly,
    pastDateOnly,
    past18Year
};


@protocol PickerViewControllerDelegate <NSObject>

- (void)didSelectDoneButton:(NSDate *)date;
- (void)didSelectCancelButton;

@end

@interface PickerViewController : MSViewController

@property (assign, nonatomic) id <PickerViewControllerDelegate> delegate;
@property (assign, nonatomic) DatePickerType pickerType;
@property (assign, nonatomic) DateSelection dateSelection;

- (void)updatePickerDate:(NSDate *)date;
@end
