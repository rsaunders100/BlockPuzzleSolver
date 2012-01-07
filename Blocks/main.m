//
//  main.m
//  Blocks
//
//  Created by Robert Saunders on 27/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Grid.h"
#import "Vector.h"
#import "Block.h"
#import "BlockPosition.h"
#import "NSArray+compareByCount.h"
#import "InitialPosiblites.h"

// Method prototypes
#include "main.h"

// Comment / Uncomment this to toggle detailed loggin
// (effects the seach speed by a factor of aprox 100)
#define DEBUG_LOG


//
// Global State 
//

// A uint64 represents a single block in a specific posiiton in the grid.

// The solution is an array of block positions (from 0 to searchLevel)
// that do not overlap
static uint64 solution[14] = {0llu};
static int searchLevel = 0;



//
// possiblities[][][] and filteredPossibilities[][][]
//

// The first [] index represents the depth of the search (aka search level)
// The second index reprenets a specifc block (index 0-12) wich corresponds to blocks in the following way:

/*
 0  E
 1  K
 2  A
 3  I
 4  J
 5  M
 6  D
 7  B
 8  C
 9  F
 10 G
 11 H
 12 L
 */

// The third index is unimportant, just a list of posiblites for the block in the search level.

// Search level 0 contains all possiblites for all blocks
// Search level i (i > 0) contains all posiblies that do not overlap solition i
//     Where solution i is the combined blocks ( solution[0], solution[1], .. , solution[i] )

// This means that the number of possiblities for each block decreases as the search level increases
// the filtered possiblies is ony the posiblies, for the search level for the block, 
// that fit into the most constraining enpty square of the grid.
// This is a concept described further lower down in the search() method.
static uint64 possiblities[13][13][433] = {0llu};
static uint64 filteredPossibilities[13][13][55] = {0llu};


// Needed in the search() method to reduce the posiblites to 
// zero for any block that has been used already.
static int lastUsedBlockIndex = 0;


int main (int argc, const char * argv[])
{
  @autoreleasepool {
    
    // Populate a list of possiblites 
    // (locations where each block can be positioned in the grid)
    generateInitalPossiblities();
    
    // Search using the possiblites to find a solution where each block fits in the grid
    search(); 
  }
  return 0;
}
  


// Returns the 64-bit representation of the grid 
// 0 = unfiled square, 1 = filled square
// Does this by 'ORing' each piece in the solution array together
uint64 getSolution() 
{  
  uint64 soln = solution[0];
  for (int i = 1; i < searchLevel; i ++) 
  {
    soln |= solution[i];
  }
  
  return soln;
}


// Returns a string reprentating the current state of the solution
// Each block is represented by a letter (A-M) an empty square is 
// represented by the unicode symbol: ◻
NSString* currentSolution() 
{  
  Grid* grid = [[Grid alloc] init];
  
  uint64 hash = solution[0];
  for (int i = 0; i < searchLevel && hash ; i ++) 
  {
    BlockPosition* blockPosition = [InitialPosiblites blockPositionForHash:hash];
    [grid setSquaresForBlockPosition:blockPosition]; 
    
    hash = solution[i+1];
  }
  return [grid description];
}


// Returns a string reprentating the last piece to be placed in the solution grid
// Each block is represented by a letter (A-M) an empty square is 
// represented by the unicode symbol: ◻
NSString* lastPlacedPiece()
{  
  Grid* grid = [[Grid alloc] init];
  
  uint64 hash = solution[searchLevel-1];
  BlockPosition* blockPosition = [InitialPosiblites blockPositionForHash:hash];
  [grid setSquaresForBlockPosition:blockPosition]; 

  return [grid description];
}

void generateInitalPossiblities()
{
  // Message the objective C class
  NSArray* sortedArrayOfBlockPossilbities = [InitialPosiblites generateInitialPosiblites];
  
  // Translate the NSArray of NSArrays into the C array
  for (int blockIndex = 0; blockIndex < 13; blockIndex++) 
  {
    NSArray* arrayOfBlockPositions = [sortedArrayOfBlockPossilbities objectAtIndex:blockIndex];
    for (int j = 0; j < arrayOfBlockPositions.count; j++) 
    {
      BlockPosition* blockPosition = [arrayOfBlockPositions objectAtIndex:j];
      possiblities[0][blockIndex][j] = blockPosition.positionHash;
    }
  }
}

