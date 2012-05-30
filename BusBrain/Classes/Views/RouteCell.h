//
//  RouteCell.h
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteCell : UITableViewCell {
  UILabel *title;
  UILabel *description;
  UILabel *extraInfo;
  UIImageView *icon;
}

@property (nonatomic, retain) UILabel *title;
@property (nonatomic, retain) UILabel *description;
@property (nonatomic, retain) UILabel *extraInfo;
@property (nonatomic, retain) UIImageView *icon;

// internal function to ease setting up label text
-(UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold;

@end
