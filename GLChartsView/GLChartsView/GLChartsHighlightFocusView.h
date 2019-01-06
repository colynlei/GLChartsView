//
//  GLChartsHighlightFocusView.h
//  HuobiPoolDapp
//
//  Created by 雷国林 on 2019/1/3.
//  Copyright © 2019 李辉. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GLChartsHighlightFocusView : UIView

//子类可重写以下方法，以便增加焦点动画等满足其他需求
- (void)viewWillShow;//中心焦点将要出现
- (void)viewDidShow;//中心焦点已经出现
- (void)viewWillHidden;//中心焦点将要消失
- (void)viewDidHidden;//中心焦点已经消失

@end

NS_ASSUME_NONNULL_END
