
//
//  ChartsBaseViewController.m
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/5.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "ChartsBaseViewController.h"

@interface ChartsBaseViewController ()<GLSegmentedControlDelegate>

@property (nonatomic, strong) NSArray *defaultDatas;

@end

@implementation ChartsBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentedContrl];
    NSData *data = [NSData dataWithContentsOfFile:[kBundle pathForResource:@"defaultDatas.geojson" ofType:nil]];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    self.defaultDatas = dic[@"data"];
}

- (GLSegmentedControl *)segmentedContrl {
    if (!_segmentedContrl) {
        _segmentedContrl = [[GLSegmentedControl alloc] initWithFrame:CGRectMake(0, kNavbarHeight, kScreenWidth, 50) titles:@[@"一周",@"一月"]];
        _segmentedContrl.titleGapType = GLSegmentedControlTitleGapTypeEqualGapBoth;
        _segmentedContrl.backgroundColor = kColorRandomAlpha(0.2);
        _segmentedContrl.delegate = self;
    }
    return _segmentedContrl;
}

- (void)segmentedControl:(GLSegmentedControl *)segmentedControl didSelectedIndex:(NSInteger)index {
    [self chartsData:[self.defaultDatas subarrayWithRange:NSMakeRange(0, index?self.defaultDatas.count:7)]];
}

- (void)chartsData:(NSArray *)data{}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
