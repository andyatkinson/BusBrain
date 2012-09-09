//
//  BusLooknFeel.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "BusLooknFeel.h"

@implementation BusLooknFeel

+ (void) addShadow:(OHAttributedLabel*) thisLabel color:(UIColor*) color height:(float) height {
  [thisLabel setShadowColor: color];
  [thisLabel setShadowOffset: CGSizeMake(0.0, height)];
}

//-----------------------------------------
+ (UIFont *) getNavigationTitleFont {
  return [UIFont boldSystemFontOfSize:18.0];
}

+ (UIColor *) getNavigationTitleColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

+ (UIColor *) getNavigationTitleShadowtColor {
  return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
}

//-----------------------------------------
+ (UIFont *) getNavigationFont {
  return [UIFont boldSystemFontOfSize:12.0];
}

+ (UIColor *) getNavigationColor {
  return [UIColor colorWithRed:74/256.0 green:60/256.0 blue:0 alpha:1];
}

+ (UIColor *) getNavigationShadowtColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
}



//-----------------------------------------
// Selector ON
//-----------------------------------------
+ (UIFont *) getSelectFocusFont {
  return [UIFont boldSystemFontOfSize:13.0];
}

+ (UIColor *) getSelectFocusColor {
  return [UIColor colorWithRed:51/256.0 green:51/256.0 blue:51/256.0 alpha:1];
}

+ (UIColor *) getSelectFocusShadowtColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
}


// Selector OFF
//-----------------------------------------
+ (UIFont *) getSelectFont {
  return [UIFont boldSystemFontOfSize:13.0];
}

+ (UIColor *) getSelectColor {
  return [UIColor colorWithRed:153/256.0 green:153/256.0 blue:153/256.0 alpha:1];
}

+ (UIColor *) getSelectShadowtColor {
  return [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
}

// Route Title (Timer)
//-----------------------------------------
+ (UIFont *) getRouteTitleFont {
  return [UIFont boldSystemFontOfSize:15.0];
}

+ (UIColor *) getRouteTitleColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

+ (UIFont *) getRouteDirectionFont {
  return [UIFont systemFontOfSize:10.0];
}

+ (UIColor *) getRouteDirectionColor {
  return [UIColor colorWithRed:122/256.0 green:122/256.0 blue:122/256.0 alpha:1];
}

// Stop Title (Timer)
//-----------------------------------------
+ (UIFont *) getStopTitleFont {
  return [UIFont systemFontOfSize:17.0];
}

+ (UIColor *) getStopTitleColor {
  return [UIColor colorWithRed:122/256.0 green:122/256.0 blue:122/256.0 alpha:1];
}


// Timer Title Big
+ (UIColor *) getTimerColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

+ (UIColor *) getTimerZeroColor {
  return [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
}

+ (UIColor *) getTimerShadowColor {
  return [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
}

+ (UIFont *) getTimerBigFont {
  return [UIFont boldSystemFontOfSize:76.0];
}

+ (UIFont *) getTimerSmallFont {
  return [UIFont boldSystemFontOfSize:30.0];
}


// Timer Title (Funny)
+ (UIFont *) getTimerTitleFont {
  return [UIFont boldSystemFontOfSize:14.0];
}

+ (UIColor *) getTimerTitleColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

// Timer SubTitle
+ (UIFont *) getTimerSubTitleFont {
  return [UIFont boldSystemFontOfSize:13.0];
}

+ (UIColor *) getTimerSubTitleColor {
  return [UIColor colorWithRed:120/256.0 green:120/256.0 blue:120/256.0 alpha:1];
}

// Timer Detail Time/Price
+ (UIFont *) getTimerDetailFont {
  return [UIFont systemFontOfSize:12.0];
}

+ (UIColor *) getTimerDetailColor {
  return [UIColor colorWithRed:167/256.0 green:167/256.0 blue:167/256.0 alpha:1];
}

// Upcoming Title (Timer)
//-----------------------------------------
+ (UIFont *) getUpcomingTitleBigFont {
  return [UIFont boldSystemFontOfSize:30.0];
}

+ (UIFont *) getUpcomingTitleSmallFont {
  return [UIFont boldSystemFontOfSize:15.0];
}

+ (UIColor *) getUpcomingTitleColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

// Upcoming Sub Title (Time/Price)
+ (UIFont *) getUpcomingSubTitleFont {
  return [UIFont systemFontOfSize:15.0];
}

+ (UIColor *) getUpcomingSubTitleColor {
  return [UIColor colorWithRed:167/256.0 green:167/256.0 blue:167/256.0 alpha:1];
}



//-----------------------------------------
+ (UIFont *) getHeaderFont {
  return [UIFont boldSystemFontOfSize:14.0];
}

+ (UIColor *) getHeaderTextColor {
  return [UIColor colorWithRed:74/256.0 green:60/256.0 blue:0 alpha:1];
}

+ (UIColor *) getHeaderShadowtColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:0.4];
}

//-----------------------------------------
+ (UIFont *) getTitleFont {
  return [UIFont boldSystemFontOfSize:15.0];
}

+ (UIColor *) getTitleColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

//-----------------------------------------
+ (UIFont *) getSubTitleFont {
  return [UIFont systemFontOfSize:13.0];
}

+ (UIColor *) getSubTitleColor {
  return [UIColor colorWithRed:122/256.0 green:122/256.0 blue:122/256.0 alpha:1];
}

//-----------------------------------------
+ (UIFont *) getDetailFont {
  return [UIFont boldSystemFontOfSize:16.0];
}

+ (UIFont *) getDetailSmallFont {
  return [UIFont boldSystemFontOfSize:12.0];
}

+ (UIColor *) getDetailColor {
  return [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
}

@end
