//
//  StopTimeCell.m
//  TrainBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "StopMainCell.h"
#import "Stop.h"
#import "StopTime.h"
#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"
#import "NSString+BeetleFight.h"

@implementation StopMainCell

@synthesize routeNumber, routeDirection, relativeTime, stopName, dataRefreshRequested;

- (void) setStop:(Stop*) stop {
  
  StopTime *nextStopTime = [stop nextStopTime];

  NSString *relativeString;
  if (nextStopTime != nil) {
    NSArray  *departureData = [[stop nextStopTime] getTimeTillDeparture];
    NSNumber *hour    = (NSNumber*) [departureData objectAtIndex:1];
    NSNumber *minute  = (NSNumber*) [departureData objectAtIndex:2];
    NSNumber *seconds = (NSNumber*) [departureData objectAtIndex:3];

    if([hour intValue] > 0){
      relativeString = [NSString stringWithFormat:@"%dh", [hour intValue]];
    } else if ( [minute intValue] > 0 ) {
      relativeString = [NSString stringWithFormat:@"%dm", [minute intValue]];
    } else if ( [seconds intValue] > 0 ) {
      relativeString = [NSString stringWithFormat:@"%ds", [seconds intValue]];
    } else {
      [self setDataRefreshRequested:true];
      relativeString = @"0s";
    }
  } else {
    relativeString = @"";
    [self setDataRefreshRequested:false];
  }

  NSMutableAttributedString * string = [[NSMutableAttributedString alloc]
                                        initWithString:relativeString];

  [string setTextColor:self.relativeTime.textColor];
  [string setFont:self.relativeTime.font];
  [string setTextAlignment:kCTRightTextAlignment lineBreakMode:0];

  UIFont *smallFont = [UIFont boldSystemFontOfSize:12.0];
  [string setFont:smallFont range:[relativeString rangeOfString:@"h"]];
  [string setFont:smallFont range:[relativeString rangeOfString:@"m"]];
  [string setFont:smallFont range:[relativeString rangeOfString:@"s"]];

  self.relativeTime.attributedText = string;
  self.stopName.text = stop.stop_name;
  
  self.routeNumber.text    = stop.route.short_name;
  self.routeDirection.text = stop.stop_desc;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UIView *contentView = self.contentView;

    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.backgroundView = [[UIImageView alloc] initWithImage:bgImg];

    self.relativeTime = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:20.0 bold:YES];
    self.routeNumber = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:18.0 bold:YES];
    self.routeDirection = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:10.0 bold:NO];
     self.stopName = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:17.0 bold:NO];
    
    [self.routeNumber setTextAlignment:UITextAlignmentCenter];

    [contentView addSubview:self.relativeTime];
    [contentView addSubview:self.routeNumber];
    [contentView addSubview:self.routeDirection];
    [contentView addSubview:self.stopName];

    [self.routeNumber release];
    [self.routeDirection release];
    [self.relativeTime release];
    [self.stopName release];
    
  }

  return self;
}

- (void)layoutSubviews {

  [super layoutSubviews];

  // getting the cell size
  CGRect contentRect = self.contentView.bounds;

  // In this example we will never be editing, but this illustrates the appropriate pattern
  if (!self.editing) {

    // get the X pixel spot
    CGFloat boundsX = contentRect.origin.x;

    self.routeNumber.frame     = CGRectMake(boundsX +  20, 15, 30,  30);
    self.routeDirection.frame  = CGRectMake(boundsX +  10, 32, 60,  20);
    self.stopName.frame        = CGRectMake(boundsX +  75, 20, 180, 50);
    self.relativeTime.frame    = CGRectMake(boundsX + 255, 17, 35,  30);

  }
}

- (OHAttributedLabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
{
  /*
     Create and configure a label.
   */

  UIFont *font;
  if (bold) {
    font = [UIFont boldSystemFontOfSize:fontSize];
  } else {
    font = [UIFont systemFontOfSize:fontSize];
  }

  /*
         Views are drawn most efficiently when they are opaque and do not have a clear background, so set these defaults.  To show selection properly, however, the views need to be transparent (so that the selection color shows through).  This is handled in setSelected:animated:.
   */
  OHAttributedLabel *newLabel = [[OHAttributedLabel alloc] initWithFrame:CGRectZero];
  newLabel.backgroundColor = [UIColor clearColor];
  newLabel.opaque = YES;
  newLabel.textColor = primaryColor;
  newLabel.highlightedTextColor = selectedColor;
  newLabel.font = font;
  //newLabel.lineBreakMode = UILineBreakModeTailTruncation;

  return newLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
