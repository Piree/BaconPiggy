//
//  ViewController.h
//  Bacon Piggy
//
//  Created by Pierre on 2014-02-16.
//  Copyright (c) 2014 Pierre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GameKit/GameKit.h>
#import "Game.h"
#import "GAITrackedViewController.h"

int HighScoreNumber;

@interface ViewController : GAITrackedViewController <GKGameCenterControllerDelegate>
{
    
    IBOutlet UILabel *HighScore;
    IBOutlet UIButton *Start;
    IBOutlet UIButton *Rank;
    
}

-(IBAction)ShowRank:(id)sender;

@end
