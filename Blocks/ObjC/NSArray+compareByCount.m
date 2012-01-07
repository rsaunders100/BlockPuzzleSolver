//
//  NSArray+compareByCount.m
//  Blocks
//
//  Created by Robert Saunders on 29/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "NSArray+compareByCount.h"

@implementation NSArray (compareByCount)


- (NSComparisonResult)compare:(NSArray *)array {
  
  if (self.count > array.count) {
    return NSOrderedDescending;
  }
  
  if (self.count < array.count) {
    return NSOrderedAscending;
  }
  
  return NSOrderedSame;
}


@end
