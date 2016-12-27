//
//  MoodDataModel.m
//  MentalSnapp
//
//  Created by Systango on 28/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MoodDataModel.h"

@implementation MoodDataModel

- (id)initWithDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)err
{
    return [self initWithMoodDataInfo:dict];
}

- (id)initWithMoodDataInfo:(NSDictionary *)moodInfo
{
    self = [super init];
    if (self)
    {
        for (NSString *moodKey in moodInfo.allKeys) {
            
            NSNumber *moodValue = [Util typeCastTwoDigit:[moodInfo valueForKey:moodKey]];
            
            switch ([moodKey integerValue]) {
                case TheBestMood:
                    _theBestMood = moodValue;
                    break;
                case VeryGoodMood:
                    _veryGoodMood = moodValue;
                    break;
                case GoodMood:
                    _goodMood = moodValue;
                    break;
                case OkMood:
                    _okMood = moodValue;
                    break;
                case BadMood:
                    _badMood = moodValue;
                    break;
                case VeryBadMood:
                    _veryBadMood = moodValue;
                    break;
                case TheWorstMood:
                    _theWorstMood = moodValue;
                    break;
                    
                default:
                    break;
            }
        }
    }
    
    return self;
}

@end
