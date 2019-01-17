
//
//  ChartsBaseViewController.m
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/5.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "ChartsBaseViewController.h"
#import <GLMacro.h>

@interface ChartsBaseViewController ()<GLSegmentedControlDelegate>

@property (nonatomic, strong) NSArray *defaultDatas;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSUInteger count;

@property (nonatomic, strong) UILabel *topRightView;

@end

@implementation ChartsBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.segmentedContrl];
    
    
    
    self.topRightView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 30)];
    self.topRightView.textAlignment = NSTextAlignmentRight;
    self.topRightView.font = kFont(15);
    self.topRightView.textColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.topRightView];
    
    __weak typeof(self) weakSelf = self;
    self.displayLink = [CADisplayLink displayLinkWithTarget:weakSelf selector:@selector(tick:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
    
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

- (void)tick:(CADisplayLink *)link {
    if (self.lastTime == 0) {
        self.lastTime = link.timestamp;
        return;
    }
    
    self.count++;
    NSTimeInterval delta = link.timestamp - self.lastTime;
    if (delta < 1) return;
    self.lastTime = link.timestamp;
    float fps = self.count / delta;
    self.count = 0;
    
    NSString *text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    
    self.topRightView.text = text;
//    NSLog(@"=====%@",text);
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
