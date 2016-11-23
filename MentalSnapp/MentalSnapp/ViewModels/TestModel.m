//
//  TestModel.m
//  Skeleton
//
//  Created by Systango on 02/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

/*
 
 ***************************************************************************************
 //https://github.com/icanzilb/JSONModel
 ***************************************************************************************
 
// Automatic name based mapping
 
 {
 "id": "123",
 "name": "Product name",
 "price": 12.95
 }
 @interface ProductModel : JSONModel
 @property (assign, nonatomic) int id;
 @property (strong, nonatomic) NSString* name;
 @property (assign, nonatomic) float price;
 @end
 
 @implementation ProductModel
 @end
 
 
// Map automatically under_score case to camelCase
+(JSONKeyMapper*)keyMapper
{
    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
}

// Key mapping (Map custom)
 +(JSONKeyMapper*)keyMapper
 {
 return [[JSONKeyMapper alloc] initWithDictionary:@{
 @"order_id": @"id",
 @"order_details.name": @"productName",
 @"order_details.price.usd": @"price"
 }];
 }
 
 // Global key mapping (applies to all models in your app)
 [JSONModel setGlobalKeyMapper:[
 [JSONKeyMapper alloc] initWithDictionary:@{
 @"item_id":@"ID",
 @"item.name": @"itemName"
 }]
 ];
 
 //convert to dictionary
 NSDictionary* dict = [pm toDictionary];
 
 //convert to text
 NSString* string = [pm toJSONString];
 
 */

@end
