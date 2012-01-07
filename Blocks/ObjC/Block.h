//
//  Block.h
//  Blocks
//
//  Created by Robert Saunders on 27/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Vector;

@interface Block : NSObject

- (id)initWithIndex:(int)index;


// 4 or 5 including 
@property (strong) NSArray* vectors;


@property (strong) Vector* offsetVector;

// 0 - 23
@property int rotationIndex;

@property (strong) NSString* name;


@end
