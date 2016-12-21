//
//  RecordPost.m
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "RecordPost.h"

@implementation RecordPost

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"postId": @"id",
                                                                  @"postName": @"name",
                                                                  @"excerciseType": @"exercisable_type",
                                                                  @"coverURL": @"cover_url",
                                                                  @"postDesciption":@"tags",
                                                                  @"videoURL": @"video_url",
                                                                  @"userId": @"user_id",
                                                                  @"moodId": @"mood_id",//mood_value is not comming in videos call
                                                                  @"feelingId": @"feeling_ids",
                                                                  @"excerciseId" : @"exercisable_id",
                                                                  @"createdAt" : @"created_at"
                                                                  }];
}

- (RecordPost *)initWithVideoName:(NSString *)postName andExcerciseType:(NSString *)excerciseType andCoverURL:(NSString *)coverURL andPostDesciption:(NSString *)postDesciption andVideoURL:(NSString *)videoURL andUserId:(NSString *)userId andMoodId:(NSString *)moodId andFeelingId:(NSString *)feelingId andWithExcercise:(GuidedExcercise *)excercise {
    self = [super init];
    self.postName = postName;
    self.coverURL = coverURL;
    self.postDesciption = postDesciption;
    self.videoURL = videoURL;
    self.userId = userId;
    self.moodId = moodId;
    self.feelingId = feelingId;
    if(excercise){
        self.excerciseType = excerciseType;
       self.excerciseId = excercise.excerciseId;
    }
    
    return self;
}

@end
