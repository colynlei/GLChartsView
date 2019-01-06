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
#import "GLChartsHighlightFocusView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HBPDChartsLineModel : NSObject

@property (nonatomic, assign) CGFloat lineWidth;//线宽，默认1
@property (nonatomic, strong) UIColor *lineColor;//线颜色
@property (nonatomic, assign) BOOL isHiden;//是否隐藏，默认NO

@end

@interface HBPDChartsAxisTextModel : HBPDChartsLineModel

@property (nonatomic, strong) UIColor *textColor;//字体颜色，默认blackColor
@property (nonatomic, strong) UIFont *font;//字体大小，默认14
@property (nonatomic, assign) CGFloat textToAxisGap;//字体距离坐标轴的距离，y轴距右默认5，x轴距上默认2
@property (nonatomic, assign) NSTextAlignment textAlignment;//字体对其方式

@end



@interface GLChartsView : UIView

@property (nonatomic, strong) UIColor *chartsBackgroundColor;//图标区域背景色

@property (nonatomic, assign) UIEdgeInsets mainChartsViewInset;//主绘图区域距离四边的距离。

@property (nonatomic, strong) NSArray <NSString *>*yAxisData;
@property (nonatomic, strong) NSArray <NSString *>*xAxisData;
@property (nonatomic, strong) NSArray <NSNumber *>*points;

@property (nonatomic, strong) HBPDChartsLineModel *yAxisModel;
@property (nonatomic, strong) HBPDChartsLineModel *xAxisModel;
@property (nonatomic, strong) HBPDChartsLineModel *chartsLineModel;//折线宽度和颜色

@property (nonatomic, strong) HBPDChartsAxisTextModel *yAxisTextModel;
@property (nonatomic, strong) HBPDChartsAxisTextModel *xAxisTextModel;

@property (nonatomic, assign) CGFloat axisMaxValue;
@property (nonatomic, assign) CGFloat axisMinValue;

@property (nonatomic, assign) BOOL inverted;//Y轴是否上下翻转

@property (nonatomic, assign) BOOL isAnimation;//划线时是否动画，默认YES
@property (nonatomic, assign) CGFloat animationDuration;//动画时长，默认1s

@property (nonatomic, strong) HBPDChartsLineModel *highlightVerticalLineModel;//垂直高亮线属性设置
@property (nonatomic, strong) HBPDChartsLineModel *highlightHorizontalLineModel;//平行高亮线属性设置
@property (nonatomic, strong) GLChartsHighlightView *highlightView;//高亮视图，可添加点击视图
@property (nonatomic, strong) GLChartsHighlightFocusView *highlightFocusView;//高亮中心点的视图
@property (nonatomic, assign) CGFloat highlightViewToHorizontalLine;//高亮视图距离横向高亮线的距离
@property (nonatomic, assign) CGFloat highlightViewToVerticalLine;//高亮视图距离竖直高亮线的距离
@property (nonatomic, assign) CGFloat highlightTimeDelay;//高亮视图多长时间后消失，默认2s


@end

NS_ASSUME_NONNULL_END
