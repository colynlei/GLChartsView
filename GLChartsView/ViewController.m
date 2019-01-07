//
//  ViewController.m
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/4.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "ViewController.h"

typedef void (^aablock)(void);

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dataSource = @[@{@"title":@"默认参数",
                          @"viewController":@"ChartsDefaultViewController"},
                        @{@"title":@"自定义中心焦点普通",
                          @"viewController":@"ChartsCustomFocusViewController"},
                        @{@"title":@"自定义中心焦点动画",
                          @"viewController":@"ChartsCustomFocusAnimationViewController"},
                        @{@"title":@"自定义高亮视图",
                          @"viewController":@"ChartsCustomHighlightViewController"},
                        @{@"title":@"自定义坐标轴",
                          @"viewController":@"ChartsCustomAxisViewController"},
                        @{@"title":@"自定义网格线",
                          @"viewController":@"ChartsCustomGridViewController"}];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    
    NSDictionary *dic = self.dataSource[indexPath.row];
//    cell.textLabel.numberOfLines = 0;
    cell.textLabel.text = dic[@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.text = dic[@"viewController"];
    cell.detailTextLabel.textColor = [UIColor redColor];
//    cell.detailTextLabel.height = 30;
    //cell.detailTextLabel
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.contentView.backgroundColor = kColorRandomAlpha(0.3);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {    
    NSDictionary *dic = self.dataSource[indexPath.row];
    Class class = NSClassFromString(dic[@"viewController"]);
    UIViewController *vc = [[class alloc] init];
    vc.title = dic[@"title"];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
