//
//  InitialPosiblites.m
//  Blocks
//
//  Created by Robert Saunders on 07/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InitialPosiblites.h"
#import "BlockPosition.h"
#import "Block.h"
#import "Vector.h"
#import "Grid.h"

static NSMutableDictionary* blockPossiblityLookup = nil;

// Private
@interface InitialPosiblites()
+ (NSMutableArray*) removeDuplicatesFromArray:(NSMutableArray*)array;
@end


@implementation InitialPosiblites

+ (NSArray*) generateInitialPosiblites 
{
  blockPossiblityLookup = [NSMutableDictionary dictionaryWithCapacity:5000];
  
  NSMutableArray* arrayOfBlockPossilbities = [NSMutableArray arrayWithCapacity:13];
  
  for (int i = 0; i < 13; i++) 
  {
    NSMutableArray* blockPossiblityArray = [NSMutableArray arrayWithCapacity:700];
    
    Block* theBlock = [[Block alloc] initWithIndex:i];
    
    // For all rotations
    for (int i = 0; i < 24; i ++) 
    {
      theBlock.offsetVector = [Vector vectorWithOffsetsRow:0 clm:0 pln:0];
      theBlock.rotationIndex = i;
      
      // For all translations
      while ( (theBlock.offsetVector) ) {
        
        Grid* grid = [[Grid alloc] init];
        
        if ([grid setSquaresForBlock:theBlock]) 
        {
          uint64 hash = [grid generateHash];
          BlockPosition* blockPosition = [BlockPosition blockPositionWithName:theBlock.name hash:hash];
          
          [blockPossiblityArray addObject:blockPosition];
        }
        
        theBlock.offsetVector = [theBlock.offsetVector nextVector];
      }
    }
    
    blockPossiblityArray = [InitialPosiblites removeDuplicatesFromArray:blockPossiblityArray];
    
    [arrayOfBlockPossilbities addObject:blockPossiblityArray];
    
    for (int j = 0; j < [blockPossiblityArray count]; j ++) {
      
      BlockPosition* blockPosition = [blockPossiblityArray objectAtIndex:j];
      
      NSString* hashString = [NSString stringWithFormat:@"%llu", blockPosition.positionHash];
      [blockPossiblityLookup setObject:blockPosition forKey:hashString];
      
    }
  }
  
  // We now sort by the number of possiblites for each block
  // we want to place the most awkward block first as it will save time in the long run
  NSArray* sortedArrayOfBlockPossilbities = [arrayOfBlockPossilbities sortedArrayUsingSelector:@selector(compare:)];
  
  
//  for (int i = 0; i < 13; i++) {
//    NSArray* arrayOfBlockPositions = [sortedArrayOfBlockPossilbities objectAtIndex:i];
//    int count = 0;
//    for (int j = 0; j < arrayOfBlockPositions.count; j++) {
//      BlockPosition* blockPosition = [arrayOfBlockPositions objectAtIndex:j];
//      if (count++ < 1) NSLog(blockPosition.blockName);
//      possiblities[0][i][j] = blockPosition.positionHash;
//    }
//  }
  
  
  return sortedArrayOfBlockPossilbities;
}


+ (NSMutableArray*) removeDuplicatesFromArray:(NSMutableArray*) array
{
  array = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(compare:)]];
  
  BlockPosition* prevBlockPosition = nil;
  NSMutableArray* duplicates = [NSMutableArray arrayWithCapacity:500];
  
  for (BlockPosition* blockPosition in array) {
    
    if (prevBlockPosition && blockPosition.positionHash == prevBlockPosition.positionHash) {
      
      if (![prevBlockPosition.blockName isEqualToString:blockPosition.blockName]) {
        NSLog(@"ERROR!");
      }
      
      [duplicates addObject:blockPosition];
    }
    prevBlockPosition = blockPosition;
  }
  
  for (id duplicate in duplicates) {
    
    [array removeObject:duplicate];
  }
  
  return array;  
}


+ (BlockPosition*) blockPositionForHash:(uint64) hash 
{
  NSString* hashString = [NSString stringWithFormat:@"%llu", hash];
  return [blockPossiblityLookup objectForKey:hashString];
}



@end




