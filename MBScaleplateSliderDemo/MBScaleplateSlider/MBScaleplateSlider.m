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
#define kScaleplateTextRulerFont [UIFont systemFontOfSize:9]    // 文字Font

#define kScaleplateGap 6        // 刻度间隔
#define kScaleplateLong 24      // 最长刻度
#define kScaleplateShort 12      // 最短刻度
#define kScaleplateMiddle 18    // 中线刻度

#pragma mark - Slider Content View
@interface MBRulerView : UIView
/** 最小值 */
@property (nonatomic, assign) NSUInteger minValue;
/** 最大值 */
@property (nonatomic, assign) NSUInteger maxValue;
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
            
            NSString *num = [NSString stringWithFormat:@"%.f%@", (i * step + _minValue), _unit];
            
            if ([num floatValue] > 1000000) { // 超过1000000后 格式化显示样式
                num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f, _unit];
            }
            
            NSDictionary *attribute = @{NSFontAttributeName:kScaleplateTextRulerFont,NSForegroundColorAttributeName:kScaleplateTextColor};
            CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
            [num drawInRect:CGRectMake(startX + kScaleplateGap * i - width / 2.0, kScaleplateLong + 5, width, 14) withAttributes:attribute];
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
@property (nonatomic, assign) NSUInteger maxValue;
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
    NSString *num = [NSString stringWithFormat:@"%@%@", @(_maxValue), _unit];
    if ([num floatValue] > 1000000) { // 超过1000000后 格式化显示样式
        num = [NSString stringWithFormat:@"%.f万%@",[num floatValue]/10000.f, _unit];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:kScaleplateTextRulerFont, NSForegroundColorAttributeName:kScaleplateTextColor};
    CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [num drawInRect:CGRectMake(0 - width / 2.0, kScaleplateLong  + 5, width, 14) withAttributes:attribute];
    
    CGContextAddLineToPoint(context,0, kScaleplateLong);
    CGContextStrokePath(context);
}

@end

#pragma mark - Slider Left View
@interface MBLeftRulerView : UIView
/** 最小值 */
@property (nonatomic, assign) NSUInteger minValue;
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
    NSString *num = [NSString stringWithFormat:@"%@%@", @(_minValue), _unit];
    if ([num floatValue] > 1000000) { // 超过1000000后 格式化显示样式
        num = [NSString stringWithFormat:@"%.f万%@",[num floatValue] / 10000.f, _unit];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:kScaleplateTextRulerFont,NSForegroundColorAttributeName:kScaleplateTextColor};
    CGFloat width = [num boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:0 attributes:attribute context:nil].size.width;
    [num drawInRect:CGRectMake(rect.size.width-width/2, kScaleplateLong + 5, width, 14) withAttributes:attribute];
    
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

@end

@implementation MBScaleplateSlider
/** 初始化 */
+ (instancetype)sliderWithFrame:(CGRect)frame minValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue step:(NSUInteger)step groupMaxNum:(NSUInteger)groupMaxNum unit:(NSString *)unit hasMiddleLine:(BOOL)hasMiddleLine {
    return [[self alloc] initWithFrame:frame minValue:minValue maxValue:maxValue step:step groupMaxNum:groupMaxNum unit:unit hasMiddleLine:hasMiddleLine];
}

- (instancetype)initWithFrame:(CGRect)frame minValue:(NSUInteger)minValue maxValue:(NSUInteger)maxValue step:(NSUInteger)step groupMaxNum:(NSUInteger)groupMaxNum unit:(NSString *)unit hasMiddleLine:(BOOL)hasMiddleLine {
    if(self = [super initWithFrame:frame]) {
        
        NSAssert(maxValue > 0, @"标尺最大值取值区间为大于0");
        NSAssert(minValue >= 0, @"标尺最小值区间为大于等于0");
        NSAssert(maxValue > minValue, @"标尺最大值不能小于设置的最小值");
        
        _minValue = minValue;
        _maxValue = maxValue;
        _step = step;
        _unit = unit;
        _groupMaxNum = groupMaxNum;
        _hasMiddleLine = hasMiddleLine;
        
        // 计算分组数量 （最大值-最小值）/ 步长 / 一组数量
        _stepNum = (_maxValue - _minValue) / _step / groupMaxNum;

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
}

#pragma mark - lazy load
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
        _valueTF.text = [NSString stringWithFormat:@"%@%@", @(_minValue), _unit];
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
    _valueTF.text = [NSString stringWithFormat:@"%@%@",@(_realValue * _step + _minValue), _unit];
    
    // collection 偏移至指定位置
    [_collectionView setContentOffset:CGPointMake((int)realValue*kScaleplateGap, 0) animated:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(MBScaleplateSlider:valueChange:)]) {
        [self.delegate MBScaleplateSlider:self valueChange:(realValue * _step + _minValue)];
    }
}

#pragma UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *newStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newStr intValue] > _maxValue) {
        _valueTF.text = [NSString stringWithFormat:@"%@%@", @(_maxValue), _unit];
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
        _valueTF.text = [NSString stringWithFormat:@"%@%@", @(value * _step + _minValue), _unit];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _onScroll = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) { // 拖拽时没有处于滑动动画状态
        self.realValue = round(scrollView.contentOffset.x/(kScaleplateGap));
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.realValue = round(scrollView.contentOffset.x / (kScaleplateGap)) ;
}

@end