// Counts and prints how many possliblies and filtered possiblities
// there are for each block and in total.
// Used for debugging
void printBlockCounts() 
{
  int totFiltCount = 0;
  int totCount = 0;
  
  for (int i = 0; i < 13; i ++) {
    
    int filtCount = 0;
    int count = 0;
    
    uint64 possilbity = possiblities[searchLevel][i][0];
    for (int j = 0; (possilbity != 0llu); j++) {
      count ++;
      totCount ++;
      possilbity = possiblities[searchLevel][i][j+1];
    }

    possilbity = filteredPossibilities[searchLevel][i][0];
    for (int j = 0; (possilbity != 0llu); j++) {
      filtCount ++;
      totFiltCount ++;
      possilbity = filteredPossibilities[searchLevel][i][j+1];
    }
    
    NSLog(@"Block%d Count:%d Filtered Count:%d", i, count, filtCount);
  }
  
  NSLog(@"total count:%d total filtered count:%d", totCount, totFiltCount);
}


void search() {
  
  // 
  // Stage 1: Copy all the possiblites to the next [index][][]  , 
  //          ignoring the ones that are invalid
  //          because they overlap the last placed piece.
  //
  
  if (searchLevel != 0) {
    
#ifdef DEBUG_LOG
    int removedCount = 0;
    int remainingCount = 0;
#endif
    
    // Get all the filled blocks so far...
    uint64 soln = getSolution();
    
    // Check if the problem has been solved
    
    // FF = 1111 1111 , 8 1s  -> 64 1s are 16Fs
    if (searchLevel > 12 || soln == 0xFFFFFFFFFFFFFFFFllu) {
      
      NSLog(@"##### solved ######");
      NSLog(@"%@", currentSolution());
      NSLog(@"##### solved ######");
      exit(0);
    }
    
    
    // For each remaining block
    for (int i = 0; i < 14; i++) {
      
      // If this was the last used block, 
      // zero the array so we cant use it agian.
      // we only need to zero the first index,
      // since the arrays are null terminated
      if (i == lastUsedBlockIndex) {
        possiblities[searchLevel][i][0] = 0llu;
        continue;
      }
      
      // While there are possiblities for this block
      int insertionIndex = 0;
      uint64 possilbity = possiblities[searchLevel-1][i][0];
      for (int j = 0; (possilbity); j++) {
                
        // if its valid put it in this itteration
        if (!(possilbity & soln)) {
          
          possiblities[searchLevel][i][insertionIndex++] = possilbity;
          
#ifdef DEBUG_LOG          
          remainingCount++;
#endif
          
        } 
        
#ifdef DEBUG_LOG
        else 
        {  
          removedCount ++;
        }
#endif
        
        // grab the hash from the previous itteration ready for the next part of the for loop
        possilbity = possiblities[searchLevel-1][i][j+1];
        
        
        // Since we are relying on null terminated arrays
        // then we should copy the first null value to the next array.
        if (!possilbity) {
          possiblities[searchLevel][i][insertionIndex++] = 0llu;
        }
      }

    }
    
#ifdef DEBUG_LOG
    NSLog(@"Removed count: %d", removedCount);
    NSLog(@"Remaining count: %d", remainingCount);
#endif
    
    
    // 
    // Stage 2: For each empty square in the grid,
    //          count how many possiblites fill the square
    //          if there are zero for any particaular square we
    //          have gone wrong.  Otherwise we procede by filling the 
    //          most constraining square first, 
    //          i.e. the one with the least number of block positions that fills it
    // 
    
    // We should skip stage2 for the zero index
    // since its a special case where choosing all possiitons of blockE first 
    // is more constraining than any particular block
    
    int minimumSquareIndex = 0;
    int minimumSquareCount = 1000;
    
    // For each of the 64 square indexes
    for (int squareIndex = 0; squareIndex < 64; squareIndex++) 
    {
      
      // bitMask is 63 0s and one 1 in the square index
      uint64 bitMask = (1llu << squareIndex);
      
      
      // If the block is unfilled by the solution so far
      if ( !(bitMask & soln) ) 
      {
        
        // Used to count the total number of block positions that fill this square
        int count = 0;
        
        // For each remaining block
        for (int i = 0; i < 13; i++) {
          
          // While there are possiblities for this block
          uint64 possilbity = possiblities[searchLevel][i][0];
          for (int j = 0; (possilbity); j++) {
            
            // If it fills the empty square
            if (bitMask & possilbity) {
              
              // count it
              count ++;
              
              // if we have gone past the current mimimum we can stop
              if (count >= minimumSquareCount) {
                
                // break out of both for loops
                i = 13;
                possilbity = 0;
              }
            }
            
            // Grab the hash for the next itteration
            possilbity = possiblities[searchLevel][i][j+1];
          }
        }
        
        // If no blocks will fill any particular square we pop the search stack
        if (count == 0) {
          
#ifdef DEBUG_LOG
          NSLog(@"No blocks will fill square index:%d", squareIndex);
#endif
          
          popLastPieceFromGrid();          
          return;
        }
        
        
        // NSLog(@"squareIndex: %d count: %d", squareIndex, count);
        
        // Now we have counted it, check to see if has a lower number of posiitons 
        // than the current mimimum.
        // if so update the mimimum
        if (count < minimumSquareCount) 
        {
          minimumSquareCount = count;
          minimumSquareIndex = squareIndex;
        }
      }
    }
    
#ifdef DEBUG_LOG
    NSLog(@"Most constrainign square Index: %d  possiblity count:%d" , minimumSquareIndex, minimumSquareCount);
#endif
    
    // Now we have the most constrained square 
    // we should filter all the pieces that fit into that square
    
    // bitMask is 63 0s and one 1 in the square index
    uint64 secondBitMask = (1llu << minimumSquareIndex);
    
    
    // For each remaining block
    for (int i = 0; i < 13; i++) {
      
      // While there are possiblities for this block
      int insertionIndex = 0;
      uint64 possilbity2 = 0llu; 
      for (int j = 0; YES; j++) {
        
        uint64 possilbity2 = possiblities[searchLevel][i][j]; 
        
        if (possilbity2) {
          
          // If it fills the empty square
          if (secondBitMask & possilbity2) {
            
            // add it to the filtered possiblites
            filteredPossibilities[searchLevel][i][insertionIndex++] = possilbity2;
            
          } 
        }
        else 
        {  
          // Null terminate the array
          filteredPossibilities[searchLevel][i][insertionIndex++] = 0llu;
          break;
        }
      }
    }
  }
  
  
  // 
  // Stage 3: itterate over the filtered possiblites,
  //          for each posiiblity, push it onto the solution stack and 
  //          recursivly call this search function.
  //  

  
  if (searchLevel == 0) 
  { 
    // zero is a special case, we just try two positions of blockE
    // we only need to do 2 since its the first piece so we can expliot the symertry.
    
    /*
    
     The first posiiton for block E is like this on the bottom plane:  (index 0)
     
    ◻ E ◻ ◻
    E E E ◻
    ◻ E ◻ ◻
    ◻ ◻ ◻ ◻
    
     The second posiiton exactly the same but one plane up  (index 4)

     Each other postion can be replicated by rotating the block in the 24 different directions
    
    */
    
    int blockEIndex = 0;
    uint64 possilbity = possiblities[0][0][blockEIndex];      
    pushBlockIntoGrid(possilbity, blockEIndex);
    search();
    
    
    blockEIndex = 4;
    possilbity = possiblities[0][0][blockEIndex];      
    pushBlockIntoGrid(possilbity, blockEIndex);
    
    search();
    
  }
  else 
  {
    int logCounter = 1;
    
    // For each remaining block
    for (int blockIndex = 0; blockIndex < 13; blockIndex++) 
    {
      
      // While there are possiblities for this block
      uint64 possilbity = filteredPossibilities[searchLevel][blockIndex][0];
      for (int j = 0; (possilbity != 0llu); j++) {
        
        pushBlockIntoGrid(possilbity, blockIndex);
        search();
        
        // Grab the next possiblity 
        possilbity = filteredPossibilities[searchLevel][blockIndex][j+1];
      }
    }
  }
  
#ifdef DEBUG_LOG
  NSLog(@"Reached end of search for search level: %d", searchLevel);
#endif
  
  popLastPieceFromGrid();
  return;
}



