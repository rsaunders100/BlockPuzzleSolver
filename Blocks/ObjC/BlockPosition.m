//
//  BlockPosition.m
//  Blocks
//
//  Created by Robert Saunders on 28/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BlockPosition.h"
#import "Grid.h"

@implementation BlockPosition

@synthesize blockName, positionHash;

+ (BlockPosition*) blockPositionWithName:(NSString*)name hash:(uint64)hash {
  BlockPosition* blockPosition = [[BlockPosition alloc] init];
  blockPosition.blockName = name;
  blockPosition.positionHash = hash;
  return blockPosition;
}

- (NSString*) description {
  return [NSString stringWithFormat:@"%@: %llu",blockName, positionHash];
}

- (NSString*) gridLog {
  
  Grid* grid = [[Grid alloc] init];
  [grid setSquaresForBlockPosition:self];
  return [grid description];
}

- (NSComparisonResult)compare:(BlockPosition *)aBlockPosition {
  
  if (self.positionHash > aBlockPosition.positionHash) {
    return NSOrderedDescending;
  }
  
  if (self.positionHash < aBlockPosition.positionHash) {
    return NSOrderedAscending;
  }
  
  return NSOrderedSame;
}

@end
