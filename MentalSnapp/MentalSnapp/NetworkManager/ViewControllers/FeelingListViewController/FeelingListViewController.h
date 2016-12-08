//
//  FeelingListViewController.h
//  MentalSnapp
//
//  Created by Systango on 09/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import "MSViewController.h"
#import "Feeling.h"

@protocol FeelingListDalegate <NSObject>

-(void)didSelectFeeling:(Feeling *)feeling;

@end

@interface FeelingListViewController : MSViewController

@property (nonatomic, assign) id <FeelingListDalegate> delegate;
@property (nonatomic, assign) Feeling *selectedFeeling;

@end
