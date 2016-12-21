//
//  FilterListTableController.h
//  MentalSnapp
//
//  Created by Systango on 13/12/16.
//  Copyright © 2016 Systango. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VideosViewController, Paginate;

@interface FilterListTableController : UITableViewController
@property(nonatomic,assign) VideosViewController *delegate;
@property (strong, nonatomic) Paginate *filterListPaginate;
- (void)reloadData;
@end
