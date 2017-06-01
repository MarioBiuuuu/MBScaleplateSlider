# MBScaleplateSlider
iOS仿标尺 Slider滑动选择器
    
使用方法：

1. 使用Cocoapods，在Podfile中添加 `pod ‘MBScaleplateSlider’`， 执行 `pod install`  
2. 直接将`MBScaleplateSlider.h/m`拖入项目内    

    ```
    MBScaleplateSlider *slider  = [MBScaleplateSlider sliderWithFrame:CGRectMake(0, 100, self.view.bounds.size.width, 120) minValue:1000 maxValue:2000 step:10 groupMaxNum:10 unit:@"nian" hasMiddleLine:YES];
    
    slider.delegate = self;
    slider.tintLineColor = [UIColor redColor];
    slider.initialAtMiddle = YES;
        
    [self.view addSubview:slider];
    ```  

3. 处理滑动返回值回调

    ``` 
    - (void)MBScaleplateSlider:(MBScaleplateSlider *)slider valueChange:(NSUInteger)value {
        NSLog(@"---%@", @(value));  
    }
    ```



