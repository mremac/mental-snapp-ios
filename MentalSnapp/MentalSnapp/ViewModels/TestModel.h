//
//  TestModel.h
//  Skeleton
//
//  Created by Systango on 02/06/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TestModel : JSONModel

@property (assign, nonatomic) int id;

// Optional properties (i.e. can be missing or null)
@property (strong, nonatomic) NSString<Optional>* name;
@property (assign, nonatomic) float price;

// Ignored properties (i.e. JSONModel completely ignores them)
@property (strong, nonatomic) NSString<Ignore>* customProperty;

// Model cascading (models including other models)
//@property (strong, nonatomic) ProductModel* product;

// For array of other model(Model collections)
//@property (strong, nonatomic) NSArray<ProductModel>* products;

@end
