//
//  MoodDataModel.h
//  MentalSnapp
//
//  Created by Systango on 28/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface MoodDataModel : JSONModel

@property(nonatomic, strong) NSNumber *theBestMood;
@property(nonatomic, strong) NSNumber *veryGoodMood;
@property(nonatomic, strong) NSNumber *goodMood;
@property(nonatomic, strong) NSNumber *okMood;
@property(nonatomic, strong) NSNumber *badMood;
@property(nonatomic, strong) NSNumber *veryBadMood;
@property(nonatomic, strong) NSNumber *theWorstMood;

- (id)initWithMoodDataInfo:(NSDictionary *)moodInfo;

@end
