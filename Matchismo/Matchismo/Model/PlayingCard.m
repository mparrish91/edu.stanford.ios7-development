//
//  PlayingCard.m
//  Matchismo
//
//  Created by Jamar Parris on 12/13/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (int)match:(NSArray *)otherCards
{
    NSMutableArray *allCards = [[NSMutableArray alloc] initWithArray:otherCards];
    [allCards addObject:self];
    
    NSInteger score = [PlayingCard matchCards:allCards];
    return score;
}

static const int SUIT_MULTIPLIER = 1;
static const int RANK_MULTIPLIER = 4;

+ (int)matchCards:(NSArray *)cards
{
    NSInteger score = 0;
    NSMutableArray *suits = [[NSMutableArray alloc] init];
    NSMutableArray *ranks = [[NSMutableArray alloc] init];
    
    for (PlayingCard *card in cards) {
        
        NSUInteger suitCount = 0;
        NSUInteger rankCount = 0;
        
        for (PlayingCard *otherCard in cards) {
            if ([card.suit isEqualToString:otherCard.suit]) {
                suitCount += [suits containsObject:card.suit] ? 0 : 1;
            }
            
            if (card.rank == otherCard.rank) {
                rankCount += [ranks containsObject:@(card.rank)] ? 0 : 1;
            }
        }
        
        //NSLog(@"Suits: %d, Rank: %d", suitCount, rankCount);
        
        //only include in score if we have counts greater than 1 as 1 is not a match
        if (suitCount < 2) suitCount = 0;
        if (rankCount < 2) rankCount = 0;
        
        //NSLog(@"Suits: %d, Rank: %d", suitCount, rankCount);
        
        [suits addObject:card.suit];
        [ranks addObject:@(card.rank)];
        
        score += (suitCount * SUIT_MULTIPLIER) + (rankCount * RANK_MULTIPLIER);
        NSLog(@"Score %d", score);
    }
    
    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; //because we provide both setter and getter

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject: suit]) {
        _suit = suit;
    }
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

+ (NSArray *)validSuits
{
    return @[@"♥️", @"♦️", @"♠️", @"♣️"];
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

+ (NSUInteger)maxRank
{
    return [[self rankStrings] count]-1;
}

@end
