//
//  NoStops.h
//  BusBrain
//
//  Created by John Doll on 9/8/12.
//  Copyright (c) 2012 LivingSocial. All rights reserved.
//

#import "BusTableCell.h"

@interface NoStops : BusTableCell  {

  OHAttributedLabel *_message;

}

@property (nonatomic, retain) OHAttributedLabel *message;

@end
