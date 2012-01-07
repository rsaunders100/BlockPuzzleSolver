//
//  BlockPosition.h
//  Blocks
//
//  Created by Robert Saunders on 28/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BlockPosition : NSObject

+ (BlockPosition*) blockPositionWithName:(NSString*)name hash:(uint64)hash;

@property (strong) NSString* blockName;
@property uint64 positionHash;

- (NSComparisonResult)compare:(NSNumber *)aNumber;

- (NSString*) gridLog;

@end
