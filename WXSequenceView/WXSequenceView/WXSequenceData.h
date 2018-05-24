//
//  WXSequenceData.h
//  WXSequenceView
//
//  Created by xin on 2018/4/17.
//  Copyright © 2018年 xin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXSequenceData : NSObject

/**
 图片名称
 */
@property (nonatomic,strong) NSString * imageName;
/**
 图片格式 默认png
 */
@property (nonatomic, strong) NSString * imageType;
/**
 当前数字 默认为1
 */
@property (nonatomic, assign) NSInteger currentNumber;
/**
 总序列数字 默认为60
 */
@property (nonatomic, assign) NSInteger totalNumber;
/**
 时间间隔 默认0.04,只会在下次开始播放的时候生效，正在播放时不会生效
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
/**
 最小缩放值
 */
@property (nonatomic, assign) CGFloat minScale;
/**
 最大放大值
 */
@property (nonatomic, assign) CGFloat maxScale;

@end
