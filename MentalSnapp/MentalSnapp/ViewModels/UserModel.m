//
//  UserModel.m
//  MentalSnapp
//

#import "UserModel.h"

@implementation UserModel

+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"authorizationToken": @"auth_token",
                                                                  @"email": @"email",
                                                                  @"password": @"password",
                                                                  @"userName": @"user_name",
                                                                  @"dateOfBirth": @"dob",
                                                                  @"PhoneNumber": @"phone_number",
                                                                  @"gender": @"gender",
                                                                  @"userId": @"user_id"
                                                                  }];
}
    
- (UserModel *)initWithUserEmail:(NSString *)email andPassword:(NSString *)password {
    self = [super init];
    
    self.email = email;
    self.password = password;
    
    return self;
}
    
- (UserModel *)initWithUserId:(NSString *)userId andEmail:(NSString *)email andUserName:(NSString *)userName andPhone:(NSString *)phone andGender:(NSString *)gender andDateOfBirth:(NSString *)dateOfBirth andProfilePic:(NSString *)profilePicURL{
    self = [super init];
    self.userId = userId;
    self.email = email;
    self.userName = userName;
    self.phoneNumber = phone;
    self.gender = gender;
    self.dateOfBirth = dateOfBirth;
    self.profilePicURL = profilePicURL;
    return self;
}

@end
