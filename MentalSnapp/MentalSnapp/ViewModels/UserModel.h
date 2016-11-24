//
//  UserModel.h
//  MentalSnapp
//

#import <JSONModel/JSONModel.h>

@interface UserModel : JSONModel

@property(strong, nonatomic) NSString <Optional> *userName;
@property(strong, nonatomic) NSString <Optional> *email;
@property(strong, nonatomic) NSString <Optional> *password;

- (UserModel *)initWithUserEmail:(NSString *)email andPassword:(NSString *)password;

@end
