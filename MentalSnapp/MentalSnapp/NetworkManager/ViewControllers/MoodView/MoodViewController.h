//
//  MoodViewController.h
//  MentalSnapp
//
//  Created by Systango on 08/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"
#import "GuidedExcercise.h"

@interface MoodViewController : MSViewController

@property(nonatomic, strong) NSURL *videoURL;
@property (nonatomic, strong) GuidedExcercise *excercise;

@end
