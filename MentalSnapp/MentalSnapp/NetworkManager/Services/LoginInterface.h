//
//  LoginInterface.h
//  Skeleton
//
//  Created by Systango on 18/12/13.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LogoutRequest;
@interface LoginInterface : NSObject{
    NSObject *_target;
    SEL _callBack;
}

//- (void)

- (NSMutableArray *)getSavedSessionCookies;

- (BOOL)setSavedSessionCookies;

- (void)saveSessionCookies:(NSString *)urlPath;

- (void)clearSavedSessionCookies;

@end
