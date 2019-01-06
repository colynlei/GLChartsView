//
//  GLChartsView.m
//  HuobiPoolDapp
//
//  Created by 雷国林 on 2018/12/29.
//  Copyright © 2018 李辉. All rights reserved.
//

#import "GLChartsView.h"

@implementation HBPDChartsLineModel
@end

@implementation HBPDChartsAxisTextModel
@end

@interface HBPDChartsPointsModel : NSObject

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, copy) NSString *xAxisText;

@end

@implementation HBPDChartsPointsModel
@end

@interface GLChartsView ()<UIGestureRecognizerDelegate,CAAnimationDelegate>

@property (nonatomic, strong) CALayer *bgChartsLayer;
@property (nonatomic, strong) CALayer *yAxisLayer;
@property (nonatomic, strong) CALayer *xAxisLayer;

@property (nonatomic, strong) CAShapeLayer *mainChartsLayer;

@property (nonatomic, strong) NSMutableArray *yTextLayers;
@property (nonatomic, strong) NSMutableArray *xTextLayers;
@property (nonatomic, strong) NSMutableArray *lineVerticalLayers;//横线数组
@property (nonatomic, strong) NSMutableArray *lineHorizontalLayers;//竖线数组
@property (nonatomic, strong) NSMutableArray <HBPDChartsPointsModel *>*chartsPoints;

@property (nonatomic, assign) CGFloat yAxisTextMaxWidth;

@property (nonatomic, assign) CGFloat yTextGap;
@property (nonatomic, assign) CGFloat xTextGap;

@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UITapGestureRecognizer *tap;

@property (nonatomic, strong) UIView *highlightBgView;

@property (nonatomic, strong) CALayer *highlightVerticalLineLayer;
@property (nonatomic, strong) CALayer *highlightHorizontalLineLayer;

@property (nonatomic, strong) CALayer *highlightFocusLayer;//高亮中心点的视图

@end

@implementation GLChartsView

@synthesize yAxisModel = _yAxisModel, xAxisModel = _xAxisModel, yAxisTextModel = _yAxisTextModel, xAxisTextModel = _xAxisTextModel, chartsLineModel = _chartsLineModel, highlightVerticalLineModel = _highlightVerticalLineModel, highlightHorizontalLineModel = _highlightHorizontalLineModel;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultData];

        [self.layer addSublayer:self.bgChartsLayer];
        [self.layer addSublayer:self.mainChartsLayer];
        [self.layer addSublayer:self.xAxisLayer];
        [self.layer addSublayer:self.yAxisLayer];
        [self addSubview:self.highlightBgView];
        
        [self.highlightBgView.layer addSublayer:self.highlightVerticalLineLayer];
        [self.highlightBgView.layer addSublayer:self.highlightHorizontalLineLayer];
        [self.highlightBgView.layer addSublayer:self.highlightFocusLayer];
        
        [self addGestureRecognizer:self.tap];
        [self addGestureRecognizer:self.pan];
    }
    return self;
}

- (UIView *)highlightBgView {
    if (!_highlightBgView) {
        _highlightBgView = [UIView new];
        _highlightBgView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        _highlightBgView.alpha = 0;
    }
    return _highlightBgView;
}

