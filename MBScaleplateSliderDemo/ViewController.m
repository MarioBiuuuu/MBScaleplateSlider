//
//  ViewController.m
//  MBScaleplateSliderDemo
//
//  Created by ZhangXiaofei on 2017/6/1.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "ViewController.h"
#import "MBScaleplateSlider.h"

@interface ViewController () <MBScaleplateSliderDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    MBScaleplateSlider *slider  = [MBScaleplateSlider sliderWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 80) minValue:0 maxValue:14 step:1 groupMaxNum:10 unit:@"" hasMiddleLine:YES];
    slider.backgroundColor = [UIColor whiteColor];
    
    slider.delegate = self;
    slider.tintLineColor = [UIColor greenColor];
    slider.initialAtMiddle = YES;
    slider.titleColor = [UIColor blackColor];
    slider.hiddeUnderLine = YES;
    slider.selectedValue = 0;
    slider.titleTextHidden = NO;
    slider.openIgnore = YES;
    slider.ignoreValue = 0;
    [slider addSideLayerWithColor:nil];
    [self.view addSubview:slider];

}

- (void)MBScaleplateSlider:(MBScaleplateSlider *)slider valueChange:(CGFloat)value {
    NSLog(@"---%@", @(value));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
