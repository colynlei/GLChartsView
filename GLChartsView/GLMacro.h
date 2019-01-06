//
//  GLMacro.h
//  GLAPP
//
//  Created by 雷国林 on 2016/9/23.
//  Copyright © 2016年 GL. All rights reserved.
//

#ifndef GLMacro_h
#define GLMacro_h

//获取APP版本号
#define kAppVersion \
[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define kAppBuildVersion \
[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

//软件名称
#define kAppName [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"]
//获取系统版本号
#define kSystemVersion [[UIDevice currentDevice] systemVersion]
//版本号比较
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

//获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//获取沙盒Document路径
#define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒temp路径
#define kTempPath NSTemporaryDirectory()
//获取沙盒Cache路径
#define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

//一些缩写
#define kApplication        [UIApplication sharedApplication]
#define kKeyWindow          [UIApplication sharedApplication].keyWindow
#define kWindow             [[UIApplication sharedApplication].delegate window]
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
#define kFileManager        [NSFileManager defaultManager]
#define kNotificationCenter [NSNotificationCenter defaultCenter]
#define kBundle             [NSBundle mainBundle]

//获取屏幕的尺寸，宽高，比例等
#define kScreenFrame \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? [UIScreen mainScreen].nativeBounds : [UIScreen mainScreen].bounds)
#define kScreenSize \
([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)] ? CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale, [UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale) : [UIScreen mainScreen].bounds.size)
#define kScreenWidth kScreenSize.width
#define kScreenHeight kScreenSize.height
#define kScreenScale kScreenWidth/320 /* 根据iphone5的宽度适配 */

//frame、size、point
#define kRect(x, y, w, h) CGRectMake(x, y, w, h)
#define kSize(w, h)       CGSizeMake(w, h)
#define kPoint(x, y)      CGPointMake(x, y)

//系统
#define IOS   ([kSystemVersion floatValue])
#define IOS7  (IOS >= 7.0f)
#define IOS8  (IOS >= 8.0f)
#define IOS9  (IOS >= 9.0f)
#define IOS10 (IOS >= 10.0f)
#define IOS11 (IOS >= 10.0f)

//判断是iphone几
#define kIsIphone4     (kScreenWidth==320&&kScreenHeight==480)
#define kIsIphone5     (kScreenWidth==320&&kScreenHeight==568)
#define kIsIphone6     (kScreenWidth==375&&kScreenHeight==667)
#define kIsIphone6Plus (kScreenWidth==414&&kScreenHeight==736)
#define kIsIphone7     kIsIphone6
#define kIsIphone7Plus kIsIphone6Plus
#define kIsIphone8     kIsIphone6
#define kIsIphone8Plus kIsIphone6Plus
#define kIsIphoneX [[UIScreen mainScreen] bounds].size.width >=375.0f && [[UIScreen mainScreen] bounds].size.height >=812.0f && (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//判断是iphone或ipad
#define isIphone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isIpad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//状态栏、导航条、导航栏
#define kStatusBarHeight  kApplication.statusBarFrame.size.height /* 20 */
#define kTopBarSafeHeight (CGFloat)(kIsIphoneX?(44):(0)) // 顶部安全区域远离高度
#define kBottomSafeHeight (CGFloat)(kIsIphoneX?(34):(0)) // 底部安全区域远离高度
#define kTopBarDifHeight  (CGFloat)(kIsIphoneX?(24):(0))  // iPhoneX的状态栏高度差值
#define kNavbarHeight     (CGFloat)(64+kTopBarDifHeight)   // 导航套高度
#define kTabbarHeight     (CGFloat)(49+kBottomSafeHeight)    //分栏高度

//判断是真机还是模拟机
#define isSimulator TARGET_IPHONE_SIMULATOR

//颜色
#define kColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kColorRGB(r, g, b) kColorRGBA(r, g, b, 1.0f)
#define kColorRandomAlpha(alpha) \
kColorRGBA(arc4random_uniform(256),arc4random_uniform(256),arc4random_uniform(256),alpha)
#define kColorRandom kColorRandomAlpha(1.0f)
#define kColorWithHexAndAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:a]
#define kColorWithHex(rgbValue) kColorWithHexAndAlpha(rgbValue,1.0f)

//弧度 radian(-360~360)
#define kRadian(radian) radian*M_PI/180

//开发是打印，发布时不打印
#if DEBUG
#define TimeString [dateFormatter stringFromDate:[NSDate date]];

//#define DLog(...) printf("%s %s [Line %d]: %s\n",[[NSString timeString] UTF8String], __PRETTY_FUNCTION__, __LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#define DLog(fmt, ...) NSLog((@"%s 33[Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define GLLog(...) printf("%s %s [%d]: %s\n",[[NSString timeString] UTF8String],[NSStringFromClass([self class]) UTF8String],__LINE__,[[NSString stringWithFormat:__VA_ARGS__] UTF8String]);
#else
#define DLog(...)
#define GLLog(...)
#endif

//弱引用
#define kWeakSelf(type)   __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) strong##type = weak##type;

//字体大小
#define kFont(size) [UIFont systemFontOfSize:size]
#define kFont_bold(size) [UIFont boldSystemFontOfSize:size]

//图片
#define kImage(name) [UIImage imageNamed:name]

//随机数 [from,to] //包含from 和 to
#define kRandomInt(from,to) (int)(from + (arc4random() % (to - from + 1)))

//当前时间戳 浮点型
#define kNowTimeSince1970 [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]

//当前时间戳 整形
#define kNowTimeSince1970LongStr [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//由角度转换弧度
#define kDegreesToRadian(x)      (M_PI * (x) / 180.0)
//由弧度转换角度
#define kRadianToDegrees(radian) (radian * 180.0) / (M_PI)

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime   NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)

//网络加载提示
#define kShowNetworkActivityIndicator kNetworkActivityIndicatorVisible(YES)
#define kHideNetworkActivityIndicator kNetworkActivityIndicatorVisible(NO)
#define kNetworkActivityIndicatorVisible(bool) \
[UIApplication sharedApplication].networkActivityIndicatorVisible = bool

//单例
#define kShareInstance_h( __class ) \
+ (__class *)shareInstance;
#define kShareInstance_m( __class ) \
+ (__class *)shareInstance \
{ \
    static __class * instance = nil; \
    static dispatch_once_t once; \
    dispatch_once( &once, ^{ instance = [[__class alloc] init]; } ); \
    return instance; \
}


#endif /* GLMacro_h */
