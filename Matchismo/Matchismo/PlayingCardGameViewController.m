//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Jamar Parris on 12/19/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (CardMatchingGame *)game
{
    CardMatchingGame *_game = [super game];
    _game.numberOfCardsToMatch = 2;
    
    return _game;
}

- (NSAttributedString *)attributedTitleForCard:(Card *)card
{
    return [[NSAttributedString alloc] initWithString:card.contents];
}

- (NSAttributedString *)foregroundTextForCard:(Card *)card
{
    if (!card.isChosen) {
        return [[NSAttributedString alloc] initWithString:@""];
    }
    
    return [self attributedTitleForCard:card];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
