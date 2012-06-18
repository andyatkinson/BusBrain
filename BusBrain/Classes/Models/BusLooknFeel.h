//
//  BusLooknFeel.h
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OHAttributedLabel.h"

@interface BusLooknFeel : NSObject {
}

+ (void) addShadow:(OHAttributedLabel*) thisLabel color:(UIColor*) color height:(float) height;

+ (UIFont *)  getNavigationTitleFont;
+ (UIColor *) getNavigationTitleColor;
+ (UIColor *) getNavigationTitleShadowtColor;
+ (UIFont *)  getNavigationFont;
+ (UIColor *) getNavigationColor;
+ (UIColor *) getNavigationShadowtColor;
+ (UIFont *)  getSelectFocusFont;
+ (UIColor *) getSelectFocusColor;
+ (UIColor *) getSelectFocusShadowtColor;
+ (UIFont *)  getSelectFont;
+ (UIColor *) getSelectColor;
+ (UIColor *) getSelectShadowtColor;
+ (UIFont *)  getRouteTitleFont;
+ (UIColor *) getRouteTitleColor;
+ (UIFont *)  getRouteDirectionFont;
+ (UIColor *) getRouteDirectionColor;
+ (UIFont *)  getStopTitleFont;
+ (UIColor *) getStopTitleColor;
+ (UIColor *) getTimerColor;
+ (UIColor *) getTimerZeroColor;
+ (UIColor *) getTimerShadowColor;
+ (UIFont *)  getTimerBigFont;
+ (UIFont *)  getTimerSmallFont;
+ (UIFont *)  getTimerTitleFont;
+ (UIColor *) getTimerTitleColor;
+ (UIFont *)  getTimerSubTitleFont;
+ (UIColor *) getTimerSubTitleColor;
+ (UIFont *)  getTimerDetailFont;
+ (UIColor *) getTimerDetailColor;
+ (UIFont *)  getUpcomingTitleBigFont;
+ (UIFont *)  getUpcomingTitleSmallFont;
+ (UIColor *) getUpcomingTitleColor;
+ (UIFont *)  getUpcomingSubTitleFont;
+ (UIColor *) getUpcomingSubTitleColor;
+ (UIFont *)  getHeaderFont;
+ (UIColor *) getHeaderTextColor;
+ (UIColor *) getHeaderShadowtColor;
+ (UIFont *)  getTitleFont;
+ (UIColor *) getTitleColor;
+ (UIFont *)  getSubTitleFont;
+ (UIColor *) getSubTitleColor;
+ (UIFont *)  getDetailFont;
+ (UIFont *)  getDetailSmallFont;
+ (UIColor *) getDetailColor;

@end