- (void)initDefaultData {
    self.backgroundColor = [UIColor whiteColor];
    
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

- (HBPDChartsLineModel *)chartsLineModel {
    if (!_chartsLineModel) {
        _chartsLineModel = [[HBPDChartsLineModel alloc] init];
        _chartsLineModel.lineWidth = 1;
        _chartsLineModel.lineColor = [UIColor greenColor];
    }
    return _chartsLineModel;
}

- (void)setChartsLineModel:(HBPDChartsLineModel *)chartsLineModel {
    _chartsLineModel = chartsLineModel;
    [self setPoints:self.points];
}

- (HBPDChartsLineModel *)yAxisModel {
    if (!_yAxisModel) {
        _yAxisModel = [[HBPDChartsLineModel alloc] init];
        _yAxisModel.lineWidth = 1;
        _yAxisModel.lineColor = [UIColor colorWithWhite:0 alpha:0.2];
    }
    return _yAxisModel;
}

- (void)setYAxisModel:(HBPDChartsLineModel *)yAxisModel {
    _yAxisModel = yAxisModel;
    self.yAxisLayer.frame = CGRectMake(self.bgChartsLayer.left-yAxisModel.lineWidth, self.bgChartsLayer.top, yAxisModel.lineWidth, self.bgChartsLayer.height);
    self.yAxisLayer.backgroundColor = yAxisModel.lineColor.CGColor;
    self.yAxisLayer.hidden = yAxisModel.isHiden;
    
    CGRect rect = self.xAxisLayer.frame;
    rect.origin.x = self.bgChartsLayer.left-yAxisModel.lineWidth;
    rect.size.width = yAxisModel.lineWidth + self.bgChartsLayer.width;
    self.xAxisLayer.frame = rect;
}

- (HBPDChartsLineModel *)highlightHorizontalLineModel {
    if (!_highlightHorizontalLineModel) {
        _highlightHorizontalLineModel = [[HBPDChartsLineModel alloc] init];
        _highlightHorizontalLineModel.lineWidth = 1;
        _highlightHorizontalLineModel.lineColor = _highlightVerticalLineModel.lineColor;
    }
    return _highlightHorizontalLineModel;
}

- (void)setHighlightHorizontalLineModel:(HBPDChartsLineModel *)highlightHorizontalLineModel {
    _highlightHorizontalLineModel = highlightHorizontalLineModel;
    self.highlightHorizontalLineLayer.height = highlightHorizontalLineModel.lineWidth;
    self.highlightHorizontalLineLayer.backgroundColor = highlightHorizontalLineModel.lineColor.CGColor;
    self.highlightHorizontalLineLayer.hidden = highlightHorizontalLineModel.isHiden;
}


- (HBPDChartsLineModel *)xAxisModel {
    if (!_xAxisModel) {
        _xAxisModel = [[HBPDChartsLineModel alloc] init];
        _xAxisModel.lineWidth = 1;
        _xAxisModel.lineColor = self.yAxisModel.lineColor;
    }
    return _xAxisModel;
}

- (void)setXAxisModel:(HBPDChartsLineModel *)xAxisModel {
    _xAxisModel = xAxisModel;
    
    CGFloat x = self.bgChartsLayer.left-self.yAxisModel.lineWidth;
    CGFloat y = self.bgChartsLayer.top+self.bgChartsLayer.height;
    CGFloat w = self.bgChartsLayer.width+self.yAxisModel.lineWidth;
    CGFloat h = xAxisModel.lineWidth;
    self.xAxisLayer.frame = CGRectMake(x, y, w, h);
    self.xAxisLayer.backgroundColor = xAxisModel.lineColor.CGColor;
}

- (HBPDChartsLineModel *)highlightVerticalLineModel {
    if (!_highlightVerticalLineModel) {
        _highlightVerticalLineModel = [[HBPDChartsLineModel alloc] init];
        _highlightVerticalLineModel.lineWidth = 1;
        _highlightVerticalLineModel.lineColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return _highlightVerticalLineModel;
}

- (void)setHighlightVerticalLineModel:(HBPDChartsLineModel *)highlightVerticalLineModel {
    _highlightVerticalLineModel = highlightVerticalLineModel;
    self.highlightVerticalLineLayer.height = highlightVerticalLineModel.lineWidth;
    self.highlightVerticalLineLayer.backgroundColor = highlightVerticalLineModel.lineColor.CGColor;
    self.highlightVerticalLineLayer.hidden = highlightVerticalLineModel.isHiden;
}

- (HBPDChartsAxisTextModel *)yAxisTextModel {
    if (!_yAxisTextModel) {
        _yAxisTextModel = [[HBPDChartsAxisTextModel alloc] init];
        _yAxisTextModel.textColor = [UIColor blackColor];
        _yAxisTextModel.font = [UIFont systemFontOfSize:12];
        _yAxisTextModel.textToAxisGap = 2;
        _yAxisTextModel.textAlignment = NSTextAlignmentRight;
        _yAxisTextModel.lineWidth = 1;
        _yAxisTextModel.lineColor = [UIColor colorWithWhite:0 alpha:0.05];
    }
    return _yAxisTextModel;
}

- (void)setYAxisTextModel:(HBPDChartsAxisTextModel *)yAxisTextModel {
    _yAxisTextModel = yAxisTextModel;
    
    for (CATextLayer *textLayer in self.yTextLayers) {
        CGFloat w = [textLayer.string widthForFont:yAxisTextModel.font];
        self.yAxisTextMaxWidth = (self.yAxisTextMaxWidth>w)?self.yAxisTextMaxWidth:w;
    }
    
    self.yTextGap = (self.bgChartsLayer.height-yAxisTextModel.font.lineHeight)/(self.yTextLayers.count-1);
    CGFloat x = -(self.yAxisTextMaxWidth+yAxisTextModel.textToAxisGap);
    CGFloat w = self.yAxisTextMaxWidth;
    CGFloat h = yAxisTextModel.font.lineHeight;
    
    CATextLayerAlignmentMode alignment = [self transitionAlignment:yAxisTextModel.textAlignment];
    for (NSInteger i = self.yTextLayers.count-1; i >= 0 ; i--) {
        CATextLayer *textLayer = self.yTextLayers[i];
        textLayer.frame = CGRectMake(x, i*self.yTextGap, w, h);
        textLayer.alignmentMode = alignment;
        textLayer.font = yAxisTextModel.font.CGFontRef;
        textLayer.fontSize = yAxisTextModel.font.pointSize;
        textLayer.foregroundColor = yAxisTextModel.textColor.CGColor;
        
        CALayer *layer = self.lineHorizontalLayers[i];
        layer.frame = CGRectMake(0, h-yAxisTextModel.lineWidth+i*self.yTextGap, self.bgChartsLayer.width, yAxisTextModel.lineWidth);
        layer.backgroundColor = yAxisTextModel.lineColor.CGColor;
        if (i == self.self.lineHorizontalLayers.count-1) {
            [layer removeFromSuperlayer];
        }
    }
}

- (HBPDChartsAxisTextModel *)xAxisTextModel {
    if (!_xAxisTextModel) {
        _xAxisTextModel = [[HBPDChartsAxisTextModel alloc] init];
        _xAxisTextModel.textColor = [UIColor blackColor];
        _xAxisTextModel.font = [UIFont systemFontOfSize:12];
        _xAxisTextModel.textToAxisGap = 4;
        _xAxisTextModel.lineWidth = 1;
        _xAxisTextModel.lineColor = self.yAxisTextModel.lineColor;
    }
    return _xAxisTextModel;
}

- (void)setXAxisTextModel:(HBPDChartsAxisTextModel *)xAxisTextModel {
    _xAxisTextModel = xAxisTextModel;
    
    self.xTextGap = self.bgChartsLayer.width/(self.xTextLayers.count-1);
    CGFloat y = self.bgChartsLayer.height+xAxisTextModel.textToAxisGap;
    CGFloat h = xAxisTextModel.font.lineHeight;
    
    for (NSInteger i = 0; i < self.xAxisData.count ; i++) {
        CATextLayer *textLayer = self.xTextLayers[i];
        CGFloat w = [self.xAxisData[i] widthForFont:xAxisTextModel.font];
        textLayer.frame = CGRectMake(i*self.xTextGap-w/2, y, w, h);
        textLayer.font = xAxisTextModel.font.CGFontRef;
        textLayer.fontSize = xAxisTextModel.font.pointSize;
        textLayer.foregroundColor = xAxisTextModel.textColor.CGColor;
        
        CALayer *layer = self.lineVerticalLayers[i];
        layer.frame = CGRectMake(i*self.xTextGap-xAxisTextModel.lineWidth, 0, xAxisTextModel.lineWidth, self.bgChartsLayer.height);
        layer.backgroundColor = xAxisTextModel.lineColor.CGColor;
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
        _mainChartsLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
        
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

- (CALayer *)highlightHorizontalLineLayer {
    if (!_highlightHorizontalLineLayer) {
        _highlightHorizontalLineLayer = [CALayer layer];
        _highlightHorizontalLineLayer.backgroundColor = self.highlightHorizontalLineModel.lineColor.CGColor;
    }
    return _highlightHorizontalLineLayer;
}

- (CALayer *)highlightFocusLayer {
    if (!_highlightFocusLayer) {
        _highlightFocusLayer = [CALayer layer];
        _highlightFocusLayer.frame = CGRectMake(0, 0, 10, 10);
        
        CALayer *layer = [CALayer layer];
        layer.frame = _highlightFocusLayer.bounds;
        layer.backgroundColor = [UIColor redColor].CGColor;;
        layer.cornerRadius = layer.height/2;
        [_highlightFocusLayer addSublayer:layer];
    }
    return _highlightFocusLayer;
}

- (CALayer *)yAxisLayer {
    if (!_yAxisLayer) {
        _yAxisLayer = [CALayer layer];
        _yAxisLayer.backgroundColor = self.yAxisModel.lineColor.CGColor;
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
    [self setYAxisTextModel:self.yAxisTextModel];
}

- (CALayer *)xAxisLayer {
    if (!_xAxisLayer) {
        _xAxisLayer = [CALayer layer];
        _xAxisLayer.backgroundColor = self.xAxisModel.lineColor.CGColor;
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

- (NSMutableArray *)chartsPoints {
    if (!_chartsPoints) {
        _chartsPoints = [NSMutableArray arrayWithCapacity:0];
    }
    return _chartsPoints;
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
    [self setXAxisTextModel:self.xAxisTextModel];
}

- (void)setAxisMaxValue:(CGFloat)axisMaxValue {
    _axisMaxValue = axisMaxValue;
    [self setPoints:self.points];
}

- (void)setPoints:(NSArray<NSNumber *> *)points {
    _points = points;
    
    [self.chartsPoints removeAllObjects];
    CGFloat w = self.mainChartsLayer.width/(points.count-1);
    UIBezierPath *path = [UIBezierPath bezierPath];
    for (NSInteger i = 0; i < points.count; i++) {
        CGFloat a = [points[i] doubleValue];
        CGFloat x = i*w;
        CGFloat y = 0;
        if (self.axisMaxValue != 0) {
            y = (self.mainChartsLayer.height-self.yAxisTextModel.font.lineHeight)*a/self.axisMaxValue;
        }
        if (y < self.chartsLineModel.lineWidth/2) {
            y = self.chartsLineModel.lineWidth/2;
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
        
        [self.chartsPoints addObject:model];

    }
    self.mainChartsLayer.path = path.CGPath;
    self.mainChartsLayer.strokeColor = self.chartsLineModel.lineColor.CGColor;
    self.mainChartsLayer.lineWidth = self.chartsLineModel.lineWidth;
    
    if (self.isAnimation) {
        [self startAnimation];
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
            p = CGPointMake(CGRectGetMaxY(self.highlightBgView.frame), p.y);
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
    if (index >= self.chartsPoints.count) return;
    HBPDChartsPointsModel *model = self.chartsPoints[index];

    CGPoint focusPoint = CGPointMake(x, model.point.y);
    switch (state) {
        case UIGestureRecognizerStateBegan:
        {
            if (self.highlightBgView.alpha == 1) {
                [self resetFrameWithChangePoint:focusPoint];
            } else {
                [self resetFrameWithHighViewShow:focusPoint];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self resetFrameWithChangePoint:focusPoint];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self resetFrameWithChangePoint:focusPoint];
            [self performSelector:@selector(removeHighlightBgView) withObject:nil afterDelay:self.highlightTimeDelay];
        }
            break;
            
        default:
            break;
    }
}

- (void)resetFrameWithHighViewShow:(CGPoint)p {
    
    CGFloat V_w = self.highlightVerticalLineModel.lineWidth;
    CGFloat H_h = self.highlightHorizontalLineModel.lineWidth;
    
    [self.highlightFocusView viewWillShow];
    [UIView animateWithDuration:0.3 animations:^{
        [self.highlightFocusView viewDidShow];
        self.highlightBgView.alpha = 1;
    }];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    {
        self.highlightVerticalLineLayer.frame = CGRectMake(p.x-V_w/2, 0, V_w, self.mainChartsLayer.height);
        self.highlightHorizontalLineLayer.frame = CGRectMake(0, p.y-H_h/2, self.mainChartsLayer.width, H_h);
        
        CGRect rect = self.highlightFocusLayer.frame;
        rect.origin.x = p.x-self.highlightFocusLayer.width/2;
        rect.origin.y = p.y-self.highlightFocusLayer.height/2;
        self.highlightFocusLayer.frame = rect;
    }
    [CATransaction commit];
    
    if (!self.highlightView.superview) {
        [self.highlightBgView addSubview:self.highlightView];
        [self.highlightBgView.layer insertSublayer:self.highlightView.layer below:self.highlightFocusLayer];
    }
    self.highlightView.frame = [self highlightViewFrameFromPoint:p];
}

- (void)resetFrameWithChangePoint:(CGPoint)p {
    
    CGFloat V_w = self.highlightVerticalLineModel.lineWidth;
    CGFloat H_h = self.highlightHorizontalLineModel.lineWidth;
    
    self.highlightVerticalLineLayer.frame = CGRectMake(p.x-V_w/2, 0, V_w, self.mainChartsLayer.height);
    self.highlightHorizontalLineLayer.frame = CGRectMake(0, p.y-H_h/2, self.mainChartsLayer.width, H_h);
    
    CGRect rect = self.highlightFocusLayer.frame;
    rect.origin.x = p.x-self.highlightFocusLayer.width/2;
    rect.origin.y = p.y-self.highlightFocusLayer.height/2;
    self.highlightFocusLayer.frame = rect;
    
    [UIView animateWithDuration:[CATransaction animationDuration] animations:^{
        self.highlightView.frame = [self highlightViewFrameFromPoint:p];
    }];
}

- (void)removeHighlightBgView {
    [self.highlightFocusView viewWillHidden];
    [UIView animateWithDuration:0.3 animations:^{
        [self.highlightFocusView viewDidHidden];
        self.highlightBgView.alpha = 0;
    }];
}

- (void)setHighlightView:(GLChartsHighlightView *)highlightView {
    [_highlightView removeFromSuperview];
    _highlightView = highlightView;
    _highlightView.layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
}

- (void)setHighlightFocusView:(GLChartsHighlightFocusView *)highlightFocusView {
    [_highlightFocusView.layer removeFromSuperlayer];
    _highlightFocusView = highlightFocusView;
    highlightFocusView.userInteractionEnabled = NO;
    
    self.highlightFocusLayer.frame = highlightFocusView.bounds;
    self.highlightFocusLayer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    [self.highlightFocusLayer addSublayer:highlightFocusView.layer];
    highlightFocusView.layer.frame = highlightFocusView.bounds;
}

- (CGRect)highlightViewFrameFromPoint:(CGPoint)focusPoint {
    CGFloat x=0,y=0,w=self.highlightView.width,h=self.highlightView.height;
    if (focusPoint.x-self.highlightViewToVerticalLine-self.highlightVerticalLineModel.lineWidth/2 > w) {
        x = focusPoint.x-self.highlightViewToVerticalLine-self.highlightVerticalLineModel.lineWidth/2 - w;
    } else {
        x = focusPoint.x+self.highlightViewToVerticalLine+self.highlightVerticalLineModel.lineWidth/2;
    }
    if (self.highlightBgView.height - focusPoint.y - self.highlightHorizontalLineModel.lineWidth/2 - self.highlightViewToHorizontalLine > h) {
        y = focusPoint.y + self.highlightViewToHorizontalLine + self.highlightHorizontalLineModel.lineWidth/2;
    } else {
        y = focusPoint.y - h - self.highlightViewToHorizontalLine - self.highlightHorizontalLineModel.lineWidth/2;
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

- (void)startAnimation {
    CABasicAnimation *an = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    an.duration = self.animationDuration;
    an.repeatCount = 1;
    an.removedOnCompletion = YES;
    an.fromValue = @(0);
    an.toValue = @(1);
    an.delegate = self;
    an.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [self.mainChartsLayer addAnimation:an forKey:@"lineAnimationStrokeEnd"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag == YES) {
        [self.mainChartsLayer removeAnimationForKey:@"lineAnimationStrokeEnd"];
    }
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
    
    [self setYAxisModel:self.yAxisModel];
    [self setXAxisModel:self.xAxisModel];
    [self setYAxisTextModel:self.yAxisTextModel];
    [self setXAxisTextModel:self.xAxisTextModel];
    [self setHighlightVerticalLineModel:self.highlightVerticalLineModel];
    [self setHighlightHorizontalLineModel:self.highlightHorizontalLineModel];
    
}



@end
