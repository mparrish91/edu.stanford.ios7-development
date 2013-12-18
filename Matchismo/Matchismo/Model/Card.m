//
//  Card.m
//  Matchismo
//
//  Created by Jamar Parris on 12/13/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "Card.h"

@interface Card()

@end

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score += 1;
        }
    }
    
    return score;
}

- (NSUInteger)matchCountWithOtherCards:(NSArray *)otherCards
{
    NSUInteger matchCount = 0;
    
    for (Card *card in otherCards) {
        NSInteger score = [self match:@[card]];
        if (score) {
            matchCount++;
        }
    }
    
    return matchCount;
}

@end
