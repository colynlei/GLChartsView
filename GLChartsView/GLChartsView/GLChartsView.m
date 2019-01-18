//
//  GLChartsView.m
//  HuobiPoolDapp
//
//  Created by 雷国林 on 2018/12/29.
//  Copyright © 2018 李辉. All rights reserved.
//

#import "GLChartsView.h"

@implementation GLLineItem
@end

@implementation GLChartsAxisTextItem
@end

@interface HBPDChartsPointsModel : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, copy) NSString *xAxisText;

@end

@implementation HBPDChartsPointsModel
@end

@implementation GLChartsLineItem
@end

@interface GLChartsView ()<UIGestureRecognizerDelegate,CAAnimationDelegate>

@property (nonatomic, strong) CALayer *bgChartsLayer;
@property (nonatomic, strong) CALayer *yAxisLayer;
@property (nonatomic, strong) CALayer *xAxisLayer;

@property (nonatomic, strong) CAShapeLayer *mainChartsLayer;
@property (nonatomic, strong) NSMutableArray *mainChartsLineLayers;

@property (nonatomic, strong) NSMutableArray *yTextLayers;
@property (nonatomic, strong) NSMutableArray *xTextLayers;
@property (nonatomic, strong) NSMutableArray *lineVerticalLayers;//横线数组
@property (nonatomic, strong) NSMutableArray *lineHorizontalLayers;//竖线数组
@property (nonatomic, strong) NSMutableArray <NSArray <HBPDChartsPointsModel *>*>*chartsPoints;

@property (nonatomic, assign) CGFloat yAxisTextMaxWidth;

@property (nonatomic, assign) CGFloat yTextGap;
@property (nonatomic, assign) CGFloat xTextGap;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UIView *highlightBgView;

@property (nonatomic, strong) CALayer *highlightVerticalLineLayer;

@property (nonatomic, assign) NSInteger currentPointIndex;
@property (nonatomic, assign) NSInteger maxPointsCount;

@property (nonatomic, strong) NSMutableArray *highlightFocusLayers;
@property (nonatomic, strong) NSMutableArray *highlightHorizontalLineLayers;


@end

@implementation GLChartsView

@synthesize yAxisItem = _yAxisItem, xAxisItem = _xAxisItem, yAxisTextItem = _yAxisTextItem, xAxisTextItem = _xAxisTextItem, highlightVerticalLineModel = _highlightVerticalLineModel, highlightHorizontalLineModel = _highlightHorizontalLineModel,highlightView = _highlightView;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        [self initDefaultData];

        [self.layer addSublayer:self.bgChartsLayer];
        [self.layer addSublayer:self.mainChartsLayer];
        [self.layer addSublayer:self.xAxisLayer];
        [self.layer addSublayer:self.yAxisLayer];
        [self addSubview:self.highlightBgView];
        
        [self.highlightBgView.layer addSublayer:self.highlightVerticalLineLayer];
//        [self.highlightBgView.layer addSublayer:self.highlightFocusLayer];
        
        
        [self addGestureRecognizer:self.tap];
        [self addGestureRecognizer:self.pan];
    }
    return self;
}

- (UIView *)highlightBgView {
    if (!_highlightBgView) {
        _highlightBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//        _highlightBgView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        _highlightBgView.alpha = 0;
//        _highlightBgView.backgroundColor = [UIColor redColor];
    }
    return _highlightBgView;
}

- (void)initDefaultData {
    self.backgroundColor = [UIColor whiteColor];
    self.currentPointIndex = NSIntegerMax;
    _mainChartsViewInset = UIEdgeInsetsMake(0, 40, 30, 20);
    _highlightViewToVerticalLine = 5;
    _highlightViewToHorizontalLine = 5;
    self.highlightTimeDelay = 2;
    self.isAnimation = YES;
    self.animationDuration = 1;
    self.yAxisData = @[@"",@"",@"",@"",@""];
    self.xAxisData = @[@"",@"",@"",@"",@"",@"",@""];
}

- (void)setChartsBackgroundColor:(UIColor *)chartsBackgroundColor {
    _chartsBackgroundColor = chartsBackgroundColor;
    self.bgChartsLayer.backgroundColor = chartsBackgroundColor.CGColor;
}

