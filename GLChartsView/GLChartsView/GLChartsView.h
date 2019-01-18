//
//  GLChartsView.h
//  HuobiPoolDapp
//
//  Created by 雷国林 on 2018/12/29.
//  Copyright © 2018 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLChartsUtils.h"
#import "GLChartsHighlightView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLLineItem : NSObject

@property (nonatomic, assign) CGFloat lineWidth;//线宽，默认1
@property (nonatomic, strong) UIColor *lineColor;//线颜色
@property (nonatomic, assign) BOOL isHiden;//是否隐藏，默认NO

@end

@interface GLChartsAxisTextItem : GLLineItem

@property (nonatomic, strong) UIColor *textColor;//字体颜色，默认blackColor
@property (nonatomic, strong) UIFont *font;//字体大小，默认14
@property (nonatomic, assign) CGFloat textToAxisGap;//字体距离坐标轴的距离，y轴距右默认5，x轴距上默认2
@property (nonatomic, assign) NSTextAlignment textAlignment;//字体对其方式

@end

@interface GLChartsLineItem : GLLineItem

@property (nonatomic, strong) NSArray <NSNumber *>*points;
@property (nonatomic, strong) GLLineItem *lineItem;
@property (nonatomic, strong) UIView *focusView;

@end


@interface GLChartsView : UIView

@property (nonatomic, strong) UIColor *chartsBackgroundColor;//图标区域背景色

@property (nonatomic, assign) UIEdgeInsets mainChartsViewInset;//主绘图区域距离四边的距离。

@property (nonatomic, strong) GLLineItem *yAxisItem;//纵轴配置
@property (nonatomic, strong) GLLineItem *xAxisItem;//横轴配置

@property (nonatomic, strong) GLChartsAxisTextItem *yAxisTextItem;//纵轴文字配置
@property (nonatomic, strong) GLChartsAxisTextItem *xAxisTextItem;//横轴文字配置

@property (nonatomic, strong) NSArray <NSString *>*yAxisData;//纵轴显示文字数组
@property (nonatomic, strong) NSArray <NSString *>*xAxisData;//横轴显示文字数组

@property (nonatomic, strong) NSArray <GLChartsLineItem *>*chartsLines;//折线图配置数组。

@property (nonatomic, assign) CGFloat axisMaxValue;//最大值
@property (nonatomic, assign) CGFloat axisMinValue;//最小值

//@property (nonatomic, assign) BOOL inverted;//Y轴是否上下翻转

@property (nonatomic, assign) BOOL isAnimation;//划线时是否动画，默认YES
@property (nonatomic, assign) CGFloat animationDuration;//动画时长，默认1s

@property (nonatomic, strong) GLLineItem *highlightVerticalLineModel;//垂直高亮线属性设置
@property (nonatomic, strong) GLLineItem *highlightHorizontalLineModel;//平行高亮线属性设置
@property (nonatomic, strong) GLChartsHighlightView *highlightView;//高亮视图，可添加点击视图
@property (nonatomic, assign) CGFloat highlightViewToHorizontalLine;//高亮视图距离横向高亮线的距离
@property (nonatomic, assign) CGFloat highlightViewToVerticalLine;//高亮视图距离竖直高亮线的距离
@property (nonatomic, assign) CGFloat highlightTimeDelay;//高亮视图多长时间后消失，默认2s


@end

NS_ASSUME_NONNULL_END
