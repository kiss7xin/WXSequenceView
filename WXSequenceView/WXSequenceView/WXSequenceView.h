//
//  WXSequenceView.h
//  GongYuanMeiShu
//
//  Created by xin on 2018/4/16.
//  Copyright © 2018年 xin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXSequenceData.h"

@protocol WXSequenceViewDelegate <NSObject>

@optional
/**
 手指移动中当前图片的数字
 
 @param currentNumber 当前图片的数字
 */
- (void)touchMovingWithSequenceData:(WXSequenceData *)sequenceData CurrentNumber:(NSInteger)currentNumber;

/**
 手指结束时当前图片的数字
 
 @param currentNumber 当前图片的数字
 */
- (void)touchEndWithSequenceData:(WXSequenceData *)sequenceData CurrentNumber:(NSInteger)currentNumber;

/**
 自动播放停止时的回调
 
 @param stopNumber 停止的图片的数字
 */
- (void)timerEndWithSequenceData:(WXSequenceData *)sequenceData StopNumber:(NSInteger)stopNumber;

/**
 双指缩放
 
 @param scaleValue 缩放大小
 */
- (void)doubleTouchScale:(CGFloat)scaleValue;

@end

@interface WXSequenceView : UIImageView

@property (nonatomic, strong, readonly) WXSequenceData *sequenceData;

@property (nonatomic, weak, nullable) id<WXSequenceViewDelegate> delegate;

/**
 配置序列图模型数据
 
 @param sequenceData 模型数据
 */
- (void)configSequenceData:(WXSequenceData *)sequenceData;

/**
 开始自动播放，自动播放到图片序列的尾部
 */
- (void)startAutoPlay;

/**
 暂停播放
 */
- (void)stopPlay;

/**
 从当前图片数字自动播放到指定图片数字
 
 @param stopNumber 停止的图片数字
 */
- (void)startAutoPlayWithStopNumber:(NSInteger)stopNumber;

@end
