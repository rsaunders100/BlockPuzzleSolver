//
//  Grid.h
//  Blocks
//
//  Created by Robert Saunders on 27/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Vector;
@class Block;
@class BlockPosition;

@interface Grid : NSObject

@property (strong) NSArray* planes; 

- (id) initWithHash:(uint64)hash;

- (void) setSquareAtRow:(int)row clm:(int)clm plane:(int)plane;

// Returns false if vector can not be set
- (BOOL) setSquareAtVector:(Vector*) vector;
- (BOOL) setSquaresForBlock:(Block*) block;

// Will move the offset until the block fits into the grid
- (void) fitBlockInGrid:(Block*) block;

- (uint64) generateHash;
- (NSString*) hashAsString;

- (void) setSquaresForBlockPosition:(BlockPosition*) blockPosition;

@end
