//
//  BCQRefundResult.m
//  BCPaySDK
//
//  Created by Ewenlong03 on 15/7/27.
//  Copyright (c) 2015年 BeeCloud. All rights reserved.
//

#import "BCQueryRefundResult.h"

@implementation BCQueryRefundResult

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = BCObjsTypeRefundResults;
        self.refundno = @"";
        self.refundfee = 0;
        self.result = NO;
        self.finish = NO;
    }
    return self;
}

@end