// Takes the block position and pushes in onto the solution grid
// Should be performed in preperation of diving into the next searech level
void pushBlockIntoGrid(uint64 blockPositionn, int blockIndex) 
{  
#ifdef DEBUG_LOG
  printBlockCounts();
#endif
  
  solution[searchLevel++] = blockPositionn;
  lastUsedBlockIndex = blockIndex;
  
#ifdef DEBUG_LOG
  NSLog(@"Pushing :%@", lastPlacedPiece());
  NSLog(@"%@", currentSolution());
#endif
}



// Removes the last block position from the solution grid
// Should be perfored after a indication that the current solution is no good
// in preperation for coming back up to the previous search level
void popLastPieceFromGrid() 
{
#ifdef DEBUG_LOG
  NSLog(@"Poping :%@", lastPlacedPiece());
#endif
  
  // Zeros the array for this current search level
  // Itterates though each state valiable for the current search level and zeros it.
  // This means that when we return to this level again (after we push a piece)
  // there is no remnance of the previous posiablites
  for (int blockIndex = 0; blockIndex < 13; blockIndex++) {
    
    for (int possiblityIndex = 0; possiblityIndex < 433; possiblityIndex++) {
      
      possiblities[searchLevel][blockIndex][possiblityIndex] = 0llu;
    }
    
    for (int j = 0; j < 55; j++) {
      filteredPossibilities[searchLevel][blockIndex][j] = 0llu;
    }
  }
  solution[searchLevel] = 0;
  
  searchLevel --;
  
#ifdef DEBUG_LOG
  NSLog(@"%@", currentSolution());
#endif
}

