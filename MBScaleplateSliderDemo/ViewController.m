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
    
    MBScaleplateSlider *slider  = [[MBScaleplateSlider alloc] initWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 120)
                                                                          minValue:1000
                                                                          maxValue:2000
                                                                              step:10
                                                                       groupMaxNum:10
                                                                              unit:@"nian"
                                                                     hasMiddleLine:YES];
    slider.delegate = self;
    slider.tintLineColor = [UIColor redColor];
    slider.initialAtMiddle = YES;
    
    [self.view addSubview:slider];

    
    
}

- (void)MBScaleplateSlider:(MBScaleplateSlider *)slider valueChange:(NSUInteger)value {
    NSLog(@"---%@", @(value));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
