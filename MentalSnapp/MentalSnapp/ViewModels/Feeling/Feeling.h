//
//  Feeling.h
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Feeling : JSONModel
@property(strong, nonatomic) NSString <Optional> *feelingName;
@property(strong, nonatomic) NSString <Optional> *feelingId;
@property(strong, nonatomic) NSString <Optional> *feelingRedColor;
@property(strong, nonatomic) NSString <Optional> *feelingBlueColor;
@property(strong, nonatomic) NSString <Optional> *feelingGreenColor;

@end
