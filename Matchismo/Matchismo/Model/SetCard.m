//
//  SetCard.m
//  Matchismo
//
//  Created by Jamar Parris on 12/22/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "SetCard.h"

@interface SetCard()

@end

@implementation SetCard

- (void)setShape:(NSUInteger)shape
{
    if (shape < [SetCard shapeCount]) {
        _shape = shape;
    }
}

- (void)setColor:(NSUInteger)color
{
    if (color <= [SetCard colorCount]) {
        _color = color;
    }
}

- (void)setShading:(NSUInteger)shading
{
    if (shading <= [SetCard shadingCount]) {
        _shading = shading;
    }
}

- (void)setNumber:(NSUInteger)number
{
    if (number <= [SetCard numberCount]) {
        _number = number;
    }
}

- (NSString *)contents
{
    return nil;
}

- (int)match:(NSArray *)otherCards
{
    NSInteger score = 0;
    
    NSMutableArray *cardNumbers = [[NSMutableArray alloc] initWithObjects:@(self.number), nil];
    NSMutableArray *cardShadings = [[NSMutableArray alloc] initWithObjects:@(self.shading), nil];
    NSMutableArray *cardColors = [[NSMutableArray alloc] initWithObjects:@(self.color), nil];
    NSMutableArray *cardShapes = [[NSMutableArray alloc] initWithObjects:@(self.shape), nil];
    
    for (SetCard *otherCard in otherCards) {
        
        [cardNumbers addObject:@(otherCard.number)];
        [cardShadings addObject:@(otherCard.shading)];
        [cardColors addObject:@(otherCard.color)];
        [cardShapes addObject:@(otherCard.shape)];
    }
    
    NSUInteger matchingCount = 0;
    
    if ([self doAllCardsHaveSamePropertyValueOrDistinctValuesBasedOnArrayItems:cardNumbers]) {
        matchingCount++;
    }
    
    if ([self doAllCardsHaveSamePropertyValueOrDistinctValuesBasedOnArrayItems:cardShadings]) {
        matchingCount++;
    }
    
    if ([self doAllCardsHaveSamePropertyValueOrDistinctValuesBasedOnArrayItems:cardColors]) {
        matchingCount++;
    }
    
    if ([self doAllCardsHaveSamePropertyValueOrDistinctValuesBasedOnArrayItems:cardShapes]) {
        matchingCount++;
    }
    
    if (matchingCount == 4) {
        return 4;
    }

    
    NSLog(@"Score %d", score);
    
    return score;
}

- (BOOL)doAllCardsHaveSamePropertyValueOrDistinctValuesBasedOnArrayItems:(NSArray *)items {
    
    NSSet *uniqueItems = [NSSet setWithArray:items];
    
    NSUInteger uniqueItemCount = [uniqueItems count];
    if (uniqueItemCount == 1 || uniqueItemCount == 3) {
        return YES;
    }
    
    return NO;
}

+ (NSUInteger)shapeCount
{
    return 3;
}

+ (NSUInteger)colorCount
{
    return 3;
}

+ (NSUInteger)shadingCount
{
    return 3;
}

+ (NSUInteger)numberCount
{
    return 3;
}

@end
