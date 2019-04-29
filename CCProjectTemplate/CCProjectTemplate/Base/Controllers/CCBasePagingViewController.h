//
//  CCBasePagingViewController.h
//  BluetoothScale
//
//  Created by 李冰 on 2019/4/29.
//  Copyright © 2019 CC. All rights reserved.
//

#import "CCBaseListViewController.h"
#import "CCPagingRequest.h"

@interface CCBasePagingViewController : CCBaseListViewController

@property (nonatomic, strong) NSURL *url;

@property (nonatomic, strong, readonly) CCPagingRequest *pagingRequest;

// You want covert data model
- (Class)needRipeModel;
// Request parameters
- (NSDictionary *)requestParameters;

@end
