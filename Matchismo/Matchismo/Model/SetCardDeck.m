//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Jamar Parris on 12/22/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@interface SetCardDeck()

@end

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        for (NSUInteger number = 0; number < [SetCard numberCount]; number++) {
            for (NSUInteger shape = 0; shape < [SetCard shapeCount]; shape++) {
                for (NSUInteger shading = 0; shading < [SetCard shadingCount]; shading++) {
                    for (NSUInteger color = 0; color < [SetCard colorCount]; color++) {
                        
                        SetCard *card = [[SetCard alloc] init];
                        card.number = number;
                        card.shape = shape;
                        card.shading = shading;
                        card.color = color;
                        
                        [self addCard:card];
                    }
                }
            }
        }
    }
    
    return self;
}

@end
