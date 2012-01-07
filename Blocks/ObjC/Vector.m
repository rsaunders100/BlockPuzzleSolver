//
//  Vector.m
//  Blocks
//
//  Created by Robert Saunders on 27/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Vector.h"

@implementation Vector

@synthesize row, clm, pln;


+ (Vector* )vectorWithOffsetsRow:(int)aRow clm:(int)aClm pln:(int)aPlane 
{
  return [[Vector alloc] initWithOffsetsRow:aRow clm:aClm pln:aPlane];
}


- (Vector*)vectorByAddingVector:(Vector*) vector 
{
  return [Vector vectorWithOffsetsRow:self.row + vector.row
                                  clm:self.clm + vector.clm
                                  pln:self.pln + vector.pln];
}

- (id)initWithOffsetsRow:(int)aRow clm:(int)aClm pln:(int)aPlane;
{
  self = [super init];
  if (self) 
  {
    self.row = aRow;
    self.clm = aClm;
    self.pln = aPlane;
  }
  return self;
}

- (Vector*) vectorByRotatingWithViaRow:(int)index 
{
  switch (index) 
  {
    case 0: return [Vector vectorWithOffsetsRow: row   clm: clm   pln: pln]; // id
    case 1: return [Vector vectorWithOffsetsRow: row   clm:-pln   pln: clm];
    case 2: return [Vector vectorWithOffsetsRow: row   clm:-clm   pln:-pln];
    case 3: return [Vector vectorWithOffsetsRow: row   clm: pln   pln:-clm]; 
    default: return nil;
  }
}


- (Vector*) vectorByRotatingWithViaClm:(int)index 
{
  switch (index) 
  {
    case 0: return [Vector vectorWithOffsetsRow: row   clm: clm   pln: pln]; // id
    case 1: return [Vector vectorWithOffsetsRow:-pln   clm: clm   pln: row];
    case 2: return [Vector vectorWithOffsetsRow:-row   clm: clm   pln:-pln];
    case 3: return [Vector vectorWithOffsetsRow: pln   clm: clm   pln:-row]; 
    default: return nil;
  }
}


- (Vector*) vectorByRotatingWithViaPln:(int)index 
{
  switch (index) 
  {
    case 0: return [Vector vectorWithOffsetsRow: row   clm: clm   pln: pln]; // id
    case 1: return [Vector vectorWithOffsetsRow:-clm   clm: row   pln: pln];
    case 2: return [Vector vectorWithOffsetsRow:-row   clm:-clm   pln: pln];
    case 3: return [Vector vectorWithOffsetsRow: clm   clm:-row   pln: pln]; 
    default: return nil;
  }
}

// 0 - 24
- (Vector*) vectorByRotatingWithIndex:(int)index 
{
  int sixIndex = index / 4;
  int fourIndex = index % 4;
  
  Vector* vector = nil;
  
  switch (sixIndex) 
  {  
      // 2nd via pln
    case 0: vector = [self vectorByRotatingWithViaClm:0]; break;
    case 1: vector = [self vectorByRotatingWithViaClm:2]; break;  
    
      // 2nd via row
    case 2: vector = [self vectorByRotatingWithViaClm:1]; break;
    case 3: vector = [self vectorByRotatingWithViaClm:3]; break;
      
      // 2nd via clm
    case 4: vector = [self vectorByRotatingWithViaRow:1]; break;
    case 5: vector = [self vectorByRotatingWithViaRow:3]; break;
    default: return nil;
  }
  
  if (sixIndex == 0 || sixIndex == 1) {
    switch (fourIndex) 
    {
      case 0: return [vector vectorByRotatingWithViaPln:0];
      case 1: return [vector vectorByRotatingWithViaPln:1];
      case 2: return [vector vectorByRotatingWithViaPln:2];
      case 3: return [vector vectorByRotatingWithViaPln:3];
      default: return nil;
    }
  }
  
  if (sixIndex == 2 || sixIndex == 3) {
    switch (fourIndex) 
    {
      case 0: return [vector vectorByRotatingWithViaRow:0];
      case 1: return [vector vectorByRotatingWithViaRow:1];
      case 2: return [vector vectorByRotatingWithViaRow:2];
      case 3: return [vector vectorByRotatingWithViaRow:3];
      default: return nil;
    }
  }
  
  if (sixIndex == 4 || sixIndex == 5) {
    switch (fourIndex) 
    {
      case 0: return [vector vectorByRotatingWithViaClm:0];
      case 1: return [vector vectorByRotatingWithViaClm:1];
      case 2: return [vector vectorByRotatingWithViaClm:2];
      case 3: return [vector vectorByRotatingWithViaClm:3];
      default: return nil;
    }
  }
  
  return nil;
}

- (Vector*) nextVector
{
  int aRow = self.row;
  int aClm = self.clm;
  int aPln = self.pln;
  
  aRow ++;
  if (aRow > 3) {
    aRow = 0;
    aClm ++;
    
    if (aClm > 3) {
      aClm = 0;
      aPln ++;
      
      if (aPln > 3) {
        return nil;
      }
    }
  }
  
  return [Vector vectorWithOffsetsRow:aRow clm:aClm pln:aPln];
}


- (NSString*) description {
  return [NSString stringWithFormat:@"[r:%d c:%d p:%d]", self.row, self.clm, self.pln];
}

@end