- (void)setMainChartsViewInset:(UIEdgeInsets)mainChartsViewInset {
    _mainChartsViewInset = mainChartsViewInset;
    [self setNeedsLayout];
}

//- (NSArray<GLLineItem *> *)chartsLineModels {
//    if (!_chartsLineModels) {
//        GLLineItem *model = [[GLLineItem alloc] init];
//        model.lineWidth = 1;
//        model.lineColor = [UIColor greenColor];
//        
//        _chartsLineModels = @[model];
//    }
//    return _chartsLineModels;
//}


- (GLLineItem *)yAxisItem {
    if (!_yAxisItem) {
        _yAxisItem = [[GLLineItem alloc] init];
        _yAxisItem.lineWidth = 1;
        _yAxisItem.lineColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _yAxisItem;
}

- (void)setyAxisItem:(GLLineItem *)yAxisItem {
    _yAxisItem = yAxisItem;
    self.yAxisLayer.frame = CGRectMake(self.bgChartsLayer.left-yAxisItem.lineWidth, self.bgChartsLayer.top, yAxisItem.lineWidth, self.bgChartsLayer.height);
    self.yAxisLayer.backgroundColor = yAxisItem.lineColor.CGColor;
    self.yAxisLayer.hidden = yAxisItem.isHiden;
    
    CGRect rect = self.xAxisLayer.frame;
    rect.origin.x = self.bgChartsLayer.left-yAxisItem.lineWidth;
    rect.size.width = yAxisItem.lineWidth + self.bgChartsLayer.width;
    self.xAxisLayer.frame = rect;
}

- (GLLineItem *)highlightHorizontalLineModel {
    if (!_highlightHorizontalLineModel) {
        _highlightHorizontalLineModel = [[GLLineItem alloc] init];
        _highlightHorizontalLineModel.lineWidth = 1;
        _highlightHorizontalLineModel.lineColor = _highlightVerticalLineModel.lineColor;
    }
    return _highlightHorizontalLineModel;
}

- (void)setHighlightHorizontalLineModel:(GLLineItem *)highlightHorizontalLineModel {
    _highlightHorizontalLineModel = highlightHorizontalLineModel;
}


- (GLLineItem *)xAxisItem {
    if (!_xAxisItem) {
        _xAxisItem = [[GLLineItem alloc] init];
        _xAxisItem.lineWidth = 1;
        _xAxisItem.lineColor = self.yAxisItem.lineColor;
    }
    return _xAxisItem;
}

- (void)setxAxisItem:(GLLineItem *)xAxisItem {
    _xAxisItem = xAxisItem;
    
    CGFloat x = self.bgChartsLayer.left-self.yAxisItem.lineWidth;
    CGFloat y = self.bgChartsLayer.top+self.bgChartsLayer.height;
    CGFloat w = self.bgChartsLayer.width+self.yAxisItem.lineWidth;
    CGFloat h = xAxisItem.lineWidth;
    self.xAxisLayer.frame = CGRectMake(x, y, w, h);
    self.xAxisLayer.backgroundColor = xAxisItem.lineColor.CGColor;
}

- (GLLineItem *)highlightVerticalLineModel {
    if (!_highlightVerticalLineModel) {
        _highlightVerticalLineModel = [[GLLineItem alloc] init];
        _highlightVerticalLineModel.lineWidth = 1;
        _highlightVerticalLineModel.lineColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _highlightVerticalLineModel;
}

- (void)setHighlightVerticalLineModel:(GLLineItem *)highlightVerticalLineModel {
    _highlightVerticalLineModel = highlightVerticalLineModel;
    self.highlightVerticalLineLayer.height = highlightVerticalLineModel.lineWidth;
    self.highlightVerticalLineLayer.backgroundColor = highlightVerticalLineModel.lineColor.CGColor;
    self.highlightVerticalLineLayer.hidden = highlightVerticalLineModel.isHiden;
}

- (GLChartsAxisTextItem *)yAxisTextItem {
    if (!_yAxisTextItem) {
        _yAxisTextItem = [[GLChartsAxisTextItem alloc] init];
        _yAxisTextItem.textColor = [UIColor blackColor];
        _yAxisTextItem.font = [UIFont systemFontOfSize:12];
        _yAxisTextItem.textToAxisGap = 2;
        _yAxisTextItem.textAlignment = NSTextAlignmentRight;
        _yAxisTextItem.lineWidth = 1;
        _yAxisTextItem.lineColor = [UIColor colorWithWhite:0 alpha:0.05];
    }
    return _yAxisTextItem;
}

- (void)setyAxisTextItem:(GLChartsAxisTextItem *)yAxisTextItem {
    _yAxisTextItem = yAxisTextItem;
    
    for (CATextLayer *textLayer in self.yTextLayers) {
        CGFloat w = [textLayer.string widthForFont:yAxisTextItem.font];
        self.yAxisTextMaxWidth = (self.yAxisTextMaxWidth>w)?self.yAxisTextMaxWidth:w;
    }
    
    self.yTextGap = (self.bgChartsLayer.height-yAxisTextItem.font.lineHeight)/(self.yTextLayers.count-1);
    CGFloat x = -(self.yAxisTextMaxWidth+yAxisTextItem.textToAxisGap);
    CGFloat w = self.yAxisTextMaxWidth;
    CGFloat h = yAxisTextItem.font.lineHeight;
    
    CATextLayerAlignmentMode alignment = [self transitionAlignment:yAxisTextItem.textAlignment];
    for (NSInteger i = self.yTextLayers.count-1; i >= 0 ; i--) {
        CATextLayer *textLayer = self.yTextLayers[i];
        textLayer.frame = CGRectMake(x, i*self.yTextGap, w, h);
        textLayer.alignmentMode = alignment;
        textLayer.font = yAxisTextItem.font.CGFontRef;
        textLayer.fontSize = yAxisTextItem.font.pointSize;
        textLayer.foregroundColor = yAxisTextItem.textColor.CGColor;
        
        CALayer *layer = self.lineHorizontalLayers[i];
        layer.frame = CGRectMake(0, h-yAxisTextItem.lineWidth+i*self.yTextGap, self.bgChartsLayer.width, yAxisTextItem.lineWidth);
        layer.backgroundColor = yAxisTextItem.lineColor.CGColor;
        if (i == self.self.lineHorizontalLayers.count-1) {
            [layer removeFromSuperlayer];
        }
    }
}

- (GLChartsAxisTextItem *)xAxisTextItem {
    if (!_xAxisTextItem) {
        _xAxisTextItem = [[GLChartsAxisTextItem alloc] init];
        _xAxisTextItem.textColor = [UIColor blackColor];
        _xAxisTextItem.font = [UIFont systemFontOfSize:12];
        _xAxisTextItem.textToAxisGap = 4;
        _xAxisTextItem.lineWidth = 1;
        _xAxisTextItem.lineColor = self.yAxisTextItem.lineColor;
    }
    return _xAxisTextItem;
}

- (void)setxAxisTextItem:(GLChartsAxisTextItem *)xAxisTextItem {
    _xAxisTextItem = xAxisTextItem;
    
    self.xTextGap = self.bgChartsLayer.width/(self.xTextLayers.count-1);
    CGFloat y = self.bgChartsLayer.height+xAxisTextItem.textToAxisGap;
    CGFloat h = xAxisTextItem.font.lineHeight;
    
    for (NSInteger i = 0; i < self.xAxisData.count ; i++) {
        CATextLayer *textLayer = self.xTextLayers[i];
        CGFloat w = [self.xAxisData[i] widthForFont:xAxisTextItem.font];
        textLayer.frame = CGRectMake(i*self.xTextGap-w/2, y, w, h);
        textLayer.font = xAxisTextItem.font.CGFontRef;
        textLayer.fontSize = xAxisTextItem.font.pointSize;
        textLayer.foregroundColor = xAxisTextItem.textColor.CGColor;
        
        CALayer *layer = self.lineVerticalLayers[i];
        layer.frame = CGRectMake(i*self.xTextGap-xAxisTextItem.lineWidth, 0, xAxisTextItem.lineWidth, self.bgChartsLayer.height);
        layer.backgroundColor = xAxisTextItem.lineColor.CGColor;
        if (i == 0) {
            [layer removeFromSuperlayer];
        }
    }
}

- (CATextLayerAlignmentMode)transitionAlignment:(NSTextAlignment)alignment {
    switch (alignment) {
        case NSTextAlignmentLeft:
            return kCAAlignmentLeft;
            break;
        case NSTextAlignmentCenter:
            return kCAAlignmentCenter;
            break;
        case NSTextAlignmentRight:
            return kCAAlignmentRight;
            break;
        case NSTextAlignmentNatural:
            return kCAAlignmentNatural;
            break;
        case NSTextAlignmentJustified:
            return kCAAlignmentJustified;
            break;
            
        default:
            break;
    }
}

- (CALayer *)bgChartsLayer {
    if (!_bgChartsLayer) {
        _bgChartsLayer = [CALayer layer];
        _bgChartsLayer.backgroundColor = self.chartsBackgroundColor.CGColor;
    }
    return _bgChartsLayer;
}

- (CAShapeLayer *)mainChartsLayer {
    if (!_mainChartsLayer) {
        _mainChartsLayer = [CAShapeLayer layer];
//        _mainChartsLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        
        _mainChartsLayer.fillColor = [UIColor clearColor].CGColor;
        _mainChartsLayer.lineCap = kCALineCapRound;
        _mainChartsLayer.lineJoin = kCALineJoinRound;
    }
    return _mainChartsLayer;
}

- (CALayer *)highlightVerticalLineLayer {
    if (!_highlightVerticalLineLayer) {
        _highlightVerticalLineLayer = [CALayer layer];
        _highlightVerticalLineLayer.backgroundColor = self.highlightVerticalLineModel.lineColor.CGColor;
    }
    return _highlightVerticalLineLayer;
}

- (CALayer *)yAxisLayer {
    if (!_yAxisLayer) {
        _yAxisLayer = [CALayer layer];
        _yAxisLayer.backgroundColor = self.yAxisItem.lineColor.CGColor;
    }
    return _yAxisLayer;
}

- (NSMutableArray *)yTextLayers {
    if (!_yTextLayers) {
        _yTextLayers = [NSMutableArray arrayWithCapacity:0];
    }
    return _yTextLayers;
}

- (void)setYAxisData:(NSArray<NSString *> *)yAxisData {
    _yAxisData = yAxisData;
//    if (!yAxisData || !yAxisData.count) return;

    [self.yTextLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.yTextLayers removeAllObjects];
    [self.lineHorizontalLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.lineHorizontalLayers removeAllObjects];
    
    for (NSInteger i = yAxisData.count-1; i >= 0 ; i--) {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = yAxisData[i];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.bgChartsLayer addSublayer:textLayer];
        [self.yTextLayers addObject:textLayer];

        CALayer *layer = [CALayer layer];
        [self.bgChartsLayer addSublayer:layer];
        [self.lineHorizontalLayers addObject:layer];
    }
    [self setyAxisTextItem:self.yAxisTextItem];
}

- (CALayer *)xAxisLayer {
    if (!_xAxisLayer) {
        _xAxisLayer = [CALayer layer];
        _xAxisLayer.backgroundColor = self.xAxisItem.lineColor.CGColor;
    }
    return _xAxisLayer;
}

- (NSMutableArray *)xTextLayers {
    if (!_xTextLayers) {
        _xTextLayers = [NSMutableArray arrayWithCapacity:0];
    }
    return _xTextLayers;
}

- (NSMutableArray *)lineVerticalLayers {
    if (!_lineVerticalLayers) {
        _lineVerticalLayers = [NSMutableArray arrayWithCapacity:0];
    }
    return _lineVerticalLayers;
}

- (NSMutableArray *)lineHorizontalLayers {
    if (!_lineHorizontalLayers) {
        _lineHorizontalLayers = [NSMutableArray arrayWithCapacity:0];
    }
    return _lineHorizontalLayers;
}

- (NSMutableArray<NSArray<HBPDChartsPointsModel *> *> *)chartsPoints {
    if (!_chartsPoints) {
        _chartsPoints = [NSMutableArray arrayWithCapacity:0];
    }
    return _chartsPoints;
}

- (NSMutableArray *)mainChartsLineLayers {
    if (!_mainChartsLineLayers) {
        _mainChartsLineLayers = [NSMutableArray arrayWithCapacity:0];
    }
    return _mainChartsLineLayers;
}

- (NSMutableArray *)highlightFocusLayers {
    if (!_highlightFocusLayers) {
        _highlightFocusLayers = [NSMutableArray arrayWithCapacity:0];
    }
    return _highlightFocusLayers;
}

- (NSMutableArray *)highlightHorizontalLineLayers {
    if (!_highlightHorizontalLineLayers) {
        _highlightHorizontalLineLayers = [NSMutableArray arrayWithCapacity:0];
    }
    return _highlightHorizontalLineLayers;
}

- (void)setXAxisData:(NSArray<NSString *> *)xAxisData {
    _xAxisData = xAxisData;
    if (!xAxisData || !xAxisData.count) return;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeHighlightBgView) object:nil];
    [self removeHighlightBgView];
    
    [self.xTextLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.xTextLayers removeAllObjects];
    [self.lineVerticalLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.lineVerticalLayers removeAllObjects];
    
    for (NSInteger i = 0; i < xAxisData.count ; i++) {
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.string = xAxisData[i];
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.bgChartsLayer addSublayer:textLayer];
        [self.xTextLayers addObject:textLayer];
        
        CALayer *layer = [CALayer layer];
        [self.bgChartsLayer addSublayer:layer];
        [self.lineVerticalLayers addObject:layer];
    }
    [self setxAxisTextItem:self.xAxisTextItem];
}

