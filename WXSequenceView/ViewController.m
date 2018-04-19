//
//  ViewController.m
//  WXSequenceView
//
//  Created by xin on 2018/4/16.
//  Copyright © 2018年 xin. All rights reserved.
//

#import "ViewController.h"
#import "WXSequenceView.h"

@interface ViewController () <WXSequenceViewDelegate>
{
    NSMutableArray *rotateArray;
    WXSequenceData *growSequenceData;
}
@property (weak, nonatomic) IBOutlet WXSequenceView *sequenceView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *scenceArray = @[@"lp_360_1_",@"lp_360_2_",@"lp_360_3_",@"lp_360_4_"];
    
    rotateArray = [NSMutableArray arrayWithCapacity:[scenceArray count]];
    for (int i = 0; i < [scenceArray count]; i++) {
        WXSequenceData *data = [WXSequenceData new];
        data.imageName = scenceArray[i];
        [rotateArray addObject:data];
    }
    
    growSequenceData = [WXSequenceData new];
    growSequenceData.imageName = @"lp_sz_";
    growSequenceData.totalNumber = 90;
    
    self.sequenceView.delegate = self;
    [self.sequenceView configSequenceData:rotateArray[0]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeScence:(UIButton *)sender {
    NSInteger index = sender.tag-1;
    if (index >= rotateArray.count) {
        return;
    }
    [self.sequenceView configSequenceData:growSequenceData];
    NSArray *array = @[@(1),@(31),@(61),@(90)];
    [self.sequenceView startAutoPlayWithStopNumber:[array[index] integerValue]];
}

#pragma mark - WXSequenceViewDelegate

- (void)touchMovingWithSequenceData:(WXSequenceData *)sequenceData CurrentNumber:(NSInteger)currentNumber
{
    NSInteger scenceIndex = [rotateArray indexOfObject:sequenceData];
    NSString *message = [NSString stringWithFormat:@"%ld",currentNumber + 60 * scenceIndex];
    NSLog(@"message=%@",message);
}

- (void)timerEndWithSequenceData:(WXSequenceData *)sequenceData StopNumber:(NSInteger)stopNumber
{
    if (sequenceData == growSequenceData) {
        NSArray *array = @[@(1),@(31),@(61),@(90)];
        NSInteger index = [array indexOfObject:@(stopNumber)];
        WXSequenceData *data = rotateArray[index];
        [self.sequenceView configSequenceData:data];
    }
}

@end
