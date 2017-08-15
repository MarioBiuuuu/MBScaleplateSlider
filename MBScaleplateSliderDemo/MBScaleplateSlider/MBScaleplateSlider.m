//
//  MBScaleplateSlider.m
//  MBScaleplateSliderDemo
//
//  Created by ZhangXiaofei on 2017/6/1.
//  Copyright © 2017年 Yuri. All rights reserved.
//

#import "MBScaleplateSlider.h"

#define kScaleplateColor [UIColor greenColor]       // 刻度的颜色
#define kScaleplateTextColor [UIColor grayColor]    // 文字的颜色灰度
#define kScaleplateTextRulerFont [UIFont systemFontOfSize:11]    // 文字Font

#define kScaleplateGap 6        // 刻度间隔
#define kScaleplateLong 28      // 最长刻度
#define kScaleplateShort 14      // 最短刻度
#define kScaleplateMiddle 22    // 中线刻度

#pragma mark - Slider Content View
@interface MBRulerView : UIView
/** 最小值 */
@property (nonatomic, assign) CGFloat minValue;
/** 最大值 */
@property (nonatomic, assign) CGFloat maxValue;
/** 一组步数 */
@property (nonatomic, assign) NSUInteger maxGroupNum;
/** 是否显示中线刻度 */
@property (nonatomic, assign) BOOL hasMiddleLine;
/** 单位 */
@property (nonatomic, copy) NSString *unit;
@end

@implementation MBRulerView

/**
 绘制标尺内容

 @param rect rect
 */
- (void)drawRect:(CGRect)rect {
    // 起始位置
    CGFloat startX = 0;
    // 步长
    CGFloat step = (_maxValue - _minValue) / _maxGroupNum;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    // 设置线的颜色, 如果不设置默认是黑色的
//    CGContextSetRGBStrokeColor(context, dialColorGrayscale, dialColorGrayscale, dialColorGrayscale, 1);
    
    CGContextSetLineWidth(context, 0.5);//设置线的宽度, 默认是1像素
    CGContextSetLineCap(context, kCGLineCapButt);
    for (int i = 0; i<=_maxGroupNum; i++) { // 一个格子内最大刻度数量遍历
        if (i%_maxGroupNum == 0) { // 当前为最大刻度值
            CGContextMoveToPoint(context,startX + kScaleplateGap * i, 0); // x = 起使点 + 刻度间隔 * 刻度数
            
//            NSString *num = [NSString stringWithFormat:@"%.f%@", (i * step + _minValue), _unit];
            NSString *num = [NSString stringWithFormat:@"%.f", (i * step + _minValue)];
            if ([num floatValue] > 1000000) { // 超过1000000后 格式化显示样式
//                num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f, _unit];
                num = [NSString stringWithFormat:@"%.f万",[num floatValue]/10000.f];
            }
            
            NSDictionary *attribute = @{NSFontAttributeName:kScaleplateTextRulerFont,NSForegroundColorAttributeName:kScaleplateTextColor};
            CGSize size = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size;
            [num drawInRect:CGRectMake(startX + kScaleplateGap * i - size.width / 2.0, kScaleplateLong + 5, size.width, size.height + 3) withAttributes:attribute];
            CGContextAddLineToPoint(context,startX + kScaleplateGap * i,  kScaleplateLong);
        } else {
            if (_hasMiddleLine) { // 显示中线刻度
                if (ceil(_maxGroupNum * 0.5) == i) { // 中线刻度点
                    CGContextMoveToPoint(context,startX +  kScaleplateGap*i, 0);//起使点
                    CGContextAddLineToPoint(context,startX +  kScaleplateGap*i, kScaleplateMiddle);
                    
                } else {
                    CGContextMoveToPoint(context,startX +  kScaleplateGap*i, 0);//起使点
                    CGContextAddLineToPoint(context,startX +  kScaleplateGap*i, kScaleplateShort);
                    
                }
            } else {
                CGContextMoveToPoint(context,startX +  kScaleplateGap*i, 0);//起使点
                CGContextAddLineToPoint(context,startX +  kScaleplateGap*i, kScaleplateShort);
                
            }
        }
        CGContextStrokePath(context);
    }
}

@end