- (void)setAxisMaxValue:(CGFloat)axisMaxValue {
    _axisMaxValue = axisMaxValue;
    [self setChartsLines:self.chartsLines];
}

- (void)setChartsLines:(NSArray<GLChartsLineItem *> *)chartsLines {
    _chartsLines = chartsLines;
    
    [self.chartsPoints removeAllObjects];
    [self.mainChartsLineLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.mainChartsLineLayers removeAllObjects];
    [self.highlightFocusLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.highlightFocusLayers removeAllObjects];
    [self.highlightHorizontalLineLayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    [self.highlightHorizontalLineLayers removeAllObjects];
    
    self.maxPointsCount = 0;
    for (GLChartsLineItem *LineModel in chartsLines) {
        self.maxPointsCount = MAX(LineModel.points.count, self.maxPointsCount);
    }
    CGFloat w = self.mainChartsLayer.width/(self.maxPointsCount-1);

    for (NSInteger j = 0; j < chartsLines.count; j++) {
        
        GLChartsLineItem *item = chartsLines[j];
        
        item.focusView.userInteractionEnabled = NO;
        
        CGFloat gap = 1;
        CALayer *focusLayer = [CALayer layer];
        focusLayer.frame = CGRectMake(0, 0, item.focusView.width+2*gap, item.focusView.height+2*gap);
        item.focusView.layer.frame = CGRectMake(gap, gap, item.focusView.width, item.focusView.height);
        [focusLayer addSublayer:item.focusView.layer];
        [self.highlightFocusLayers addObject:focusLayer];
        
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.frame = self.mainChartsLayer.bounds;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        
        GLChartsLineItem *lineModel = chartsLines[j];
        
        NSMutableArray *chartsPointsInfos = [NSMutableArray arrayWithCapacity:0];
        for (NSInteger i = 0; i < lineModel.points.count; i++) {
            CGFloat a = [lineModel.points[i] doubleValue];
            CGFloat x = i*w;
            CGFloat y = self.mainChartsLayer.height-(self.mainChartsLayer.height-self.yAxisTextItem.font.lineHeight)*(a-self.axisMinValue)/(self.axisMaxValue-self.axisMinValue);
            if (y < lineModel.lineWidth/2) {
                y = lineModel.lineWidth/2;
            }
            CGPoint p = CGPointMake(x, y);
            if (i == 0) {
                [path moveToPoint:p];
            } else {
                [path addLineToPoint:p];
            }
            
            HBPDChartsPointsModel *model = [[HBPDChartsPointsModel alloc] init];
            model.point = p;
            model.xAxisText = self.xAxisData[i];
            
            [chartsPointsInfos addObject:model];
        }
        [self.chartsPoints addObject:chartsPointsInfos];
        
        layer.path = path.CGPath;
        layer.strokeColor = lineModel.lineColor.CGColor;
        layer.fillColor = [UIColor clearColor].CGColor;
        layer.lineWidth = lineModel.lineWidth;
        layer.lineCap = kCALineCapRound;
        layer.lineJoin = kCALineJoinRound;
        [self.mainChartsLineLayers addObject:layer];
        [self.mainChartsLayer addSublayer:layer];
        if (self.isAnimation) {
            [self startAnimation:layer];
        }
        
        CALayer *highlightHorizontalLineLayer = [CALayer layer];
        highlightHorizontalLineLayer.backgroundColor = self.highlightHorizontalLineModel.lineColor.CGColor;
        highlightHorizontalLineLayer.height = self.highlightHorizontalLineModel.lineWidth;
        highlightHorizontalLineLayer.hidden = self.highlightHorizontalLineModel.isHiden;
        [self.highlightBgView.layer addSublayer:highlightHorizontalLineLayer];
        [self.highlightBgView.layer insertSublayer:highlightHorizontalLineLayer below:self.highlightVerticalLineLayer];
        [self.highlightHorizontalLineLayers addObject:highlightHorizontalLineLayer];
    }
}

- (UITapGestureRecognizer *)tap {
    if (!_tap) {
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        _tap.delegate = self;
    }
    return _tap;
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    CGPoint p = [tap locationInView:self];
    if (CGRectContainsPoint(self.mainChartsLayer.frame, p)) {
        [self gestureWithPoint:p state:UIGestureRecognizerStateBegan];
        [self performSelector:@selector(removeHighlightBgView) withObject:nil afterDelay:self.highlightTimeDelay];
    }
}

- (UIPanGestureRecognizer *)pan {
    if (!_pan) {
        _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        _pan.delegate = self;
    }
    return _pan;
}

- (void)panAction:(UIPanGestureRecognizer *)pan {
    CGPoint p = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (p.y > CGRectGetMaxY(self.highlightBgView.frame)) {
            p = CGPointMake(p.x, CGRectGetMaxY(self.highlightBgView.frame));
        } else if (p.y < self.highlightBgView.frame.origin.y) {
            p = CGPointMake(p.x, self.highlightBgView.frame.origin.y);
        }
        if (p.x > CGRectGetMaxX(self.highlightBgView.frame)) {
            p = CGPointMake(CGRectGetMaxX(self.highlightBgView.frame), p.y);
        } else if (p.x < self.highlightBgView.frame.origin.x) {
            p = CGPointMake(self.highlightBgView.frame.origin.x, p.y);
        }
        [self gestureWithPoint:p state:pan.state];
    } else if (pan.state == UIGestureRecognizerStateBegan) {
        if (CGRectContainsPoint(self.mainChartsLayer.frame, p)) {
            [self gestureWithPoint:p state:pan.state];
        }
    }
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self performSelector:@selector(removeHighlightBgView) withObject:nil afterDelay:self.highlightTimeDelay];
    }
}

