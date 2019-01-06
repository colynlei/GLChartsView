//
//  GLChartsHighlightFocusView.m
//  HuobiPoolDapp
//
//  Created by 雷国林 on 2019/1/3.
//  Copyright © 2019 李辉. All rights reserved.
//

#import "GLChartsHighlightFocusView.h"

@implementation GLChartsHighlightFocusView

- (void)viewWillShow{}
- (void)viewDidShow{}
- (void)viewWillHidden{}
- (void)viewDidHidden{}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(context, true);
    CGContextSetShouldAntialias(context, true);
}

@end