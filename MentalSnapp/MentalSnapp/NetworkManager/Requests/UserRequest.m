//
//  UserRequest.m
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "UserRequest.h"

@interface UserRequest ()
    
@property (nonatomic, strong) NSMutableDictionary *parameters;
    
@end

@implementation UserRequest
    
- (id)initForEditUser:(UserModel *)user {
    self = [super init];
    if (self) {
        _parameters = [[user toDictionary] mutableCopy];
        self.urlPath = @"";
    }
    return self;
}

    
@end
