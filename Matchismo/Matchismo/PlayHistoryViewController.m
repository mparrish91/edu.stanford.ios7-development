//
//  PlayHistoryViewController.m
//  Matchismo
//
//  Created by Jamar Parris on 12/23/13.
//  Copyright (c) 2013 Jamar Parris. All rights reserved.
//

#import "PlayHistoryViewController.h"

@interface PlayHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *playHistoryTextView;

@end

@implementation PlayHistoryViewController

- (void)viewWillAppear:(BOOL)animated {
    
    NSMutableAttributedString *completePlayHistoryAttributedString = [[NSMutableAttributedString alloc] init];
    
    for (NSAttributedString *historyItemAttributedString in self.playHistoryAttributedDescriptions) {
        
        [completePlayHistoryAttributedString appendAttributedString:historyItemAttributedString];
        [completePlayHistoryAttributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
    }
    
    self.playHistoryTextView.textStorage.attributedString = completePlayHistoryAttributedString;
}

@end
