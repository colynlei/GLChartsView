//
//  CustomHighlightView.h
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/7.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "GLChartsHighlightView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomHighlightView : GLChartsHighlightView

- (CGRect)currentPointData:(NSDictionary *)data;

@end

NS_ASSUME_NONNULL_END
