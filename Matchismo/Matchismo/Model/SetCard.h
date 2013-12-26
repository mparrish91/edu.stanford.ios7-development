//
//  SetCard.h
//  Matchismo
//
//  Created by Jamar Parris on 12/22/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger shape;
@property (nonatomic) NSUInteger shading;
@property (nonatomic) NSUInteger color;

+ (NSUInteger)shapeCount;
+ (NSUInteger)colorCount;
+ (NSUInteger)shadingCount;
+ (NSUInteger)numberCount;

@end
