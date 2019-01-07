
//
//  CustomHighlightView.m
//  GLChartsView
//
//  Created by 雷国林 on 2019/1/7.
//  Copyright © 2019 雷国林. All rights reserved.
//

#import "CustomHighlightView.h"

@interface CustomHighlightView ()

@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UILabel *weatherLabel;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation CustomHighlightView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.dateLabel];
        [self addSubview:self.weatherLabel];
        [self addSubview:self.descLabel];
    }
    return self;
}

- (UILabel *)dateLabel {
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [UIColor whiteColor];
        _dateLabel.font = kFont(14);
    }
    return _dateLabel;
}

- (UILabel *)weatherLabel {
    if (!_weatherLabel) {
        _weatherLabel = [[UILabel alloc] init];
        _weatherLabel.textColor = [UIColor redColor];
        _weatherLabel.font = kFont(14);
        _weatherLabel.numberOfLines = 0;
    }
    return _weatherLabel;
}

- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.textColor = [UIColor whiteColor];
        _descLabel.font = kFont(12);
        _descLabel.numberOfLines = 0;
    }
    return _descLabel;
}

- (CGRect)currentPointData:(NSDictionary *)data {
    self.dateLabel.text = [NSString stringWithFormat:@"日期：%@",data[@"date"]];
    self.weatherLabel.text = [NSString stringWithFormat:@"天气：%@\n温度：%@",data[@"weather"],data[@"temp"]];
    self.descLabel.text = [NSString stringWithFormat:@"心情：%@",data[@"desc"]];
    
    CGFloat self_w = 115;
    CGFloat gap = 5;
    
    CGFloat x = gap,y = gap,w=self_w-2*x;
    CGFloat h = [self.dateLabel.text heightForFont:self.dateLabel.font width:w];
    self.dateLabel.frame = CGRectMake(x, y, w, h);
    
    y = CGRectGetMaxY(self.dateLabel.frame)+2;
    h = [self.weatherLabel.text heightForFont:self.weatherLabel.font width:w];
    self.weatherLabel.frame = CGRectMake(x, y, w, h);
    
    y = CGRectGetMaxY(self.weatherLabel.frame)+2;
    h = [self.descLabel.text heightForFont:self.descLabel.font width:w];
    self.descLabel.frame = CGRectMake(x, y, w, h);
    
    return CGRectMake(0, 0, self_w, CGRectGetMaxY(self.descLabel.frame)+gap);
    
}

@end