#pragma mark - Slider Right View
@interface MBRightRulerView : UIView
/** 最大值 */
@property (nonatomic, assign) CGFloat maxValue;
/** 单位 */
@property (nonatomic, copy) NSString *unit;
@end

@implementation MBRightRulerView

- (void)drawRect:(CGRect)rect {

    CGFloat longLineY = 0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置线的颜色, 如果不设置默认是黑色的
//    CGContextSetRGBStrokeColor(context, dialColorGrayscale, dialColorGrayscale, dialColorGrayscale, 1);
    
    CGContextSetStrokeColorWithColor(context, kScaleplateColor.CGColor);
    // 设置线的宽度, 默认是1像素
//    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, 0, longLineY);
//    NSString *num = [NSString stringWithFormat:@"%@%@", @(_maxValue), _unit];
    NSString *num = [NSString stringWithFormat:@"%@", @(_maxValue)];
    if ([num floatValue] > 1000000) { // 超过1000000后 格式化显示样式
//        num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f, _unit];
        num = [NSString stringWithFormat:@"%.f万",[num floatValue]/10000.f];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:kScaleplateTextRulerFont, NSForegroundColorAttributeName:kScaleplateTextColor};
    CGSize size = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size;
    [num drawInRect:CGRectMake(0 - size.width / 2.0, kScaleplateLong  + 5, size.width, size.height + 3) withAttributes:attribute];
    
    CGContextAddLineToPoint(context,0, kScaleplateLong);
    CGContextStrokePath(context);
}

@end

#pragma mark - Slider Left View
@interface MBLeftRulerView : UIView
/** 最小值 */
@property (nonatomic, assign) CGFloat minValue;
/** 单位 */
@property (nonatomic, copy) NSString *unit;
@end

@implementation MBLeftRulerView

- (void)drawRect:(CGRect)rect {
    CGFloat longLineY = 0;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 设置线的颜色, 如果不设置默认是黑色的
    //    CGContextSetRGBStrokeColor(context, dialColorGrayscale, dialColorGrayscale, dialColorGrayscale, 1);
    CGContextSetStrokeColorWithColor(context, kScaleplateColor.CGColor);
    
    // 设置线的宽度, 默认是1像素
    //    CGContextSetLineWidth(context, 1.0);
    CGContextSetLineCap(context, kCGLineCapButt);
    
    CGContextMoveToPoint(context, rect.size.width, longLineY);
//    NSString *num = [NSString stringWithFormat:@"%@%@", @(_minValue), _unit];
    NSString *num = [NSString stringWithFormat:@"%@", @(_minValue)];
    if ([num floatValue] > 1000000) { // 超过1000000后 格式化显示样式
//        num = [NSString stringWithFormat:@"%.f万%@",[num floatValue] / 10000.f, _unit];
        num = [NSString stringWithFormat:@"%.f万",[num floatValue] / 10000.f];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:kScaleplateTextRulerFont,NSForegroundColorAttributeName:kScaleplateTextColor};
    CGSize size = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size;
    [num drawInRect:CGRectMake(rect.size.width-size.width/2, kScaleplateLong + 5, size.width, size.height + 3) withAttributes:attribute];
    
    CGContextAddLineToPoint(context,rect.size.width, kScaleplateLong);
    CGContextStrokePath(context);
}

@end

#pragma mark - 装载刻度的collection cell
@interface MBRulerCollectionViewCell : UICollectionViewCell
/** 刻度view */
@property (nonatomic, strong) MBRulerView *rulerView;
@end

@implementation MBRulerCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        MBRulerView *ruleView = [[MBRulerView alloc] init];
        ruleView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:ruleView];
        self.rulerView = ruleView;
    }
    return self;
}

@end

#pragma mark - Slider
@interface MBScaleplateSlider ()<UIScrollViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
/** 数值显示控件，可开启是否可以直接输入数值 */
@property (nonatomic, strong) UITextField *valueTF;
/** 标尺容器 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 高亮选中刻度线 */
@property (nonatomic, strong) UIImageView  *tintLine;
/** 总分组数 */
@property (nonatomic, assign) NSUInteger stepNum;
/** 是否显示中线刻度 */
@property (nonatomic, assign) BOOL hasMiddleLine;
/** 记录当前是否处于滑动动画中 */
@property (nonatomic, assign) BOOL onScroll;

