//
//  WXSequenceView.m
//  GongYuanMeiShu
//
//  Created by xin on 2018/4/16.
//  Copyright © 2018年 xin. All rights reserved.
//

#import "WXSequenceView.h"

@interface WXSequenceView ()

@property (nonatomic, strong) WXSequenceData *sequenceData;
/**
 图片名称
 */
@property (nonatomic,strong) NSString * imageName;
/**
 图片格式
 */
@property (nonatomic, strong) NSString * imageType;
/**
 当前数字
 */
@property (nonatomic, assign) NSInteger currentNumber;
/**
 总序列数字
 */
@property (nonatomic, assign) NSInteger totalNumber;
/**
 停止播放的数字
 */
@property (nonatomic, assign) NSInteger stopNumber;
/**
 时间间隔 默认0.04,只会在下次开始播放的时候生效，正在播放时不会生效
 */
@property (nonatomic, assign) NSTimeInterval timeInterval;
/**
 计时器
 */
@property (nonatomic, strong) NSTimer *timer;
/**
 递增还是递减判断
 */
@property (nonatomic, assign) BOOL needPlus;
/**
 触摸开始点
 */
@property (nonatomic, assign) CGPoint startPoint;

@end

@implementation WXSequenceView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self _setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self _setup];
    }
    return self;
}

#pragma mark - public

- (void)configSequenceData:(WXSequenceData *)sequenceData
{
    self.sequenceData = sequenceData;
    _imageName = sequenceData.imageName;
    _imageType = sequenceData.imageType;
    _currentNumber = sequenceData.currentNumber;
    _totalNumber = sequenceData.totalNumber;
    _timeInterval = sequenceData.timeInterval;
    [self replaceImage];
}

- (void)startAutoPlay {
    NSInteger stopNumber = self.totalNumber;
    self.needPlus = stopNumber - self.currentNumber;
    [self wx_startAutoPlayWithStopNumber:stopNumber];
}

- (void)stopPlay {
    if(self.timer){
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)startAutoPlayWithStopNumber:(NSInteger)stopNumber {
    if ((stopNumber - self.currentNumber) > 0) {
        self.needPlus = YES;
    }else
    {
        self.needPlus = NO;
    }
    
    [self wx_startAutoPlayWithStopNumber:stopNumber];
}

#pragma mark - Private

- (void)_setup {
    self.userInteractionEnabled = YES;
    self.contentMode = UIViewContentModeScaleAspectFill;
}

- (void)timeDidChange:(NSTimer *)timer {
    [self normalTimeDidChange];
}

- (void)normalTimeDidChange
{
    if (_needPlus) {
        _currentNumber++;
        if (_currentNumber > _stopNumber) {
            _currentNumber = _stopNumber;
            [self stopPlay];
            if (self.delegate && [self.delegate respondsToSelector:@selector(timerEndWithSequenceData:StopNumber:)]) {
                [self.delegate timerEndWithSequenceData:_sequenceData StopNumber:_currentNumber];
            }
        }
    } else {
        _currentNumber--;
        if (_currentNumber < _stopNumber) {
            _currentNumber = _stopNumber;
            [self stopPlay];
            if (self.delegate && [self.delegate respondsToSelector:@selector(timerEndWithSequenceData:StopNumber:)]) {
                [self.delegate timerEndWithSequenceData:_sequenceData StopNumber:_currentNumber];
            }
        }
    }
    //设定当前帧，给下次如果切换360序列保证还能继续上一次的帧继续执行
    _sequenceData.currentNumber = _currentNumber;
    [self replaceImage];
}

- (void)replaceImage
{
    NSString *path = [NSString stringWithFormat:@"%@%ld", _imageName, (long)_currentNumber];
    path = [[NSBundle mainBundle] pathForResource:path ofType:_imageType];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    [self setImage:image];
}

- (void)wx_startAutoPlayWithStopNumber:(NSInteger)stopNumber {
    self.stopNumber = stopNumber;
    if(!self.timer){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval
                                                      target:self
                                                    selector:@selector(timeDidChange:)
                                                    userInfo:nil
                                                     repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

#pragma mark - touches 方法
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    // 区别处理双指拖拽
    if ([event allTouches].count != 1) {
        return;
    }
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    _startPoint = touchLocation;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    // 区别处理双指拖拽
    if ([event allTouches].count != 1) {
        return;
    }
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    CGPoint previousLocation = [touch previousLocationInView:self];
    int changeX = previousLocation.x - touchLocation.x;
    // 防止滑动过快 如果想改变滑动的切换速度也可增加自己的逻辑判断
    if ( abs(changeX) < 5) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(touchMovingWithSequenceData:CurrentNumber:)]) {
        [self.delegate touchMovingWithSequenceData:_sequenceData CurrentNumber:_currentNumber];
    }
    
    // 左右划动
    _currentNumber = _currentNumber + changeX / 10;
    
    if(_currentNumber > _totalNumber) {
        _currentNumber = 1;
    }
    
    if(_currentNumber < 1) {
        _currentNumber = _totalNumber;
    }
    
    //替换图片
    [self replaceImage];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 区别处理双指拖拽
    if ([event allTouches].count != 1) {
        return;
    }
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    if (!CGPointEqualToPoint(touchLocation, _startPoint)) {
        if ([self.delegate respondsToSelector:@selector(touchEndWithSequenceData:CurrentNumber:)]) {
            [self.delegate touchEndWithSequenceData:_sequenceData CurrentNumber:_currentNumber];
        }
    }
}

@end
