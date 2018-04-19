//
//  WXSequenceData.m
//  WXSequenceView
//
//  Created by xin on 2018/4/17.
//  Copyright © 2018年 xin. All rights reserved.
//

#import "WXSequenceData.h"

@implementation WXSequenceData

- (id)init
{
    self = [super init];
    if (self) {
        _imageType = @"png";
        _timeInterval = 0.04;
        _currentNumber = 1;
        _totalNumber = 60;
    }
    return self;
}

@end
