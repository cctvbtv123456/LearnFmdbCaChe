//
//  SMStyle.h
//  LearnFmdbCaChe
//
//  Created by mac on 2019/5/15.
//  Copyright © 2019 zhihuiketang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SMStyle : NSObject
//UIFont
+ (UIFont *)fontHuge;
+ (UIFont *)fontBig;
+ (UIFont *)fontNormal;
+ (UIFont *)fontSmall;

//UIColor
+ (UIColor *)colorBlackLightAlpha;
+ (UIColor *)colorBlack;
+ (UIColor *)colorGrayLight;
+ (UIColor *)colorGrayDark;
+ (UIColor *)colorOrangeLight;
+ (UIColor *)colorPaperDark;
+ (UIColor *)colorPaperLight;
+ (UIColor *)colorPaperBlack;
+ (UIColor *)colorPaperGray;

//CGFloat
+ (CGFloat)floatScreenWidth;                  //屏幕宽
+ (CGFloat)floatScreenHeight;                 //屏幕高
+ (CGFloat)floatMarginMassive;                //视图间距大
+ (CGFloat)floatMarginNormal;                 //视图间距正常
+ (CGFloat)floatMarginMinor;                  //视图间距小
+ (CGFloat)floatTextIntervalHorizontal;       //横向字之间的间隔
+ (CGFloat)floatTextIntervalVertical;         //纵向字之间的间隔
+ (CGFloat)floatIconNormal;                   //Icon边距

+ (CGFloat)floatCompatibleWithStyleName:(NSString *)styleName; //兼容不同屏幕得到不同的值

@end

NS_ASSUME_NONNULL_END
