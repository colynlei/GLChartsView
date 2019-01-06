//
//  ChartsBaseViewController.h
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/5.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLChartsView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartsBaseViewController : UIViewController

@property (nonatomic, strong) GLSegmentedControl *segmentedContrl;

- (void)chartsData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
