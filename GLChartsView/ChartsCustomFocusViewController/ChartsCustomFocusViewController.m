//
//  ChartsCustomFocusViewController.m
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/4.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "ChartsCustomFocusViewController.h"

@interface ChartsCustomFocusViewController ()

@property (nonatomic, strong) GLChartsView *chartsView;

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
        //        _chartsView.backgroundColor = kColorRandomAlpha(0.1);
        _chartsView.chartsBackgroundColor = [UIColor clearColor];
        _chartsView.mainChartsViewInset = UIEdgeInsetsMake(0, 40, 20, 30);
        _chartsView.yAxisModel.lineWidth = 1;
        _chartsView.yAxisModel.lineColor = [UIColor blackColor];
        _chartsView.yAxisModel.isHiden = YES;
        _chartsView.xAxisModel.lineWidth = 1;
        _chartsView.xAxisModel.lineColor = [UIColor colorWithHexString:@"#E9ECEF"];
        _chartsView.yAxisTextModel.textColor = [UIColor colorWithHexString:@"#626D86"];
        _chartsView.yAxisTextModel.font = kFont_Regular(11);
        _chartsView.yAxisTextModel.textToAxisGap = 2;
        _chartsView.yAxisTextModel.textAlignment = NSTextAlignmentRight;
        _chartsView.yAxisTextModel.lineWidth = 1;
        _chartsView.yAxisTextModel.lineColor = [UIColor colorWithHexString:@"#F8F8F9"];
        _chartsView.xAxisTextModel.textColor = [UIColor colorWithHexString:@"#626D86"];
        _chartsView.xAxisTextModel.font = kFont_Regular(11);
        _chartsView.xAxisTextModel.textToAxisGap = 4;
        _chartsView.xAxisTextModel.textAlignment = NSTextAlignmentCenter;
        _chartsView.xAxisTextModel.lineWidth = 1;
        _chartsView.xAxisTextModel.lineColor = [UIColor colorWithHexString:@"#F8F8F9"];
        _chartsView.chartsLineModel.lineWidth = 2;
        _chartsView.chartsLineModel.lineColor = [UIColor colorWithHexString:@"#25DBEF"];
        _chartsView.animationDuration = 1.2;
        _chartsView.highlightVerticalLineModel.lineWidth = 1;
        _chartsView.highlightVerticalLineModel.lineColor = [UIColor colorWithHexString:@"#95A0B6"];
        _chartsView.highlightHorizontalLineModel.lineWidth = 1;
        _chartsView.highlightHorizontalLineModel.lineColor = [UIColor colorWithHexString:@"#95A0B6"];
        //        _chartsView.highlightFocusView = [self HighlightFocusView];
        //        _chartsView.highlightView = [self HighlightView];
        _chartsView.highlightTimeDelay = 1;
        _chartsView.highlightViewToHorizontalLine = 15;
        _chartsView.highlightViewToVerticalLine = 5;
    }
    return _chartsView;
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
