//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Jamar Parris on 12/23/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

- (CardMatchingGame *)game
{
    CardMatchingGame *_game = [super game];
    _game.numberOfCardsToMatch = 3;
    
    return _game;
}

- (NSArray *)cardColors
{
    //these are the default card colors if nothing set
    if (!_cardColors) {
        _cardColors = @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
    }
    
    return _cardColors;
}

- (NSArray *)cardShapes
{
    //these are the default card shapes if nothing set
    if (!_cardShapes) {
        _cardShapes = @[@"▲", @"●", @"■"];
    }
    
    return _cardShapes;
}

- (NSAttributedString *)attributedTitleForCard:(Card *)card
{
    NSAttributedString *attributedTitle = nil;
    
    if ([card isKindOfClass:[SetCard class]]) {
        
        SetCard *setCard = (SetCard *)card;
        
        NSUInteger numberOfShapesToDraw = setCard.number + 1;
        UIColor *cardColor = self.cardColors[setCard.color];
        
        NSMutableString *cardString = [[NSMutableString alloc] init];
        
        for (NSUInteger i = 0; i < numberOfShapesToDraw; i++) {
            [cardString appendString:self.cardShapes[setCard.shape]];
        }
       // NSLog(@"%@", cardString);
        
        NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
        
        switch (setCard.shading) {
            case 0:
                attributes[NSStrokeWidthAttributeName] = @-3;
                attributes[NSStrokeColorAttributeName] = cardColor;
                attributes[NSForegroundColorAttributeName] = [UIColor clearColor];
                break;
                
            case 1:
                attributes[NSStrokeWidthAttributeName] = @-3;
                attributes[NSStrokeColorAttributeName] = cardColor;
                attributes[NSForegroundColorAttributeName] = [cardColor colorWithAlphaComponent:0.2];
                break;
                
            case 2:
                attributes[NSForegroundColorAttributeName] = cardColor;
                break;
                
            default:
                break;
        }
        
        attributedTitle = [[NSAttributedString alloc] initWithString:cardString attributes:attributes];
    }
    
    return attributedTitle;
}

- (NSAttributedString *)foregroundTextForCard:(Card *)card
{
    return [self attributedTitleForCard:card];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"setcardfront" : @"setcardback"];
}

@end
