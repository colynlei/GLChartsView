//
//  GLChartsUtils.h
//  HuobiPoolDapp
//
//  Created by 雷国林 on 2018/12/27.
//  Copyright © 2018 李辉. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define gl_ColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define gl_ColorRGB(r, g, b) gl_ColorRGBA(r, g, b, 1.0f)
#define gl_ColorRandomAlpha(alpha) \
gl_ColorRGBA(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),alpha)
#define gl_ColorRandom gl_ColorRandomAlpha(1.0f)
#define gl_ColorWithHexAndAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]
#define gl_ColorWithHex(rgbValue) gl_ColorWithHexAndAlpha(rgbValue,1.0f)


#define GLChartsViewFocusViewWillShow   @"GLChartsViewFocusViewWillShow"
#define GLChartsViewFocusViewDidShow    @"GLChartsViewFocusViewDidShow"
#define GLChartsViewFocusViewWillHidden @"GLChartsViewFocusViewWillHidden"
#define GLChartsViewFocusViewDidHidden  @"GLChartsViewFocusViewDidHidden"


@interface GLChartsUtils : NSObject

@end

NS_ASSUME_NONNULL_END
