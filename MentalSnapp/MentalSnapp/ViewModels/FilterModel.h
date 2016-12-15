//
//  FilterModel.h
//  MentalSnapp
//
//  Created by Systango on 15/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface FilterModel : JSONModel
@property(strong, nonatomic) NSString <Optional> *filterName;
@property(strong, nonatomic) NSString <Optional> *filterId;
@property(strong, nonatomic) NSString <Optional> *filterType;

@end
