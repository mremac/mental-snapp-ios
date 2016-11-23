//
//  CategoryInterface.m
//  Skeleton
//
//  Created by Systango on 17/08/15.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "CategoryInterface.h"

@implementation CategoryInterface

//#pragma mark - Public Methods
//
//- (void)getCategories:(CategoryRequest *)request withCompletionBlock:(completionBlock)block {
//    _block = block;
//    id aPIInteractorProvider = [[APIInteractorProvider sharedInterface] getAPIInetractor];
//    [aPIInteractorProvider postObject:request withCompletionBlock:^(BOOL success, id response) {
//        [self parseSuccessReponse:response];
//    }];
//}
//
//#pragma mark - Parse Response
//
//- (void)parseSuccessReponse:(id)response {
//    if ([response isKindOfClass:[NSDictionary class]]) {
//        NSString *success = nil;
//        
//        if ([response hasValueForKey:@"response"]) {
//            NSArray *categories =  [response valueForKey:@"response"];
//            NSMutableArray *categoryList = [NSMutableArray array];
//            for (NSDictionary *dict in categories) {
//                CategoryEntity *category = [CategoryEntity getCategoryForResponse:dict];
//                [categoryList addObject:category];
//            }
//            self.block(YES,categoryList);
//        }
//        
//        else {
//            NSString *errorMessage = nil;
//            if([response hasValueForKey:@"msg"]){
//                errorMessage = [response valueForKey:@"msg"];
//            }
//            _block([success integerValue], errorMessage);
//        }
//    } else if([response isKindOfClass:[NSError class]]) {
//        NSString *errorMessage = ((NSError *)response).localizedDescription;
//        _block(NO, errorMessage);
//    } else {
//        _block(NO, nil);
//    }
//}

@end
