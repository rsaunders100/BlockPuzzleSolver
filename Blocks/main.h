//
//  main.h
//  Blocks
//
//  Created by Robert Saunders on 07/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef Blocks_main_h
#define Blocks_main_h

// Method Prototypes for main.m

NSMutableArray* removeDuplicates(NSMutableArray* array);
void popLastPieceFromGrid();
void pushBlockIntoGrid(uint64 blockPositionn, int blockIndex);

void generateInitalPossiblities();
void search(); 

uint64 getSolution();
NSString* currentSolution();
NSString* lastPlacedPiece();
void generateInitalPossiblities();
void printBlockCounts();

#endif
