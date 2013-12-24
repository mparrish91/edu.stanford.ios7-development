//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Jamar Parris on 12/13/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score; //override readonly in private implementation
@property (nonatomic, strong) NSMutableArray *cards; //array of Card
@property (nonatomic, strong, readwrite) NSMutableArray *playHistory; //array storing played card history
@end

@implementation CardMatchingGame

- (NSUInteger)numberOfCardsToMatch {
    
    //override getter to ensure it's always at least defaulted
    if (!_numberOfCardsToMatch) _numberOfCardsToMatch = 2;
    return _numberOfCardsToMatch;
}

- (NSUInteger) numberOfPlays {
    
    return [self.playHistory count];
}

- (NSMutableArray *) playHistory {
    
    if (!_playHistory) _playHistory = [[NSMutableArray alloc] init];
    return _playHistory;
}

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (NSUInteger i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int ALL_MATCH_BONUS = 2;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    //NSLog(@"STARTNG SCORE: %d", self.score);
    Card *card = [self cardAtIndex:index];
    
    if (card.isMatched) {
        //card is already matched
        return;
    }
    
    if (card.isChosen) {
        card.chosen = NO;
        return;
    }

    NSInteger playScore = 0;
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    
    //NSLog(@"Chosen cards length: %d", [chosenCards count]);
    
    //find all the chosen cards
    for (Card *otherCard in self.cards) {
        if (otherCard.isChosen && !otherCard.isMatched) {
            [chosenCards addObject:otherCard];
        }
    }
    
   // NSLog(@"Chosen cards length: %d", [chosenCards count]);
   // NSLog(@"Before adding to chosen cards array");
    //ensure this card is added to array
    //[chosenCards addObject: card];
    
    NSUInteger chosenCardCount = [chosenCards count];
    
    //did we do the match check this go round
    BOOL shouldCheckForMatch = NO;
    
    //are we at the matching threshold? include current card
    if (self.numberOfCardsToMatch == chosenCardCount + 1) {
        
        shouldCheckForMatch = YES;
        
      /*  for (NSUInteger i = 0; i < chosenCardCount; i++) {
            
            Card *matchCard = chosenCards[i];
            
            //match this card with all cards after it
            NSUInteger start = i + 1;
            NSUInteger numberToGet = chosenCardCount - start;
            
            NSArray *cardsToMatch = [chosenCards subarrayWithRange:NSMakeRange(start, numberToGet)];
            
            NSInteger matchScore = [matchCard match: cardsToMatch];
            NSLog(@"match score: %d", matchScore);
            playScore += matchScore;
        } */
        playScore = [card match:chosenCards];
        
        if (playScore) {
            NSLog(@"score before match bonus: %d", playScore);
            //if we have a score > 0, then apply MATCH_BONUS
            playScore *= MATCH_BONUS;
            //NSLog(@"score after match bonus: %d", playScore);
            card.matched = YES;
            
            //do all cards match in some way? apply ALL_MATCH_BONUS
            if ([card matchCountWithOtherCards: chosenCards] == chosenCardCount) {
                playScore *= ALL_MATCH_BONUS;
                //NSLog(@"score after ALL match bonus: %d", playScore);
            }
            
        } else {
            playScore -= MISMATCH_PENALTY;
            card.matched = NO;
        }
        
        for (Card * otherCard in chosenCards) {
            if (card.matched) {
                otherCard.matched = YES;
            } else {
                otherCard.chosen = NO;
            }
        }
    }

    playScore -= COST_TO_CHOOSE;
    //NSLog(@"score after cost to choose penalty: %d", playScore);
    self.score += playScore;
    
    //ensure card is chosen
    card.chosen = YES;
    [chosenCards addObject: card];
    
    NSDictionary *historyItem = @{@"cards": chosenCards, @"matched": @(card.isMatched), @"score": @(playScore), @"didCheckForMatch":@(shouldCheckForMatch)};
    // NSLog(@"Before adding to playHistory array");
    [self.playHistory addObject:historyItem];
    
    //NSLog(@"ENDING SCORE: %d", self.score);
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

- (NSDictionary *)historyItemAtIndex:(NSUInteger)index
{
    return (index < [self.playHistory count]) ? self.playHistory[index] : nil;
}

//ensure default init doesnt work
- (instancetype)init {
    
    return nil;
}

@end
