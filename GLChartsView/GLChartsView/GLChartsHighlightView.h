//
//  GLChartsHighlightView.h
//  HuobiPoolDapp
//
//  Created by 雷国林 on 2019/1/3.
//  Copyright © 2019 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLChartsUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface GLChartsHighlightView : UIView

//返回值rect为计算后的self.frame
@property (nonatomic, copy) CGRect(^highlightFrameBlock)(NSInteger currentIndex);

@end

NS_ASSUME_NONNULL_END
