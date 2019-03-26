//
//  CCPagingRequestControl.m
//  CCProjectTemplate
//
//  Created by 李冰 on 2019/3/25.
//  Copyright © 2019 CC. All rights reserved.
//

#import "CCPagingRequestControl.h"

@implementation CCPagingRequestControl

- (instancetype)init {
    
    if (self = [super init]) {
        
        _pageNumber = 1;
        _pageSize = 10;
    }
    
    return self;
}

@end
