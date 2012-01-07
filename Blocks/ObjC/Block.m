//
//  Block.m
//  Blocks
//
//  Created by Robert Saunders on 27/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Block.h"
#import "Vector.h"

@implementation Block

@synthesize vectors, offsetVector, rotationIndex, name;

- (id)initWithIndex:(int)index;
{
  self = [super init];
  if (self) 
  {
    offsetVector = [Vector vectorWithOffsetsRow:0 clm:0 pln:0];
    
    switch (index) {
      case 0:
        self.name = @"A";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:-1],
                        [Vector vectorWithOffsetsRow:2 clm:1 pln:-1], nil];
        break;
      
      case 1: 
        self.name = @"B";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0  pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0  pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1  pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:-1 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:-1 pln:-1], nil];
        break;
      
      case 2:
        self.name = @"C";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:-1],
                        [Vector vectorWithOffsetsRow:2 clm:0 pln:0], nil];
        break;
        
      case 3: 
        self.name = @"D";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:2 pln:0],
                        [Vector vectorWithOffsetsRow:2 clm:1 pln:0], nil];
        break;
        
      case 4: 
        self.name = @"E";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0  pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0  pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1  pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:-1 pln:0],
                        [Vector vectorWithOffsetsRow:2 clm:0  pln:0], nil];
        break;
        
      case 5: 
        self.name = @"F";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:2 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:2 clm:1 pln:-1], nil];
        break;
      
      case 6: 
        self.name = @"G";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:2 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:-1], nil];
        break;
        
      case 7: 
        self.name = @"H";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:-1],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:-2], nil];
        break;
        
      case 8:
        self.name = @"I";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:2 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:2 pln:1], nil];
        break;
        
      case 9: 
        self.name = @"J";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:2 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:-1], nil];
        break;
        
      case 10: 
        self.name = @"K";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:2 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:2 clm:2 pln:0], nil];
        break;
      
      case 11: 
        self.name = @"L";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:-1],
                        [Vector vectorWithOffsetsRow:1 clm:2 pln:0], nil];
        break;
        
      case 12: 
        self.name = @"M";
        self.vectors = [NSArray arrayWithObjects:
                        [Vector vectorWithOffsetsRow:0 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:0 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:0],
                        [Vector vectorWithOffsetsRow:1 clm:1 pln:-1], nil];
        break;
        
      default:
        break;
    }
  }
  return self;
}



@end