- (void)gestureWithPoint:(CGPoint)point state:(UIGestureRecognizerState)state {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(removeHighlightBgView) object:nil];
    
    CGPoint p = [self.mainChartsLayer convertPoint:point fromLayer:self.layer];
    NSInteger index = p.x/self.xTextGap;
    CGFloat x = index * self.xTextGap;
    if (x+self.xTextGap/2 < p.x) {
        x += self.xTextGap;
        index+=1;
    }
    if (index >= self.maxPointsCount || index == self.currentPointIndex) return;

    self.currentPointIndex = index;

    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            self.currentPointIndex = index;
            if (self.highlightBgView.alpha == 1) {
                [self resetFrameWithChangeWithIndex:index pointX:x];
            } else {
                [self resetFrameWithHighViewShowWithIndex:index pointX:x];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self resetFrameWithChangeWithIndex:index pointX:x];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self resetFrameWithChangeWithIndex:index pointX:x];
            [self performSelector:@selector(removeHighlightBgView) withObject:nil afterDelay:self.highlightTimeDelay];
        }
            break;
        default:
            break;
    }
}

- (void)resetFrameWithHighViewShowWithIndex:(NSInteger)index pointX:(CGFloat)x {
    [[NSNotificationCenter defaultCenter] postNotificationName:GLChartsViewFocusViewWillShow object:nil];
    [UIView animateWithDuration:0.5 animations:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GLChartsViewFocusViewDidShow object:nil];
        self.highlightBgView.alpha = 1;
    }];
    
    HBPDChartsPointsModel *topFocusItem = [[HBPDChartsPointsModel alloc] init];
    topFocusItem.point = CGPointMake(0, CGFLOAT_MAX);
    
    CGFloat V_w = self.highlightVerticalLineModel.lineWidth;
    CGFloat H_h = self.highlightHorizontalLineModel.lineWidth;
    for (NSInteger i = 0; i < self.highlightFocusLayers.count; i++) {
        NSArray *linePoint = self.chartsPoints[i];
        HBPDChartsPointsModel *currentPointItem = linePoint[index];
        CALayer *layer = self.highlightFocusLayers[i];
        if (!layer.superlayer) {
            [self.highlightBgView.layer addSublayer:layer];
        }
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        {
            if (i == 0) {
                self.highlightVerticalLineLayer.frame = CGRectMake(x-V_w/2, 0, V_w, self.mainChartsLayer.height);
            }
            CALayer *highlightHorizontalLineLayer = self.highlightHorizontalLineLayers[i];
            highlightHorizontalLineLayer.frame = CGRectMake(0, currentPointItem.point.y-H_h/2, self.mainChartsLayer.width, H_h);
            
            CGRect rect = layer.frame;
            rect.origin.x = x-layer.width/2;
            rect.origin.y = currentPointItem.point.y-layer.height/2;
            layer.frame = rect;
        }
        [CATransaction commit];
        
        topFocusItem = (currentPointItem.point.y>topFocusItem.point.y)?topFocusItem:currentPointItem;
    }
    
    if (!self.highlightView.superview) {
        [self.highlightBgView addSubview:self.highlightView];
    }
    self.highlightView.frame = [self highlightViewFrameFromPoint:topFocusItem.point];
    
}

