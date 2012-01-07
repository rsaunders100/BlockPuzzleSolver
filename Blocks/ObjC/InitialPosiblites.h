//
//  InitialPosiblites.h
//  Blocks
//
//  Created by Robert Saunders on 07/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BlockPosition;

@interface InitialPosiblites : NSObject

+ (NSArray*) generateInitialPosiblites;

+ (BlockPosition*) blockPositionForHash:(uint64) hash;

@end
