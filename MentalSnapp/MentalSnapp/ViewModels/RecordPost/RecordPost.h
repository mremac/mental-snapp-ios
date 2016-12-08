//
//  RecordPost.h
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "GuidedExcercise.h"

@interface RecordPost : JSONModel

@property(strong, nonatomic) NSString <Optional> *postName;
@property(strong, nonatomic) NSString <Optional> *excerciseType;
@property(strong, nonatomic) NSString <Optional> *coverURL;
@property(strong, nonatomic) NSString <Optional> *postDesciption;
@property(strong, nonatomic) NSString <Optional> *videoURL;
@property(strong, nonatomic) NSString <Optional> *userId;
@property(strong, nonatomic) NSString <Optional> *moodId;
@property(strong, nonatomic) NSString <Optional> *feelingId;
@property(strong, nonatomic) NSString <Optional> *postId;
@property(strong, nonatomic) NSString <Optional> *excerciseId;
@property(strong, nonatomic) NSString <Optional> *subCategoryId;

- (RecordPost *)initWithVideoName:(NSString *)postName andExcerciseType:(NSString *)excerciseType andCoverURL:(NSString *)coverURL andPostDesciption:(NSString *)postDesciption andVideoURL:(NSString *)videoURL andUserId:(NSString *)userId andMoodId:(NSString *)moodId andFeelingId:(NSString *)feelingId andWithExcercise:(GuidedExcercise *)excercise;

@end