- (void)resetFrameWithChangeWithIndex:(NSInteger)index pointX:(CGFloat)x{
    
    CGFloat V_w = self.highlightVerticalLineModel.lineWidth;
    CGFloat H_h = self.highlightHorizontalLineModel.lineWidth;
    self.highlightVerticalLineLayer.frame = CGRectMake(x-V_w/2, 0, V_w, self.mainChartsLayer.height);

    HBPDChartsPointsModel *topFocusItem = [[HBPDChartsPointsModel alloc] init];
    topFocusItem.point = CGPointMake(0, CGFLOAT_MAX);
    
    for (NSInteger i = 0; i < self.highlightFocusLayers.count; i++) {
        NSArray *linePoint = self.chartsPoints[i];
        HBPDChartsPointsModel *currentPointItem = linePoint[index];
        CALayer *layer = self.highlightFocusLayers[i];
        CGRect rect = layer.frame;
        rect.origin.x = x-layer.width/2;
        rect.origin.y = currentPointItem.point.y-layer.height/2;
        layer.frame = rect;
        
        CALayer *highlightHorizontalLineLayer = self.highlightHorizontalLineLayers[i];
        highlightHorizontalLineLayer.frame = CGRectMake(0, currentPointItem.point.y-H_h/2, self.mainChartsLayer.width, H_h);
        
        topFocusItem = (currentPointItem.point.y>topFocusItem.point.y)?topFocusItem:currentPointItem;
    }
    [UIView animateWithDuration:[CATransaction animationDuration] animations:^{
        self.highlightView.frame = [self highlightViewFrameFromPoint:topFocusItem.point];
    }];
}

