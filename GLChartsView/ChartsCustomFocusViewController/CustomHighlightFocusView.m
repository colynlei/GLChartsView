
//
//  CustomHighlightFocusView.m
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/8.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "CustomHighlightFocusView.h"

@interface CustomHighlightFocusView ()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation CustomHighlightFocusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.bgView.frame = self.bounds;
    self.bgView.layer.cornerRadius = self.bgView.height/2;

}

@end
