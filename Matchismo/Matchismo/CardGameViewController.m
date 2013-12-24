//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Jamar Parris on 12/13/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayHistoryViewController.h"

@interface CardGameViewController ()

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons; //all the buttons connect to a single outlet
@property (weak, nonatomic) IBOutlet UILabel *matchResultLabel;

@end

@implementation CardGameViewController

-(void)viewDidLoad {
    
    [super viewDidLoad];
    self.matchResultLabel.text = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    //show card contents
    [self updateUI];
}

//abstract method, subclasses MUST implement
- (Deck *)createDeck {
    
    return nil;
}

//abstract method, subclasses MUST implement
- (NSAttributedString *)attributedTitleForCard:(Card *)card
{
    return nil;
}

//abstract method, subclasses MUST implement
- (NSAttributedString *)foregroundTextForCard:(Card *)card
{
    return nil;
}

//abstract method, subclasses MUST implement
- (UIImage *)backgroundImageForCard:(Card *)card
{
    return nil;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                  usingDeck:[self createDeck]];
    }
    
    return _game;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"showPlayHistory"]) {
        
        if ([segue.destinationViewController isKindOfClass:[PlayHistoryViewController class]]) {
            
            PlayHistoryViewController *playHistoryController = (PlayHistoryViewController *)segue.destinationViewController;
            
            NSMutableArray *completePlayHistoryAttributedStrings = [[NSMutableArray alloc] init];
            
            for (NSUInteger playNumber = 1; playNumber <= self.game.numberOfPlays; playNumber++) {
                NSAttributedString *historyItemAttributedString = [self descriptionForGamePlayNumber:playNumber];
                [completePlayHistoryAttributedStrings addObject:historyItemAttributedString];
            }

            playHistoryController.playHistoryAttributedDescriptions = completePlayHistoryAttributedStrings;
        }
    }
}

- (IBAction)touchResetButton:(UIBarButtonItem *)sender {
    
    self.game = nil;
    [self updateUI];
}

- (IBAction)touchCardButton:(UIButton *)sender
{
    NSUInteger cardIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:cardIndex];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSUInteger cardIndex = [self.cardButtons indexOfObject:cardButton];
        Card *card = [self.game cardAtIndex:cardIndex];
        [cardButton setAttributedTitle:[self foregroundTextForCard:card] forState:UIControlStateNormal];
        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    
    self.navigationItem.title = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    self.matchResultLabel.attributedText = [self descriptionForGamePlayNumber: self.game.numberOfPlays];
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
    NSAttributedString *attributedDescription = [self attributedStringDescriptionForHistoryItem:historyItem];
    
    return attributedDescription;
}

- (NSAttributedString *)attributedStringDescriptionForHistoryItem:(NSDictionary *)historyItem
{
    NSMutableAttributedString *attributedDescription = [[NSMutableAttributedString alloc] init];
    NSMutableArray *cards = (NSMutableArray *)historyItem[@"cards"];
    
    for (Card *card in cards) {
        NSAttributedString *cardTitleAttributedString = [self attributedTitleForCard:card];
        [attributedDescription appendAttributedString:cardTitleAttributedString];
        [attributedDescription appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t"]];
    }

    BOOL didMatchCheck = [(NSNumber *)historyItem[@"didCheckForMatch"] boolValue];
    
    //did we do a match check on this round
    if (didMatchCheck) {
        
        BOOL matched = [(NSNumber *)historyItem[@"matched"] boolValue];
        NSString *matchString;
        
        if (matched) {
            matchString = @"MATCHED!\t";
        } else {
            matchString = @"NO MATCH\t";
        }
        
        [attributedDescription appendAttributedString:[[NSAttributedString alloc] initWithString: matchString]];
    }
    
    //create dictionary to store attributes
    NSDictionary *attributedProperties;
    
    NSInteger score = [(NSNumber *)historyItem[@"score"] intValue];
    NSString *pointsString;
    
    if (score > 0) {
        pointsString = [NSString stringWithFormat:@"+%d pts", score];
        attributedProperties = @{NSForegroundColorAttributeName: [UIColor greenColor]};
    } else {
        pointsString = [NSString stringWithFormat:@"%d pts", score];
        attributedProperties = @{NSForegroundColorAttributeName: [UIColor redColor]};
    }
    
    
    [attributedDescription appendAttributedString: [[NSAttributedString alloc] initWithString: pointsString attributes: attributedProperties]];
    
    return attributedDescription;
}

@end