@property (nonatomic, strong) UIView *leftHUDView;
@property (nonatomic, strong) UIView *rightHUDView;
/** 左右两个蒙版视图的颜色，默认白色 */
@property (nonatomic, strong) UIColor *hudLayerColor;
/** 是否显示左右两个蒙版 */
@property (nonatomic, assign) BOOL showHUDLayer;
@end

@implementation MBScaleplateSlider
/** 初始化 */
+ (instancetype)sliderWithFrame:(CGRect)frame minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue step:(CGFloat)step groupMaxNum:(NSUInteger)groupMaxNum unit:(NSString *)unit hasMiddleLine:(BOOL)hasMiddleLine {
    return [[self alloc] initWithFrame:frame minValue:minValue maxValue:maxValue step:step groupMaxNum:groupMaxNum unit:unit hasMiddleLine:hasMiddleLine];
}

- (instancetype)initWithFrame:(CGRect)frame minValue:(CGFloat)minValue maxValue:(CGFloat)maxValue step:(CGFloat)step groupMaxNum:(NSUInteger)groupMaxNum unit:(NSString *)unit hasMiddleLine:(BOOL)hasMiddleLine {
    if(self = [super initWithFrame:frame]) {
        
        //        NSAssert(maxValue > 0, @"标尺最大值取值区间为大于0");
        //        NSAssert(minValue >= 0, @"标尺最小值区间为大于等于0");
        //        NSAssert(maxValue > minValue, @"标尺最大值不能小于设置的最小值");
        
        if (maxValue <= 0) {
            maxValue = 100;
        }
        
        if (minValue <= 0) {
            minValue = 0;
        }
        
        if (step <= 0) {
            step = 1;
        }
        
        if (maxValue <= minValue) {
            maxValue = 100;
            minValue = 0;
        }
        
        if (minValue + step * groupMaxNum > maxValue) {
            step = 1;
        }
        
        _minValue = minValue;
        _maxValue = maxValue;
        _step = step;
        _unit = unit;
        _groupMaxNum = groupMaxNum;
        _hasMiddleLine = hasMiddleLine;
        
        // 计算分组数量 （最大值-最小值）/ 步长 / 一组数量
        _stepNum = (_maxValue - _minValue) / _step / groupMaxNum;
//        if (_stepNum == 0) {
//            _step = 1;
//            _stepNum = (_maxValue - _minValue) / _step / groupMaxNum;
//        }
        
        if (_stepNum * groupMaxNum * _step < (_maxValue - _minValue)) {
            _stepNum += 1;
        }
        
        _maxValue = _stepNum * groupMaxNum * _step + _minValue;

        // 初始化当前处于非滑动动画状态
        _onScroll = NO;
        
        // 初始化UI
        [self initialUI];
    }
    return self;
}

- (void)initialUI {
    
    // 标尺
    [self addSubview:self.collectionView];
    
    // 数值显示
    [self addSubview:self.valueTF];
    
    // 标尺选中线
    [self addSubview:self.tintLine];
    
    [self addSubview:self.leftHUDView];
    
    [self addSubview:self.rightHUDView];
}

#pragma mark - lazy load
- (UIView *)leftHUDView {
    if (!_leftHUDView) {
        _leftHUDView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width / 5.0, CGRectGetHeight(self.frame))];
        _leftHUDView.backgroundColor = [UIColor clearColor];
    }
    return _leftHUDView;
}

- (UIView *)rightHUDView {
    if (!_rightHUDView) {
        _rightHUDView = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width / 5.0, 0, [UIScreen mainScreen].bounds.size.width / 5.0, CGRectGetHeight(self.frame))];
        _rightHUDView.backgroundColor = self.backgroundColor;
    }
    return _rightHUDView;
}

- (UIImageView *)tintLine {
    if (!_tintLine) {
        _tintLine = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width/2-0.5, CGRectGetMinY(self.collectionView.frame), 1.5, kScaleplateLong)];
        _tintLine.backgroundColor = [UIColor orangeColor];
    }
    return _tintLine;
}

