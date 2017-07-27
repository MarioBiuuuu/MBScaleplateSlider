//
//  MBScaleplateSlider.h
//  MBScaleplateSliderDemo
//
//  Created by ZhangXiaofei on 2017/6/1.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBScaleplateSlider;

@protocol MBScaleplateSliderDelegate <NSObject>

@optional
/** 滑动值获取 */
- (void)MBScaleplateSlider:(MBScaleplateSlider *)slider valueChange:(CGFloat)value;
@end

@interface MBScaleplateSlider : UIView
/** 开关忽略数值 */
@property (nonatomic, assign) BOOL openIgnore;
/** 忽略数值 */
@property (nonatomic, assign) CGFloat ignoreValue;
/** 最小值 */
@property (nonatomic, assign, readonly) CGFloat minValue;
/** 最大值 */
@property (nonatomic, assign, readonly) CGFloat maxValue;
/** 步长 */
@property (nonatomic, assign, readonly) CGFloat step;
/** 一组步数 */
@property (nonatomic, assign, readonly) NSUInteger groupMaxNum;
/** 单位 */
@property (nonatomic, copy, readonly) NSString *unit;
/** 滑动代理 */
@property (nonatomic, weak) id<MBScaleplateSliderDelegate> delegate;
/** 实际选中值 */
@property (nonatomic, assign, readonly) CGFloat realValue;
/** 选中先颜色 */
@property (nonatomic, strong) UIColor *tintLineColor;
/** 文字标题颜色 */
@property (nonatomic, strong) UIColor *titleColor;
/** 文字标题是否需要underline */
@property (nonatomic, assign) BOOL hiddeUnderLine;
/** 是否开启手动输入数值 */
@property (nonatomic, assign) BOOL valueControlEnable;
/** 是否初始化是显示到中线位置 */
@property (nonatomic, assign) BOOL initialAtMiddle;
/** 当前选中值 */
@property (nonatomic, assign) CGFloat selectedValue;
/** 设置顶部文本是否显示 默认为no */
@property (nonatomic, assign) BOOL titleTextHidden;
/**
 初始化

 @param frame frame
 @param minValue 最小值
 @param maxValue 最大值
 @param step 步长
 @param groupMaxNum 一组步数
 @param unit 单位
 @param hasMiddleLine 是否显示中间长度线
 @return slider
 */
+ (instancetype)sliderWithFrame:(CGRect)frame minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue step:(CGFloat)step groupMaxNum:(NSUInteger)groupMaxNum unit:(NSString *)unit hasMiddleLine:(BOOL)hasMiddleLine;

/**
 初始化
 
 @param frame frame
 @param minValue 最小值
 @param maxValue 最大值
 @param step 步长
 @param groupMaxNum 一组步数
 @param unit 单位
 @param hasMiddleLine 是否显示中间长度线
 @return slider
 */
- (instancetype)initWithFrame:(CGRect)frame minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue step:(CGFloat)step groupMaxNum:(NSUInteger)groupMaxNum unit:(NSString *)unit hasMiddleLine:(BOOL)hasMiddleLine;

/**
 设置左右两侧蒙版

 @param layerColor 蒙版颜色 nil默认为白色
 */
- (void)addSideLayerWithColor:(UIColor *)layerColor;

@end

