//
//  UserModel.m
//  MentalSnapp
//

#import "UserModel.h"

@implementation UserModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"user_name": @"userName",
                                                                  @"password": @"password"
                                                                  }];
}

- (UserModel *)initWithUserEmail:(NSString *)email andPassword:(NSString *)password {
    self = [super init];
    
    self.email = email;
    self.password = password;
    
    return self;
}

@end