- (UITextField *)valueTF {
    if (!_valueTF) {
        _valueTF = [[UITextField alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.collectionView.frame) - 20 - 10, self.frame.size.width, 20)];
        _valueTF.defaultTextAttributes = @{NSUnderlineColorAttributeName:[UIColor blackColor],
                                           NSUnderlineStyleAttributeName:@(0),
                                           NSFontAttributeName:[UIFont systemFontOfSize:18],
                                           NSForegroundColorAttributeName:[UIColor blackColor]};
        _valueTF.textAlignment = NSTextAlignmentCenter;
        _valueTF.delegate = self;
        _valueTF.keyboardType  = UIKeyboardTypeNumberPad;
        _valueTF.userInteractionEnabled = NO;
        NSDictionary *attribute = @{NSUnderlineColorAttributeName:[UIColor lightGrayColor],
                                    NSUnderlineStyleAttributeName:@(0),
                                    NSFontAttributeName:[UIFont systemFontOfSize:18],
                                    NSForegroundColorAttributeName:[UIColor grayColor]};
        _valueTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"滑动标尺或输入" attributes:attribute];
        _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (_minValue), _unit];
        _valueTF.hidden = self.titleTextHidden;

    }
    return _valueTF;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc]init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        _collectionView  =[[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_valueTF.frame) + 20, self.bounds.size.width, 50) collectionViewLayout:flowLayout];
        _collectionView.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5 + 20);
        if (self.titleTextHidden) {
            _collectionView.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5 + 5);
        } else {
            _collectionView.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5 + 20);
        }
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"borderLeftCell"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"borderRightCell"];
        [_collectionView registerClass:[MBRulerCollectionViewCell class] forCellWithReuseIdentifier:@"contentCell"];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.bounces = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
    }
    return _collectionView;
}

#pragma setter
- (void)setTitleTextHidden:(BOOL)titleTextHidden {
    _titleTextHidden = titleTextHidden;
    self.valueTF.hidden = titleTextHidden;
    if (titleTextHidden) {
        self.collectionView.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5 + 5);
    } else {
        self.collectionView.center = CGPointMake(CGRectGetWidth(self.frame) * 0.5, CGRectGetHeight(self.frame) * 0.5 + 20);
    }
    self.tintLine.frame = CGRectMake(self.bounds.size.width/2-0.5, CGRectGetMinY(self.collectionView.frame), 1.5, kScaleplateLong);
}

- (void)setTitleColor:(UIColor *)titleColor {
    if (!titleColor) {
        _titleColor = [UIColor orangeColor];
    }
    _titleColor = titleColor;
//    self.valueTF.textAlignment = NSTextAlignmentCenter;
//    NSDictionary *attribute = @{NSUnderlineColorAttributeName:[UIColor lightGrayColor],
//                                NSUnderlineStyleAttributeName:@(1),
//                                NSFontAttributeName:[UIFont systemFontOfSize:18],
//                                NSForegroundColorAttributeName:[UIColor grayColor]};
//
//    self.valueTF.defaultTextAttributes = attribute;
}

- (void)setInitialAtMiddle:(BOOL)initialAtMiddle {
    _initialAtMiddle = initialAtMiddle;
    if (initialAtMiddle) {
        // 设置初次显示位置
        self.realValue = round((_groupMaxNum * _stepNum) / 2.0);

    }
}

- (void)setSelectedValue:(CGFloat)selectedValue {
    _selectedValue = selectedValue;
    if (selectedValue < self.minValue || selectedValue > self.maxValue) {
        self.realValue = round((_groupMaxNum * _stepNum) / 2.0);
        return;
    }
    self.realValue = round((_groupMaxNum * _stepNum) * ((selectedValue - self.minValue) / (self.maxValue - self.minValue)));
    _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (selectedValue), _unit];
    
    if (self.openIgnore) {
        if (self.ignoreValue == 0) {
            if ([_valueTF.text floatValue] > (_ignoreValue-0.000001) && [_valueTF.text floatValue] < (0.000001 + _ignoreValue)) {
                _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (_step), _unit];
                [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:0];
            }
        } else {
            if ([_valueTF.text floatValue] <= _ignoreValue) {
                _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (_step + _ignoreValue), _unit];
                [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:0];
                
            }
        }
    }
}

