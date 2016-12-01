//
//  GuidedExcercise.h
//  MentalSnapp
//
//  Created by Systango on 01/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface GuidedExcercise : JSONModel

@property(strong, nonatomic) NSString <Optional> *excerciseName;
@property(strong, nonatomic) NSString <Optional> *excerciseCoverURL;
@property(strong, nonatomic) NSString <Optional> *excerciseSmallCoverURL;
@property(strong, nonatomic) NSString <Optional> *excerciseDescription;
@property(strong, nonatomic) NSString <Optional> *excerciseId;
@property(strong, nonatomic) NSString <Optional> *excerciseStringType;
@property(strong, nonatomic) NSString <Optional> *superExcerciseId;

@end
