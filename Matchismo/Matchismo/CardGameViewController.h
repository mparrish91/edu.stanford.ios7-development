//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Jamar Parris on 12/13/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController : UIViewController

@property (nonatomic, strong) CardMatchingGame *game;

//abstract methods, subclasses MUST implement
- (Deck *)createDeck;
- (NSAttributedString *)attributedTitleForCard:(Card *)card;
- (NSAttributedString *)foregroundTextForCard:(Card *)card;
- (UIImage *)backgroundImageForCard:(Card *)card;

@end
