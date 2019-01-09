//
//  ChartsCustomFocusViewController.m
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/4.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "ChartsCustomFocusViewController.h"
#import "CustomHighlightFocusView.h"

@interface ChartsCustomFocusViewController ()

@property (nonatomic, strong) GLChartsView *chartsView;
@property (nonatomic, strong) CustomHighlightFocusView *focusView;

@end

@implementation ChartsCustomFocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.chartsView];
}

- (GLChartsView *)chartsView {
    if (!_chartsView) {
        _chartsView = [[GLChartsView alloc] init];
        _chartsView.backgroundColor = kColorRandomAlpha(0.1);
        _chartsView.highlightFocusView = self.focusView;
    }
    return _chartsView;
}

- (CustomHighlightFocusView *)focusView {
    if (!_focusView) {
        _focusView = [[CustomHighlightFocusView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
//        _focusView.backgroundColor = [UIColor redColor];

    }
    return _focusView;
}

- (void)chartsData:(NSArray *)data {
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
    self.chartsView.points = points;
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
