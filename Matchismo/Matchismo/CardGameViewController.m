//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Jamar Parris on 12/13/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

@property (nonatomic, strong) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons; //all the buttons connect to a single outlet
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *modeSegmentedControl;
@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;
@property (weak, nonatomic) IBOutlet UISlider *playHistorySlider;

@end

@implementation CardGameViewController

- (CardMatchingGame *)game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                          usingDeck:[self createDeck]];
    return _game;
}

- (Deck *)createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (IBAction)playHistorySliderChanged:(UISlider *)sender {
    
    self.matchResultLabel.attributedText = [self descriptionForGamePlayNumber: sender.value];
    
    if (sender.value == self.game.numberOfPlays) {
        self.matchResultLabel.alpha = 1.0;
    } else {
        self.matchResultLabel.alpha = 0.5;
    }
}

- (IBAction)touchModeChangeControl:(UISegmentedControl *)sender {
    
    NSInteger currentIndex = sender.selectedSegmentIndex;
    
    if (currentIndex == 1) {
        self.game.numberOfCardsToMatch = 3;
    } else {
        self.game.numberOfCardsToMatch = 2;
    }
}

- (IBAction)touchResetButton:(UIButton *)sender {
    
    self.game = nil;
    
    self.modeSegmentedControl.enabled = YES;
    self.playHistorySlider.hidden = YES;
    
    [self updateUI];
    
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    
    self.modeSegmentedControl.enabled = NO;
    self.playHistorySlider.hidden = NO;
    
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Total: %d", self.game.score];
    
    //update max slider value and current position to last play
    self.playHistorySlider.maximumValue = self.game.numberOfPlays;
    self.playHistorySlider.value = self.game.numberOfPlays;
    
    self.matchResultLabel.attributedText = [self descriptionForGamePlayNumber: self.playHistorySlider.value];
    self.matchResultLabel.alpha = 1.0;
}

- (NSAttributedString *)descriptionForGamePlayNumber:(NSUInteger)playNumber
{
    if (playNumber == 0) {
        return nil;
    } else {
        //play #1 stored at index 0 and so on
        playNumber--;
    }
    
    NSDictionary *historyItem = [self.game historyItemAtIndex:playNumber];
    NSMutableArray *cards = (NSMutableArray *)historyItem[@"cards"];
    
    NSMutableArray *cardStringArray = [[NSMutableArray alloc] init];
    
    for (Card *card in cards) {
        [cardStringArray addObject: card.contents];
    }
    NSString *description = [cardStringArray componentsJoinedByString:@" "];
    
    if (self.game.numberOfCardsToMatch == [cards count]) {
        
        BOOL matched = [(NSNumber *)historyItem[@"matched"] boolValue];

        if (matched) {
            description = [NSString stringWithFormat:@"MATCHED! %@", description];
        } else {
            description = [NSString stringWithFormat:@"%@ DIDN'T MATCH!", description];
        }
    }
    
    //create base attributed string
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc] initWithString: description];
    
    //create dictionary to store attributes
    NSDictionary *attributedProperties;
    
    NSInteger score = [(NSNumber *)historyItem[@"score"] intValue];
    NSString *pointsString;
    
    if (score > 0) {
        pointsString = [NSString stringWithFormat:@" +%d pts", score];
        attributedProperties = @{NSForegroundColorAttributeName: [UIColor greenColor]};
    } else {
        pointsString = [NSString stringWithFormat:@" %d pts", score];
        attributedProperties = @{NSForegroundColorAttributeName: [UIColor redColor]};
    }
    
    
    [attributedDescription appendAttributedString: [[NSAttributedString alloc] initWithString: pointsString attributes: attributedProperties]];
    
    return attributedDescription;
}

- (NSString *)titleForCard:(Card *)card
{
    return card.isChosen ? card.contents : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

@end
