//
//  ChartsCustomAllViewController.m
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/10.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "ChartsCustomAllViewController.h"
#import "CustomHighlightFocusAnimationView.h"
#import "CustomHighlightView2.h"
#import <GLMacro.h>

@interface ChartsCustomAllViewController ()

@property (nonatomic, strong) GLChartsView *chartsView;
@property (nonatomic, strong) CustomHighlightView2 *highlightView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation ChartsCustomAllViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.chartsView];
}

- (GLChartsView *)chartsView {
    if (!_chartsView) {
        _chartsView = [[GLChartsView alloc] init];
        _chartsView.backgroundColor = kColorRandomAlpha(0.1);
        _chartsView.highlightView = self.highlightView;
        _chartsView.highlightViewToVerticalLine = 7;
        _chartsView.highlightViewToHorizontalLine = 7;
    }
    return _chartsView;
}

- (CustomHighlightFocusAnimationView *)focusViewWithColor:(UIColor *)color {
    CustomHighlightFocusAnimationView *focusView = [[CustomHighlightFocusAnimationView alloc] initWithFrame:CGRectMake(0, 0, 8, 8)];
    focusView.focusColor = color;
    return focusView;
}

- (CustomHighlightView2 *)highlightView {
    if (!_highlightView) {
        _highlightView = [[CustomHighlightView2 alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        _highlightView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        _highlightView.layer.cornerRadius = 6;
        _highlightView.layer.masksToBounds = YES;
        //        _highlightView.layer.shouldRasterize = YES;
        kWeakSelf(self);
        _highlightView.highlightFrameBlock = ^CGRect(NSInteger currentIndex) {
            kStrongSelf(self);
            return [strongself->_highlightView currentPointData:strongself.data[currentIndex]];
        };
    }
    return _highlightView;
}

- (void)chartsData:(NSArray *)data {
    self.data = data;
    NSInteger max = 0;
    NSInteger mix = 0;
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *xData =[NSMutableArray arrayWithCapacity:0];
    for (NSInteger i = 0; i < data.count; i++) {
        NSDictionary *dic = data[i];
        NSInteger y = [dic[@"temp"] integerValue];
        max = max>y?max:y;
        mix = mix>y?y:mix;
        [points addObject:dic[@"temp"]];
        [xData addObject:dic[@"date"]];
    }
    
    NSInteger t = max -mix;
    CGFloat p = t/7.0;
    
    CGFloat y=mix;
    NSInteger b = 0;
    NSMutableArray *arr = [NSMutableArray arrayWithObject:[NSString stringWithFormat:@"%ld",(NSInteger)mix]];
    while (b < 7) {
        b++;
        y += p;
        [arr addObject:[NSString stringWithFormat:@"%ld",(NSInteger)y]];
    }
    
    self.chartsView.axisMaxValue = max;
    self.chartsView.axisMinValue = mix;
    self.chartsView.yAxisData = arr;
    self.chartsView.xAxisData = xData;

    GLChartsLineItem *model1 = [[GLChartsLineItem alloc] init];
    model1.points = points;
    model1.lineColor = [UIColor redColor];
    model1.lineWidth = 1;
    model1.focusView = [self focusViewWithColor:[UIColor redColor]];
    
    self.chartsView.chartsLines = @[model1];

}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat h = 200;
    self.chartsView.frame = CGRectMake(0, self.view.height/2-h/2, kScreenWidth, 200);
    
    CGRect rect = self.segmentedContrl.frame;
    rect.origin.y = CGRectGetMaxY(self.chartsView.frame)+20;
    self.segmentedContrl.frame = rect;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
