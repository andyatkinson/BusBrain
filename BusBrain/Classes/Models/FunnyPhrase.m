//
//  FunnyPhrase.m
//  BusBrain
//
//  Created by Aaron Batalion on 4/9/12.
//  Copyright (c) 2012 Beetle Fight. All rights reserved.
//

#import "FunnyPhrase.h"

@implementation FunnyPhrase

+ (NSString *)rand {
  NSArray *phrases = [NSArray arrayWithObjects:@"Hurry Up. No Shoving.", @"Don't drop your phone.", @"Don't worry, I'm almost there.", @"You look nice today.", @"Where did you get those shoes?", @"Hang tight. I only average 18mph.", @"I saved you a seat", nil];

  NSUInteger randomIndex = arc4random() % [phrases count];
  return (NSString *)[phrases objectAtIndex:randomIndex];
}

@end