- (void)setIgnoreValue:(CGFloat)ignoreValue {
    _ignoreValue = ignoreValue;
    
    if (self.ignoreValue == 0) {
        if ([_valueTF.text floatValue] > (_ignoreValue-0.000001) && [_valueTF.text floatValue] < (0.000001 + _ignoreValue)) {
            _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (_step), _unit];
            [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:0];
            
        }
    } else {
        if ([_valueTF.text floatValue] <= _ignoreValue) {
            _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (_step + _ignoreValue), _unit];
            [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:0];
            
        }
    }
}

- (void)setValueControlEnable:(BOOL)valueControlEnable {
    _valueControlEnable = valueControlEnable;
    self.valueTF.userInteractionEnabled = valueControlEnable;
}

- (void)setTintLineColor:(UIColor *)tintLineColor {
    _tintLineColor = tintLineColor;
    self.tintLine.backgroundColor = tintLineColor;
}

- (void)setRealValue:(CGFloat)realValue {
    _realValue = realValue;
    
    // 设置数值显示
    _valueTF.text = [NSString stringWithFormat:@"%.1f%@",(_realValue * _step + _minValue), _unit];
    
    // collection 偏移至指定位置
    [_collectionView setContentOffset:CGPointMake((int)realValue*kScaleplateGap, 0) animated:NO];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(MBScaleplateSlider:valueChange:)]) {
        [self.delegate MBScaleplateSlider:self valueChange:(realValue * _step + _minValue)];
    }
}

- (void)addSideLayerWithColor:(UIColor *)layerColor {
    if (layerColor) {
        _hudLayerColor = layerColor;
    } else {
        _hudLayerColor = [UIColor whiteColor];
    }
    if ([self.leftHUDView viewWithTag:9099]) {
        [[self.leftHUDView viewWithTag:9099] removeFromSuperview];
    }
    
    if ([self.rightHUDView viewWithTag:9099]) {
        [[self.rightHUDView viewWithTag:9099] removeFromSuperview];
    }
    
    [self setSideLayer:self.leftHUDView];
    [self setSideLayer:self.rightHUDView];
}

- (void)setSideLayer:(UIView *)originalView {
    UIView *gradView = [[UIView alloc] initWithFrame:originalView.bounds];
    gradView.tag = 9099;
    gradView.backgroundColor = [UIColor clearColor];
    gradView.layer.backgroundColor = [UIColor clearColor].CGColor;
    CAGradientLayer *layer = [self getGradientWithFrame:gradView.bounds left:[originalView isEqual:self.leftHUDView]];
    [gradView.layer insertSublayer:layer atIndex:0];
    [originalView addSubview:gradView];
    
}

- (CAGradientLayer *)getGradientWithFrame:(CGRect)frame left:(BOOL)left {
    
   // const CGFloat *components = CGColorGetComponents(_hudLayerColor.CGColor);
    
    CGFloat components[3];
    [self getRGBComponents:components forColor:_hudLayerColor];
    NSLog(@"%f %f %f", components[0], components[1], components[2]);

    CGFloat red = components[0];
    CGFloat green = components[1];
    CGFloat blue = components[2];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    
    gradientLayer.frame = frame;
    if (left) {
        gradientLayer.colors = @[(id)[UIColor colorWithRed:red green:green blue:blue alpha:0.4].CGColor,
                                 (id)[UIColor colorWithRed:red green:green blue:blue alpha:0.6].CGColor,
                                 (id)[UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor];
        gradientLayer.startPoint = CGPointMake(1, 0);
        gradientLayer.endPoint = CGPointMake(0, 0);

    } else {
        gradientLayer.colors = @[(id)[UIColor colorWithRed:red green:green blue:blue alpha:0.4].CGColor,
                                 (id)[UIColor colorWithRed:red green:green blue:blue alpha:0.6].CGColor,
                                 (id)[UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
    }
    gradientLayer.locations = @[@(0.1f) ,@(0.4f)];

    return gradientLayer;
}

- (void)getRGBComponents:(CGFloat [3])components forColor:(UIColor *)color {
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    
    unsigned char resultingPixel[4];
    
    CGContextRef context = CGBitmapContextCreate(&resultingPixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo)kCGImageAlphaNoneSkipLast);
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    CGContextRelease(context);
    
    CGColorSpaceRelease(rgbColorSpace);
    
    for (int component = 0; component < 3; component++) {
        
        components[component] = resultingPixel[component] / 255.0f;
        
    }
    
}

#pragma UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newStr intValue] > _maxValue) {
        _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (_maxValue), _unit];
        [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:0];
        return NO;
    } else {
        _onScroll = NO;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:1];
        return YES;
    }
}