- (void)removeHighlightBgView {
    self.currentPointIndex = NSUIntegerMax;
    [[NSNotificationCenter defaultCenter] postNotificationName:GLChartsViewFocusViewWillHidden object:nil];
    [UIView animateWithDuration:0.5 animations:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:GLChartsViewFocusViewDidHidden object:nil];
        self.highlightBgView.alpha = 0;
    }];
}

- (void)setHighlightView:(GLChartsHighlightView *)highlightView {
    [_highlightView removeFromSuperview];
    _highlightView = highlightView;
}

- (CGRect)highlightViewFrameFromPoint:(CGPoint)focusPoint {
    CGRect rect = CGRectZero;
    if (self.highlightView.highlightFrameBlock) {
        rect = self.highlightView.highlightFrameBlock(self.currentPointIndex);
    } else {
        rect = self.highlightView.bounds;
    }
    CGFloat x=0,y=0,w=rect.size.width,h=rect.size.height;
    if (focusPoint.x-self.highlightViewToVerticalLine-self.highlightVerticalLineModel.lineWidth/2 > w) {
        x = focusPoint.x-self.highlightViewToVerticalLine-self.highlightVerticalLineModel.lineWidth/2 - w;
    } else if (self.highlightBgView.width - focusPoint.x-self.highlightVerticalLineModel.lineWidth/2-self.highlightViewToVerticalLine < w) {
        x = self.highlightBgView.width-w;
    } else {
        x = focusPoint.x+self.highlightViewToVerticalLine+self.highlightVerticalLineModel.lineWidth/2;
    }
    if (focusPoint.y-self.highlightHorizontalLineModel.lineWidth/2-self.highlightViewToHorizontalLine > h) {
        y = focusPoint.y-self.highlightHorizontalLineModel.lineWidth/2-self.highlightViewToHorizontalLine - h;
    } else if (self.highlightBgView.height - focusPoint.y - self.highlightHorizontalLineModel.lineWidth/2 - self.highlightViewToHorizontalLine < h) {
        y = 0;
    } else {
        y = focusPoint.y + self.highlightViewToHorizontalLine + self.highlightHorizontalLineModel.lineWidth/2;
    }
    return CGRectMake(x, y, w, h);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if (gestureRecognizer == self.pan && [otherGestureRecognizer.view isKindOfClass:UIScrollView.class]) {
        CGPoint p = [gestureRecognizer locationInView:self];
        if (CGRectContainsPoint(self.mainChartsLayer.frame, p)) {
            return NO;
        }
        return YES;
    }
    return NO;
}

