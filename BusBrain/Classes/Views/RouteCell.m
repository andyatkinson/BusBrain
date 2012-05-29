//
//  RouteCell.m
//  BusBrain
//
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "RouteCell.h"

@implementation RouteCell

@synthesize title, description, extraInfo, icon;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
  if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    UIView *contentView = self.contentView;

    UIImage *bgImg = [[UIImage imageNamed:@"bg_cell.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    self.backgroundView = [[UIImageView alloc] initWithImage:bgImg];

    self.icon = [[ UIImageView alloc ] init];

    self.title = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:16.0 bold:YES];
    self.description = [self newLabelWithPrimaryColor:[UIColor grayColor] selectedColor:[UIColor whiteColor] fontSize:14.0 bold:NO];

    self.extraInfo = [self newLabelWithPrimaryColor:[UIColor whiteColor] selectedColor:[UIColor whiteColor] fontSize:16.0 bold:YES];
    self.extraInfo.textAlignment = UITextAlignmentRight;

    [contentView addSubview:self.icon];
    [contentView addSubview:self.title];
    [contentView addSubview:self.description];
    [contentView addSubview:self.extraInfo];

    [self.title release];
    [self.description release];
  }

  return self;
}

// TODO is there any way to specify the accessory view in the uitableviewcell subclass?

- (void)layoutSubviews {

  [super layoutSubviews];

  // getting the cell size
  CGRect contentRect = self.contentView.bounds;

  // In this example we will never be editing, but this illustrates the appropriate pattern
  if (!self.editing) {

    // get the X pixel spot
    CGFloat boundsX = contentRect.origin.x;
    CGRect frame;

    /*
                 Place the label.
                 place the label whatever the current X is plus 10 pixels from the left
                 place the label 4 pixels from the top
                 make the label 200 pixels wide
                 make the label 20 pixels high
     */
    frame = CGRectMake(boundsX + 10, 15, 27, 28);
    self.icon.frame = frame;

    frame = CGRectMake(boundsX + 46, 10, 170, 20);
    self.title.frame = frame;

    frame = CGRectMake(boundsX + 46, 28, 200, 20);
    self.description.frame = frame;

    frame = CGRectMake(boundsX + 204, 18, 80, 20);
    self.extraInfo.frame = frame;

    //    CGRect imageRectangle = CGRectMake(0.0f,0.0f,320.0f,44.0f); //cells are 44 px high
    //    bgImageView.frame = imageRectangle;

  }
}

- (UILabel *)newLabelWithPrimaryColor:(UIColor *)primaryColor selectedColor:(UIColor *)selectedColor fontSize:(CGFloat)fontSize bold:(BOOL)bold
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
  UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  newLabel.backgroundColor = [UIColor clearColor];
  newLabel.opaque = YES;
  newLabel.textColor = primaryColor;
  newLabel.highlightedTextColor = selectedColor;
  newLabel.font = font;
  newLabel.lineBreakMode = UILineBreakModeTailTruncation;

  return newLabel;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void) dealloc {
  [super dealloc];
}


@end
