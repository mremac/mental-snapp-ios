//
//  UserRequest.h
//  MentalSnapp
//
//  Copyright © 2016 Systango. All rights reserved.
//

#import "Request.h"

@interface UserRequest : Request
    
- (id)initForEditUser:(UserModel *)user;
    
@end
