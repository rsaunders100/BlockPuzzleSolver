//
//  Vector.h
//  Blocks
//
//  Created by Robert Saunders on 27/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector : NSObject

+ (Vector*)vectorWithOffsetsRow:(int)row clm:(int)clm pln:(int)plane;

// 0 - 23
- (Vector*) vectorByRotatingWithIndex:(int)index;

// 0 - 3
- (Vector*) vectorByRotatingWithViaRow:(int)index;

// 0 - 3
- (Vector*) vectorByRotatingWithViaClm:(int)index;

// 0 - 3
- (Vector*) vectorByRotatingWithViaPln:(int)index;


- (id)initWithOffsetsRow:(int)row clm:(int)clm pln:(int)plane;
- (Vector*)vectorByAddingVector:(Vector*) vector;

- (Vector*) nextVector;

@property int row;
@property int clm;
@property int pln;

@end

