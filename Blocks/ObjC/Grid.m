//
//  Grid.m
//  Blocks
//
//  Created by Robert Saunders on 27/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Grid.h"
#import "Vector.h"
#import "Block.h"
#import "BlockPosition.h"

@implementation Grid

@synthesize planes;


- (void) setSquareAtRow:(int)row clm:(int)clm plane:(int)plane forValue:(int)value
{
  NSMutableArray* rowOfValues = [[self.planes objectAtIndex:plane] objectAtIndex:clm];
  [rowOfValues replaceObjectAtIndex:row withObject:[NSNumber numberWithInt:value]];
}

- (void) setSquareAtIndex:(int)index forValue:(int)value {
  
  int row = index % 4;
  int clm = (index % 16) / 4;
  int pln = index / 16;
  
  return [self setSquareAtRow:row clm:clm plane:pln forValue:value];
}

- (BOOL) setSquareAtVector:(Vector*) vector 
{
  if (vector.row < 0 || vector.row > 3) return NO; 
  if (vector.clm < 0 || vector.clm > 3) return NO; 
  if (vector.pln < 0 || vector.pln > 3) return NO;
  
  [self setSquareAtRow:vector.row clm:vector.clm plane:vector.pln forValue:1];
  return YES;
}

- (void) setHash:(uint64)hash withValue:(int) value {
  for (int i = 63; i >= 0; i --) 
  {
    if ((hash >> i) & 1llu) {
      [self setSquareAtIndex:i forValue:value];
    } 
  }
}

- (id) initWithHash:(uint64)hash {
  
  self = [self init];
  if (self) {
    [self setHash:hash withValue:1];
  }
  return self;
}

- (NSString*) blocStr:(NSNumber*)number {
  
  int value = [number intValue];
  
  switch (value) {
    case 0:  return @"◻";
    case 1:  return @"■";
    case 2:  return @"A";
    case 3:  return @"B";
    case 4:  return @"C";      
    case 5:  return @"D";
    case 6:  return @"E";
    case 7:  return @"F";
    case 8:  return @"G";
    case 9:  return @"H";
    case 10: return @"I";      
    case 11: return @"J";
    case 12: return @"K";
    case 13: return @"L";      
    case 14: return @"M";      
    default: return @"◻";
  }
  
}

- (BOOL) isVectorValid:(Vector*)vector 
{
  if (vector.row < 0 || vector.row > 3) return NO; 
  if (vector.clm < 0 || vector.clm > 3) return NO; 
  if (vector.pln < 0 || vector.pln > 3) return NO;
  
  return YES;
}


- (id)init 
{
  self = [super init];
  if (self) 
  {
    NSMutableArray* tempPlanes = [NSMutableArray array];
    
    for (int i = 0; i < 4; i++) 
    {
      NSMutableArray* clm = [NSMutableArray array];
      
      for (int i = 0; i < 4; i++) 
      {
        NSMutableArray* row = [NSMutableArray arrayWithObjects:[NSNumber numberWithInt:0], [NSNumber numberWithInt:0], 
                                                               [NSNumber numberWithInt:0], [NSNumber numberWithInt:0], nil];
        
        [clm addObject:row];
      }
      clm = [NSArray arrayWithArray:clm];
      
      [tempPlanes addObject:clm];
    }
    self.planes = [NSArray arrayWithArray:tempPlanes];
  }
  return self;
}

- (NSString *) description 
{
  NSString* returnString = @"\n\n";
  
  for (NSArray* clm in planes) 
  {
    for (NSArray* row in clm) 
    {
      NSString* rowString = [NSString stringWithFormat:@"%@ %@ %@ %@\n",
                             [self blocStr:[row objectAtIndex:0]],
                             [self blocStr:[row objectAtIndex:1]],
                             [self blocStr:[row objectAtIndex:2]],
                             [self blocStr:[row objectAtIndex:3]]];
      
      returnString = [returnString stringByAppendingString:rowString];
    }
    returnString = [returnString stringByAppendingString:@"\n"];
  }
  
  return returnString;
}

- (void) setSquaresForBlockPosition:(BlockPosition*) blockPosition 
{
  int value = 1;
  
  if ([blockPosition.blockName isEqualToString:@"A"])      value = 2;
  else if ([blockPosition.blockName isEqualToString:@"B"]) value = 3;
  else if ([blockPosition.blockName isEqualToString:@"C"]) value = 4;
  else if ([blockPosition.blockName isEqualToString:@"D"]) value = 5;
  else if ([blockPosition.blockName isEqualToString:@"E"]) value = 6;
  else if ([blockPosition.blockName isEqualToString:@"F"]) value = 7;
  else if ([blockPosition.blockName isEqualToString:@"G"]) value = 8;
  else if ([blockPosition.blockName isEqualToString:@"H"]) value = 9;
  else if ([blockPosition.blockName isEqualToString:@"I"]) value = 10;
  else if ([blockPosition.blockName isEqualToString:@"J"]) value = 11;
  else if ([blockPosition.blockName isEqualToString:@"K"]) value = 12;
  else if ([blockPosition.blockName isEqualToString:@"L"]) value = 13;
  else if ([blockPosition.blockName isEqualToString:@"M"]) value = 14;
  
  [self setHash:blockPosition.positionHash withValue:value];
}


- (BOOL) setSquaresForBlock:(Block*) block 
{
  // Check all vectors are valid first
  for (Vector* vector in block.vectors) 
  {
    if (block.rotationIndex)
      vector = [vector vectorByRotatingWithIndex:block.rotationIndex];
    
    if (block.offsetVector)
      vector = [vector vectorByAddingVector:block.offsetVector];
    
    if (![self isVectorValid:vector]) {
      return NO;
    }
  }
  
  // block is valid
  for (Vector* vector in block.vectors) 
  {
    if (block.rotationIndex)
      vector = [vector vectorByRotatingWithIndex:block.rotationIndex];
    
    if (block.offsetVector)
      vector = [vector vectorByAddingVector:block.offsetVector];
    
    [self setSquareAtVector:vector];
  }
  return YES;
}

- (void) fitBlockInGrid:(Block*) block 
{
  // *Should* always fit in eventually
  while (![self setSquaresForBlock:block]) {
    block.offsetVector = [block.offsetVector nextVector];
  }
}

- (BOOL) isSquareSetAtRow:(int)row clm:(int)clm pln:(int)plane 
{  
  NSNumber* value = [[[self.planes objectAtIndex:plane] objectAtIndex:clm] objectAtIndex:row];
  return ([value intValue]);
}

// index 0-63
- (BOOL) isSquareSetAtIndex:(int)index 
{
  int row = index % 4;
  int clm = (index % 16) / 4;
  int pln = index / 16;
  
  return [self isSquareSetAtRow:row clm:clm pln:pln];
}



- (uint64) generateHash {
  
  uint64 hash = 0;
  
  for (int i = 0; i < 64; i ++) 
  {
    if ([self isSquareSetAtIndex:i]) {
      hash |= (1llu << i);
    }
  }
  
  return hash;
}

- (NSString*) hashAsString {
  
  NSString* binaryString = @"";
  
  uint64 hash = [self generateHash];
  
  for (int i = 63; i >= 0; i --) {
    
    if ((hash >> i) & 1llu) {
      binaryString = [binaryString stringByAppendingString:@"1"];
    } else {
      binaryString = [binaryString stringByAppendingString:@"0"];
    }
    
    if (i % 4 == 0) binaryString = [binaryString stringByAppendingString:@" "];
    if (i % 16 == 0) binaryString = [binaryString stringByAppendingString:@" "];
  }
  
  return binaryString;
}

@end








