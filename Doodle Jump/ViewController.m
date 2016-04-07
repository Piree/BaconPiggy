//
//  ViewController.m
//  Bacon Piggy
//
//  Created by Pierre on 2014-02-16.
//  Copyright (c) 2014 Pierre. All rights reserved.
//

#import "ViewController.h"
#import <GameKit/GameKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    
    HighScoreNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    HighScore.text = [NSString stringWithFormat:@"High Score: %i", HighScoreNumber];
    
    Music = YES;
    
    Start.center = CGPointMake(160, 400);
    
    [super viewDidLoad];
    self.screenName = @"ViewController";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)ShowRank:(id)sender{
    
    
    __weak GKLocalPlayer *localPlayer = [GKLocalPlayer localPlayer];
    
    
    localPlayer.authenticateHandler = ^(UIViewController *viewController, NSError *error) {
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        } else if (localPlayer.isAuthenticated) {
            NSLog(@"Connected");
            [self showLeaderboard:@"BPHS"];
            [self submitScore];
        } else {
            NSLog(@"Failed to Connect");
        }
    };
    
    if (localPlayer.isAuthenticated){
        [self showLeaderboard:@"BPHS"];
        [self submitScore];
    }
    
}

- (void) showLeaderboard: (NSString*) leaderboardID
{
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil)
    {
        gameCenterController.gameCenterDelegate = self;
        gameCenterController.viewState = GKGameCenterViewControllerStateLeaderboards;
        gameCenterController.leaderboardTimeScope = GKLeaderboardTimeScopeToday;
        gameCenterController.leaderboardCategory = leaderboardID;
        [self presentViewController: gameCenterController animated: YES completion:nil];
    }
}

-(void)submitScore {
    if (HighScoreNumber > 0) {
        
        GKScore *scoreReporter = [[GKScore alloc] initWithCategory:@"BPHS"];
        
        scoreReporter.value = [[NSNumber numberWithInt:HighScoreNumber] longLongValue];
        
        [scoreReporter reportScoreWithCompletionHandler:^(NSError *error) {
            if (error != nil)
            {
                NSLog(@"Failed to Submit Score");
            }
            else{
                NSLog(@"Succeded to Submit Score");
                
            }
        }];}
}


- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