- (void)didChangeValue {
    self.realValue = ([_valueTF.text floatValue] / _step);
}

#pragma mark UICollectionView DataSource & Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2 + _stepNum;    //  （左视图 + 右视图）+ 内容长度 = CollectionView item数量
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0 || indexPath.item == _stepNum + 1) { // 第一组和最后一组显示左右视图

        if (indexPath.item == 0) {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"borderLeftCell" forIndexPath:indexPath];
            
            if (![cell viewWithTag:10001]) {
                MBLeftRulerView *leftView = [[MBLeftRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, 50)];
                leftView.backgroundColor = self.backgroundColor;

                leftView.minValue = _minValue;
                leftView.unit = _unit;
                leftView.tag = 10001;
                [cell.contentView addSubview:leftView];
            }
            return cell;
        } else {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"borderRightCell" forIndexPath:indexPath];
            if (![cell viewWithTag:10002]) {
                MBRightRulerView *rightView = [[MBRightRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width/2, 50)];
                rightView.backgroundColor = self.backgroundColor;

//                rightView.maxValue = _maxValue;
                // 用以解决设置的配置信息难以满足显示逻辑 比如步长 总数 最大值 最小值 不匹配
                rightView.maxValue = _minValue + _stepNum * _groupMaxNum * _step;
                rightView.unit = _unit;
                rightView.tag = 10002;
                [cell.contentView addSubview:rightView];
            }
            return cell;
        }
        
    } else {
        MBRulerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"contentCell" forIndexPath:indexPath];
        CGFloat maxNum = _groupMaxNum * 1.0;
        cell.rulerView.frame = CGRectMake(0, 0, kScaleplateGap*maxNum, 50);
        cell.rulerView.unit = _unit;
        
        cell.rulerView.minValue = _step*maxNum*(indexPath.item-1) + _minValue;
        cell.rulerView.maxValue = _step*maxNum*indexPath.item  + _minValue;
        cell.rulerView.maxGroupNum = _groupMaxNum;
        cell.rulerView.hasMiddleLine = _hasMiddleLine;
        [cell.rulerView setNeedsDisplay];
        
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item == 0 || indexPath.item == _stepNum + 1) {
        return CGSizeMake(self.frame.size.width/2.0, 50.f);
    } else {
        CGFloat maxNum = _groupMaxNum * 1.0;
        return CGSizeMake((kScaleplateGap * maxNum), 50.f);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_onScroll) {
        NSUInteger value = scrollView.contentOffset.x / (kScaleplateGap);
        _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (value * _step + _minValue), _unit];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _onScroll = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) { // 拖拽时没有处于滑动动画状态
        if (self.openIgnore) {
            if (self.ignoreValue == 0) {
                if ([_valueTF.text floatValue] > (_ignoreValue-0.000001) && [_valueTF.text floatValue] < (0.000001 + _ignoreValue)) {
                    _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (_step), _unit];
                    [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:0];
                    
                } else {
                    self.realValue = round(scrollView.contentOffset.x/(kScaleplateGap));

                }
            } else {
                if ([_valueTF.text floatValue] <= _ignoreValue) {
                    _valueTF.text = [NSString stringWithFormat:@"%.1f%@", (_step + _ignoreValue), _unit];
                    [self performSelector:@selector(didChangeValue) withObject:nil afterDelay:0];
                } else {
                    self.realValue = round(scrollView.contentOffset.x/(kScaleplateGap));

                }
            }
        } else {
            self.realValue = round(scrollView.contentOffset.x/(kScaleplateGap));
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.realValue = round(scrollView.contentOffset.x / (kScaleplateGap)) ;
}

@end