- (void)startAnimation:(CALayer *)layer {
    CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    an.duration = self.animationDuration*(self.xAxisData.count>self.yAxisData.count?(self.xAxisData.count/self.yAxisData.count):1);
    an.repeatCount = 1;
    an.removedOnCompletion = YES;
    an.fromValue = @(0);
    an.toValue = @(1);
    an.delegate = self;
    an.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [layer addAnimation:an forKey:@"lineAnimationStrokeEnd"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    [self.mainChartsLayer removeAnimationForKey:@"lineAnimationStrokeEnd"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat x = self.mainChartsViewInset.left;
    CGFloat y = self.mainChartsViewInset.top;
    CGFloat w = self.width - self.mainChartsViewInset.left - self.mainChartsViewInset.right;
    CGFloat h = self.height - self.mainChartsViewInset.top - self.mainChartsViewInset.bottom;
    self.bgChartsLayer.frame = CGRectMake(x, y, w, h);
    self.mainChartsLayer.frame = self.bgChartsLayer.frame;
    self.highlightBgView.frame = self.mainChartsLayer.frame;
    
    [self setyAxisItem:self.yAxisItem];
    [self setxAxisItem:self.xAxisItem];
    [self setyAxisTextItem:self.yAxisTextItem];
    [self setxAxisTextItem:self.xAxisTextItem];
    [self setHighlightVerticalLineModel:self.highlightVerticalLineModel];
    [self setHighlightHorizontalLineModel:self.highlightHorizontalLineModel];
    
}



@end
