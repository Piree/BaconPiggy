//
//  Game.m
//  Bacon Piggy
//
//  Created by Pierre on 2014-02-16.
//  Copyright (c) 2014 Pierre. All rights reserved.
//

#import "Game.h"


@interface Game ()

@end

@implementation Game

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    StartGame.hidden = NO;
    FadeBG.hidden = YES;
    MusicOnOff.hidden = NO;
    MusicStop = YES;
    
    Bacon1.hidden = YES;
    Bacon2.hidden = YES;
    Bacon3.hidden = YES;
    Bacon4.hidden = YES;
    Bacon5.hidden = YES;
    
    BaconBomb1.hidden = YES;
    BaconBomb2.hidden = YES;
    BaconBomb3.hidden = YES;
    BaconBomb4.hidden = YES;
    BaconBomb5.hidden = YES;
    
    Backlight1.hidden = YES;
    Backlight2.hidden = YES;
    Backlight3.hidden = YES;
    Backlight4.hidden = YES;
    Backlight5.hidden = YES;
    
    Cloud1.hidden = YES;
    Cloud2.hidden = YES;
    Cloud3.hidden = YES;
    
    Piggy.hidden = NO;
    Ground.hidden = NO;
    Score.hidden = YES;
    Sun.hidden = NO;
    Instructions.hidden = YES;
    
    GameOver.hidden = YES;
    FinalScore.hidden = YES;
    HighScore.hidden = YES;
    HighScore2.hidden = YES;
    NightBG.hidden = YES;
    ScoreBoard.hidden = NO;
    HighScoreNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScoreSaved"];
    HighScoreBoard.text = [NSString stringWithFormat:@"Best:      %i", HighScoreNumber];
    HighScoreBoard.hidden = NO;
    
    ScoreNumber = 0;
    AddedScore = 0;
    
    Bacon1Used = NO;
    Bacon2Used = NO;
    Bacon3Used = NO;
    Bacon4Used = NO;
    Bacon5Used = NO;
    
    
    TouchesBeganUsed = NO;
    
    Music = YES;
    
    UpMovement = 0;
    
    NSURL *SoundURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"Bells" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) SoundURL, &PlayBellSoundID);
    
    NSURL *SoundURL2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"WindSound" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) SoundURL2, &PlayWindSoundID);
    
    [self StartMusic];
    [self StopMusic];
    AudioServicesPlaySystemSound(PlayWindSoundID);
    
    
    [super viewDidLoad];
    self.screenName =@"Game";
	// Do any additional setup after loading the view.
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

- (void)gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
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




-(void)GameOver{
    
    AudioServicesPlaySystemSound(PlayWindSoundID);
    
    [self StopMusic];
    
    Piggy.hidden = YES;

    Score.hidden = YES;
    GameOver.hidden = NO;
    FinalScore.hidden = NO;
    StartGame.hidden = NO;
    Rank.hidden = NO;
    ScoreBoard.hidden = NO;
    HighScoreBoard.hidden = NO;
    MusicOnOff.hidden = NO;
    MusicStop = YES;
    
    FinalScore.text = [NSString stringWithFormat:@"Score:    %i", ScoreNumber];
    
    [Movement invalidate];
    
    if (ScoreNumber > HighScoreNumber){
        HighScoreNumber = ScoreNumber;
        [[NSUserDefaults standardUserDefaults] setInteger:HighScoreNumber forKey:@"HighScoreSaved"];
        [self submitScore];
        HighScore.hidden = NO;
        HighScore2.hidden = NO;
    }
    
    HighScoreBoard.text = [NSString stringWithFormat:@"Best:      %i", HighScoreNumber];
    
    
}

-(void)Scoring{

    
    Score.text = [NSString stringWithFormat:@"%i", ScoreNumber];
}

-(void)BaconFall{
    
    if ([UIScreen mainScreen].bounds.size.height>567 && [UIScreen mainScreen].bounds.size.height<599){
        if (Piggy.center.y > 500){
            BaconMoveDown = 7;
        }
        else if (Piggy.center.y > 450){
            BaconMoveDown = 8;
        }
        else if (Piggy.center.y > 400){
            BaconMoveDown = 9;
        }
        else if (Piggy.center.y > 350){
            BaconMoveDown = 10;
        }
        else if (Piggy.center.y > 300){
            BaconMoveDown = 11;
        }
        else if (Piggy.center.y > 250){
            BaconMoveDown = 12;
        }
    }
    
    if ([UIScreen mainScreen].bounds.size.height<567){
        if (Piggy.center.y > 413){
            BaconMoveDown = 7;
        }
        else if (Piggy.center.y > 363){
            BaconMoveDown = 8;
        }
        else if (Piggy.center.y > 313){
            BaconMoveDown = 9;
        }
        else if (Piggy.center.y > 263){
            BaconMoveDown = 10;
        }
        else if (Piggy.center.y > 213){
            BaconMoveDown = 11;
        }
        else if (Piggy.center.y > 163){
            BaconMoveDown = 12;
        }
    }
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        if (Piggy.center.y > 826){
            BaconMoveDown = 14;
        }
        else if (Piggy.center.y > 726){
            BaconMoveDown = 16;
        }
        else if (Piggy.center.y > 626){
            BaconMoveDown = 18;
        }
        else if (Piggy.center.y > 526){
            BaconMoveDown = 20;
        }
        else if (Piggy.center.y > 426){
            BaconMoveDown = 22;
        }
        else if (Piggy.center.y > 326){
            BaconMoveDown = 24;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (ScoreBoard.hidden == YES) {
 
    if (TouchesBeganUsed == NO){
        [self Bounce];
        TouchesBeganUsed = YES;
        
        UITouch *myTouch = [[event allTouches] anyObject];
        CGPoint myPoint = [myTouch locationInView:self.view];
        
        if (myPoint.x > Piggy.center.x){
            Piggy.image = [UIImage imageNamed:@"Piggie4.png"];
            Piggy.center = CGPointMake(myPoint.x, Piggy.center.y);
        }else if(myPoint.x < Piggy.center.x){
            Piggy.image = [UIImage imageNamed:@"PiggieLeft.png"];
            Piggy.center = CGPointMake(myPoint.x, Piggy.center.y);
        }
         Piggy.center = CGPointMake(myPoint.x, Piggy.center.y);
    }
    
    Instructions.hidden = YES;
    
        MusicOnOff.hidden = YES;
        Score.hidden = NO;
    }
}




-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    if (ScoreBoard.hidden == YES) {
    
    UITouch *myTouch = [[event allTouches] anyObject];
    CGPoint myPoint = [myTouch locationInView:self.view];
    
    if (myPoint.x < Piggy.center.x){
        Piggy.image = [UIImage imageNamed:@"PiggieLeft.png"];
    }else if(myPoint.x > Piggy.center.x){
        Piggy.image = [UIImage imageNamed:@"Piggie4.png"];
    }
    
    
        Piggy.center = CGPointMake(myPoint.x, Piggy.center.y);
    
    }
}

-(void)BaconMovement{
    
    Bacon1.center = CGPointMake(Bacon1.center.x + Bacon1SideMovement, Bacon1.center.y + BaconMoveDown);
    Bacon2.center = CGPointMake(Bacon2.center.x + Bacon2SideMovement, Bacon2.center.y + BaconMoveDown);
    Bacon3.center = CGPointMake(Bacon3.center.x + Bacon3SideMovement, Bacon3.center.y + BaconMoveDown);
    Bacon4.center = CGPointMake(Bacon4.center.x + Bacon4SideMovement, Bacon4.center.y + BaconMoveDown);
    Bacon5.center = CGPointMake(Bacon5.center.x + Bacon5SideMovement, Bacon5.center.y + BaconMoveDown);
    Ground.center = CGPointMake(Ground.center.x, Ground.center.y + BaconMoveDown);
    GroundBG.center = CGPointMake(GroundBG.center.x, GroundBG.center.y + BaconMoveDown);
    FadeBG.center = CGPointMake(FadeBG.center.x, FadeBG.center.y + BaconMoveDown);
    
    Cloud1.center = CGPointMake(Cloud1.center.x, Cloud1.center.y + (BaconMoveDown/5));
    Cloud2.center = CGPointMake(Cloud2.center.x, Cloud2.center.y + (BaconMoveDown/5));
    Cloud3.center = CGPointMake(Cloud3.center.x, Cloud3.center.y + (BaconMoveDown/5));
    
    BaconBomb1.center = CGPointMake(Bacon1.center.x, Bacon1.center.y);
    BaconBomb2.center = CGPointMake(Bacon2.center.x, Bacon2.center.y);
    BaconBomb3.center = CGPointMake(Bacon3.center.x, Bacon3.center.y);
    BaconBomb4.center = CGPointMake(Bacon4.center.x, Bacon4.center.y);
    BaconBomb5.center = CGPointMake(Bacon5.center.x, Bacon5.center.y);
    
    if (Sun.hidden == NO){
    Sun.center = CGPointMake(Sun.center.x, Sun.center.y + (BaconMoveDown/10));
    }
    
    if ([UIScreen mainScreen].bounds.size.height<599){
    BaconMoveDown = BaconMoveDown -0.3;
    }
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        BaconMoveDown = BaconMoveDown -0.6;
    }
    
    if (BaconMoveDown < 0){
        BaconMoveDown = 0;
    }
    
    if ([UIScreen mainScreen].bounds.size.height<599){
    if (Bacon1.center.x > 311){
        Bacon1SideMovement = - Bacon1SideMovement;
    }else if(Bacon1.center.x < 9){
        Bacon1SideMovement = Bacon1SideMovement*(-1);
    }
    if (Bacon2.center.x > 311){
        Bacon2SideMovement = - Bacon2SideMovement;
    }else if(Bacon2.center.x < 9){
        Bacon2SideMovement = Bacon2SideMovement*(-1);
    }
    if (Bacon3.center.x > 311){
        Bacon3SideMovement = - Bacon3SideMovement;
    }else if(Bacon3.center.x < 9){
        Bacon3SideMovement = Bacon3SideMovement*(-1);
    }
    if (Bacon4.center.x > 311){
        Bacon4SideMovement = - Bacon4SideMovement;
    }else if(Bacon4.center.x < 9){
        Bacon4SideMovement = Bacon4SideMovement*(-1);
    }
    if (Bacon5.center.x > 311){
        Bacon5SideMovement = - Bacon5SideMovement;
    }else if(Bacon5.center.x < 9){
        Bacon5SideMovement = Bacon5SideMovement*(-1);
    }

    
    if (Bacon1.center.y > 574){
        RandomPosition = arc4random() %248;
        RandomPosition = RandomPosition + 36;
        Bacon1.center = CGPointMake(RandomPosition, Bacon5.center.y - 116);
        Bacon1Used = NO;
        Bacon1.hidden = NO;
        Backlight1.hidden = NO;
        BaconBomb1.hidden = YES;
        if (Bacon1SideMovement < 4 && Bacon1SideMovement > -4){
        if (Bacon1SideMovement > 0){
            Bacon1SideMovement = Bacon1SideMovement + 0.1;
        }else{
            Bacon1SideMovement = Bacon1SideMovement - 0.1;
        }
        }
    
    }
    if (Bacon2.center.y > 574){
        RandomPosition = arc4random() %248;
        RandomPosition = RandomPosition + 36;
        Bacon2.center = CGPointMake(RandomPosition, Bacon1.center.y - 116);
        Bacon2Used = NO;
        Backlight2.hidden = NO;
        Bacon2.hidden = NO;
        BaconBomb2.hidden = YES;
        if (Bacon2SideMovement < 4 && Bacon2SideMovement > -4){
        if (Bacon2SideMovement > 0){
            Bacon2SideMovement = Bacon2SideMovement + 0.1;
        }else{
            Bacon2SideMovement = Bacon2SideMovement - 0.1;
        }
        }
    }
    if (Bacon3.center.y > 574){
        RandomPosition = arc4random() %248;
        RandomPosition = RandomPosition + 36;
        Bacon3.center = CGPointMake(RandomPosition, Bacon2.center.y - 116);
        Bacon3Used = NO;
        Backlight3.hidden = NO;
        Bacon3.hidden = NO;
        BaconBomb3.hidden = YES;
        if (Bacon3SideMovement < 4 && Bacon3SideMovement > -4){
        if (Bacon3SideMovement > 0){
            Bacon3SideMovement = Bacon3SideMovement + 0.1;
        }else{
            Bacon3SideMovement = Bacon3SideMovement - 0.1;
        }
        }
    }
    if (Bacon4.center.y > 574){
        RandomPosition = arc4random() %248;
        RandomPosition = RandomPosition + 36;
        Bacon4.center = CGPointMake(RandomPosition, Bacon3.center.y - 116);
        Bacon4Used = NO;
        Bacon4.hidden = NO;
        Backlight4.hidden = NO;
        BaconBomb4.hidden = YES;
        if (Bacon4SideMovement < 4 && Bacon4SideMovement > -4){
        if (Bacon4SideMovement > 0){
            Bacon4SideMovement = Bacon4SideMovement + 0.1;
        }else{
            Bacon4SideMovement = Bacon4SideMovement - 0.1;
        }
        }
    }
    if (Bacon5.center.y > 574){
        RandomPosition = arc4random() %248;
        RandomPosition = RandomPosition + 36;
        Bacon5.center = CGPointMake(RandomPosition, Bacon4.center.y - 116);
        Bacon5Used = NO;
        Bacon5.hidden = NO;
        Backlight5.hidden = NO;
        BaconBomb5.hidden = YES;
        if (Bacon5SideMovement < 4 && Bacon5SideMovement > -4){
        if (Bacon5SideMovement > 0){
            Bacon5SideMovement = Bacon5SideMovement + 0.1;
        }else{
            Bacon5SideMovement = Bacon5SideMovement - 0.1;
        }
        }
    }
    }
    if ([UIScreen mainScreen].bounds.size.height>600){
        if (Bacon1.center.x > 750){
            Bacon1SideMovement = - Bacon1SideMovement;
        }else if(Bacon1.center.x < 18){
            Bacon1SideMovement = Bacon1SideMovement*(-1);
        }
        if (Bacon2.center.x > 750){
            Bacon2SideMovement = - Bacon2SideMovement;
        }else if(Bacon2.center.x < 18){
            Bacon2SideMovement = Bacon2SideMovement*(-1);
        }
        if (Bacon3.center.x > 750){
            Bacon3SideMovement = - Bacon3SideMovement;
        }else if(Bacon3.center.x < 18){
            Bacon3SideMovement = Bacon3SideMovement*(-1);
        }
        if (Bacon4.center.x > 750){
            Bacon4SideMovement = - Bacon4SideMovement;
        }else if(Bacon4.center.x < 18){
            Bacon4SideMovement = Bacon4SideMovement*(-1);
        }
        if (Bacon5.center.x > 750){
            Bacon5SideMovement = - Bacon5SideMovement;
        }else if(Bacon5.center.x < 18){
            Bacon5SideMovement = Bacon5SideMovement*(-1);
        }
        
        
        if (Bacon1.center.y > 1039){
            RandomPosition = arc4random() %740;
            RandomPosition = RandomPosition + 14;
            Bacon1.center = CGPointMake(RandomPosition, Bacon5.center.y - 232);
            Bacon1Used = NO;
            Bacon1.hidden = NO;
            Backlight1.hidden = NO;
            BaconBomb1.hidden = YES;
            if (Bacon1SideMovement < 8 && Bacon1SideMovement > -8){
                if (Bacon1SideMovement > 0){
                    Bacon1SideMovement = Bacon1SideMovement + 0.2;
                }else{
                    Bacon1SideMovement = Bacon1SideMovement - 0.2;
                }
            }
            
        }
        if (Bacon2.center.y > 1039){
            RandomPosition = arc4random() %740;
            RandomPosition = RandomPosition + 14;
            Bacon2.center = CGPointMake(RandomPosition, Bacon1.center.y - 232);
            Bacon2Used = NO;
            Backlight2.hidden = NO;
            Bacon2.hidden = NO;
            BaconBomb2.hidden = YES;
            if (Bacon2SideMovement < 8 && Bacon2SideMovement > -8){
                if (Bacon2SideMovement > 0){
                    Bacon2SideMovement = Bacon2SideMovement + 0.2;
                }else{
                    Bacon2SideMovement = Bacon2SideMovement - 0.2;
                }
            }
        }
        if (Bacon3.center.y > 1039){
            RandomPosition = arc4random() %740;
            RandomPosition = RandomPosition + 14;
            Bacon3.center = CGPointMake(RandomPosition, Bacon2.center.y - 232);
            Bacon3Used = NO;
            Backlight3.hidden = NO;
            Bacon3.hidden = NO;
            BaconBomb3.hidden = YES;
            if (Bacon3SideMovement < 8 && Bacon3SideMovement > -8){
                if (Bacon3SideMovement > 0){
                    Bacon3SideMovement = Bacon3SideMovement + 0.2;
                }else{
                    Bacon3SideMovement = Bacon3SideMovement - 0.2;
                }
            }
        }
        if (Bacon4.center.y > 1039){
            RandomPosition = arc4random() %740;
            RandomPosition = RandomPosition + 14;
            Bacon4.center = CGPointMake(RandomPosition, Bacon3.center.y - 232);
            Bacon4Used = NO;
            Bacon4.hidden = NO;
            Backlight4.hidden = NO;
            BaconBomb4.hidden = YES;
            if (Bacon4SideMovement < 8 && Bacon4SideMovement > -8){
                if (Bacon4SideMovement > 0){
                    Bacon4SideMovement = Bacon4SideMovement + 0.2;
                }else{
                    Bacon4SideMovement = Bacon4SideMovement - 0.2;
                }
            }
        }
        if (Bacon5.center.y > 1039){
            RandomPosition = arc4random() %740;
            RandomPosition = RandomPosition + 14;
            Bacon5.center = CGPointMake(RandomPosition, Bacon4.center.y - 232);
            Bacon5Used = NO;
            Bacon5.hidden = NO;
            Backlight5.hidden = NO;
            BaconBomb5.hidden = YES;
            if (Bacon5SideMovement < 8 && Bacon5SideMovement > -8){
                if (Bacon5SideMovement > 0){
                    Bacon5SideMovement = Bacon5SideMovement + 0.2;
                }else{
                    Bacon5SideMovement = Bacon5SideMovement - 0.2;
                }
            }
        }
    }
    if ([UIScreen mainScreen].bounds.size.height>567 && [UIScreen mainScreen].bounds.size.height<599){
    if (Sun.center.y < 430){
        if (Cloud1.center.y > 595){
            RandomPosition = arc4random() %248;
            RandomPosition = RandomPosition + 36;
            Cloud1.center = CGPointMake(RandomPosition, -17);
            Cloud1.hidden = NO;
        }
        if (Cloud2.center.y > 587){
            RandomPosition = arc4random() %248;
            RandomPosition = RandomPosition + 36;
            Cloud2.center = CGPointMake(RandomPosition, -9);
            Cloud2.hidden = NO;
        }
        if (Cloud3.center.y > 590){
            RandomPosition = arc4random() %248;
            RandomPosition = RandomPosition + 36;
            Cloud3.center = CGPointMake(RandomPosition, -12);
            Cloud3.hidden = NO;
        }
    }
        if (Sun.center.y > 620){
            FadeBG.center = CGPointMake(160, -284);
            FadeBG.hidden = NO;
        }
        if(FadeBG.center.y > 284 && FadeBG.hidden == NO){
            NightBG.hidden = NO;
        }
        if (Sun.center.y > 622){
            Sun.center = CGPointMake(Sun.center.x, 620);
            Sun.hidden = YES;
        }
    }
    
    if ([UIScreen mainScreen].bounds.size.height<567){
        if (Sun.center.y < 363){
            if (Cloud1.center.y > 595){
                RandomPosition = arc4random() %248;
                RandomPosition = RandomPosition + 36;
                Cloud1.center = CGPointMake(RandomPosition, -17);
                Cloud1.hidden = NO;
            }
            if (Cloud2.center.y > 587){
                RandomPosition = arc4random() %248;
                RandomPosition = RandomPosition + 36;
                Cloud2.center = CGPointMake(RandomPosition, -9);
                Cloud2.hidden = NO;
            }
            if (Cloud3.center.y > 590){
                RandomPosition = arc4random() %248;
                RandomPosition = RandomPosition + 36;
                Cloud3.center = CGPointMake(RandomPosition, -12);
                Cloud3.hidden = NO;
            }
        }
        if (Sun.center.y > 501){
            FadeBG.center = CGPointMake(160, -197);
            FadeBG.hidden = NO;
        }
        if(FadeBG.center.y > 197 && FadeBG.hidden == NO){
            NightBG.hidden = NO;
        }
        if (Sun.center.y > 503){
            Sun.center = CGPointMake(Sun.center.x, 501);
            Sun.hidden = YES;
        }
    }
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        if (Sun.center.y < 726){
            if (Cloud1.center.y > 1060){
                RandomPosition = arc4random() %610;
                RandomPosition = RandomPosition + 79;
                Cloud1.center = CGPointMake(RandomPosition, -36);
                Cloud1.hidden = NO;
            }
            if (Cloud2.center.y > 1043){
                RandomPosition = arc4random() %678;
                RandomPosition = RandomPosition + 45;
                Cloud2.center = CGPointMake(RandomPosition, -19);
                Cloud2.hidden = NO;
            }
            if (Cloud3.center.y > 1048){
                RandomPosition = arc4random() %646;
                RandomPosition = RandomPosition + 61;
                Cloud3.center = CGPointMake(RandomPosition, -24);
                Cloud3.hidden = NO;
            }
        }
        if (Sun.center.y > 1029){
            FadeBG.center = CGPointMake(384, -513);
            FadeBG.hidden = NO;
        }
        if(FadeBG.center.y > 513 && FadeBG.hidden == NO){
            NightBG.hidden = NO;
        }
        if (Sun.center.y > 1134){
            Sun.center = CGPointMake(Sun.center.x, 1029);
            Sun.hidden = YES;
        }
    }

    
}




-(void)Bounce{
    
    if ([UIScreen mainScreen].bounds.size.height>567 && [UIScreen mainScreen].bounds.size.height<599){
    if (Piggy.center.y > 500){
        UpMovement = 7;
    }
    else if (Piggy.center.y > 450){
        UpMovement = 6;
    }
    else if (Piggy.center.y > 400){
        UpMovement = 5;
    }
    else if (Piggy.center.y > 350){
        UpMovement = 4;
    }
    else if (Piggy.center.y > 300){
        UpMovement = 3;
    }
    else if (Piggy.center.y > 250){
        UpMovement = 2;
    }
    }
    
    if ([UIScreen mainScreen].bounds.size.height<567){
        if (Piggy.center.y > 413){
            UpMovement = 7;
        }
        else if (Piggy.center.y > 363){
            UpMovement = 6;
        }
        else if (Piggy.center.y > 313){
            UpMovement = 5;
        }
        else if (Piggy.center.y > 263){
            UpMovement = 4;
        }
        else if (Piggy.center.y > 213){
            UpMovement = 3;
        }
        else if (Piggy.center.y > 163){
            UpMovement = 2;
        }
        
    }
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        if (Piggy.center.y > 826){
            UpMovement = 14;
        }
        else if (Piggy.center.y > 726){
            UpMovement = 12;
        }
        else if (Piggy.center.y > 626){
            UpMovement = 10;
        }
        else if (Piggy.center.y > 526){
            UpMovement = 8;
        }
        else if (Piggy.center.y > 426){
            UpMovement = 6;
        }
        else if (Piggy.center.y > 326){
            UpMovement = 4;
        }
        
    }
    
}

-(void)Moving{
    
    
    if ([UIScreen mainScreen].bounds.size.height>567 && [UIScreen mainScreen].bounds.size.height<599)
    if (Piggy.center.y > 600){
        [self GameOver];
    }
    
    if ([UIScreen mainScreen].bounds.size.height<567){
        if (Piggy.center.y < 163){
            Piggy.center = CGPointMake(Piggy.center.x, 163);
        }
        if (Piggy.center.y > 513){
            [self GameOver];
        }
    }
    if ([UIScreen mainScreen].bounds.size.height>567){
        if (Piggy.center.y < 250){
            Piggy.center = CGPointMake(Piggy.center.x, 250);
        }
    }
    if ([UIScreen mainScreen].bounds.size.height>600){
        if (Piggy.center.y < 326){
            Piggy.center = CGPointMake(Piggy.center.x, 326);
        }
        if (Piggy.center.y > 1080){
            [self GameOver];
        }
    }
    
    [self Scoring];
    
    [self BaconMovement];
    
    Backlight1.center = CGPointMake(Bacon1.center.x, Bacon1.center.y);
    Backlight2.center = CGPointMake(Bacon2.center.x, Bacon2.center.y);
    Backlight3.center = CGPointMake(Bacon3.center.x, Bacon3.center.y);
    Backlight4.center = CGPointMake(Bacon4.center.x, Bacon4.center.y);
    Backlight5.center = CGPointMake(Bacon5.center.x, Bacon5.center.y);
    
    Piggy.center = CGPointMake(Piggy.center.x, Piggy.center.y - UpMovement);
    
    if((CGRectIntersectsRect(Piggy.frame, Ground.frame))){
        TouchesBeganUsed = NO;
        Piggy.center = CGPointMake(Piggy.center.x, 541);
        if ([UIScreen mainScreen].bounds.size.height<568){
            
            Piggy.center = CGPointMake(Piggy.center.x, 454);
            
        }
        if ([UIScreen mainScreen].bounds.size.height>600){
            Piggy.center = CGPointMake(Piggy.center.x, 965);
        }
            

        UpMovement = 0;
        
        Instructions.hidden = NO;
        MusicOnOff.hidden = NO;
        Score.hidden = YES;
    }
    
    if (Bacon1.hidden == NO){
    if((CGRectIntersectsRect(Piggy.frame, Bacon1.frame)) ){
        TouchesBeganUsed = YES;
        [self Bounce];
        [self BaconFall];
        
        AudioServicesPlaySystemSound(PlayBellSoundID);
        
        if (Bacon1Used == NO){
            ScoreNumber = ScoreNumber + 1;
            Bacon1Used = YES;
        }
        if (Bacon1Used == YES){
            Bacon1.hidden = YES;
            Backlight1.hidden = YES;
        }
        BaconBomb1.hidden = NO;
        BaconBomb1.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"BaconBomb1.png"],
                                      [UIImage imageNamed:@"BaconBomb2.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb4.png"], nil];
        
        [BaconBomb1 setAnimationRepeatCount:1];
        BaconBomb1.animationDuration = 0.5;
        [BaconBomb1 startAnimating];
    }
    }
    if (Bacon2.hidden == NO){
    if((CGRectIntersectsRect(Piggy.frame, Bacon2.frame)) ){
        [self Bounce];
        [self BaconFall];
        
        AudioServicesPlaySystemSound(PlayBellSoundID);
        
        if (Bacon2Used == NO){
            ScoreNumber = ScoreNumber + 1;
            Bacon2Used = YES;
        }
        if (Bacon2Used == YES){
            Bacon2.hidden = YES;
            Backlight2.hidden = YES;
        }
        BaconBomb2.hidden = NO;
        BaconBomb2.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"BaconBomb1.png"],
                                      [UIImage imageNamed:@"BaconBomb2.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb4.png"], nil];
        
        [BaconBomb2 setAnimationRepeatCount:1];
        BaconBomb2.animationDuration = 0.5;
        [BaconBomb2 startAnimating];
    }
    }
    if (Bacon3.hidden == NO){
    if((CGRectIntersectsRect(Piggy.frame, Bacon3.frame)) ){
        [self Bounce];
        [self BaconFall];
        
        AudioServicesPlaySystemSound(PlayBellSoundID);
        
        if (Bacon3Used == NO){
            ScoreNumber = ScoreNumber + 1;
            Bacon3Used = YES;
        }
        if (Bacon3Used == YES){
            Bacon3.hidden = YES;
            Backlight3.hidden = YES;
        }
        BaconBomb3.hidden = NO;
        BaconBomb3.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"BaconBomb1.png"],
                                      [UIImage imageNamed:@"BaconBomb2.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb4.png"], nil];
        
        [BaconBomb3 setAnimationRepeatCount:1];
        BaconBomb3.animationDuration = 0.5;
        [BaconBomb3 startAnimating];
    }
    }
    if (Bacon4.hidden == NO){
    if((CGRectIntersectsRect(Piggy.frame, Bacon4.frame)) ){
        [self Bounce];
        [self BaconFall];
        
        AudioServicesPlaySystemSound(PlayBellSoundID);
        
        if (Bacon4Used == NO){
            ScoreNumber = ScoreNumber + 1;
            Bacon4Used = YES;
        }
        if (Bacon4Used == YES){
            Bacon4.hidden = YES;
            Backlight4.hidden = YES;
        }
        BaconBomb4.hidden = NO;
        BaconBomb4.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"BaconBomb1.png"],
                                      [UIImage imageNamed:@"BaconBomb2.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb4.png"], nil];
        
        [BaconBomb4 setAnimationRepeatCount:1];
        BaconBomb4.animationDuration = 0.5;
        [BaconBomb4 startAnimating];
    }
    }
    if (Bacon5.hidden == NO){
    if((CGRectIntersectsRect(Piggy.frame, Bacon5.frame)) ){
        [self Bounce];
        [self BaconFall];
        
        AudioServicesPlaySystemSound(PlayBellSoundID);
        
        if (Bacon5Used == NO){
            ScoreNumber = ScoreNumber + 1;
            Bacon5Used = YES;
        }
        if (Bacon5Used == YES){
            Bacon5.hidden = YES;
            Backlight5.hidden = YES;
        }
        BaconBomb5.hidden = NO;
        BaconBomb5.animationImages = [NSArray arrayWithObjects:
                                      [UIImage imageNamed:@"BaconBomb1.png"],
                                      [UIImage imageNamed:@"BaconBomb2.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb3.png"],
                                      [UIImage imageNamed:@"BaconBomb4.png"], nil];
        
        [BaconBomb5 setAnimationRepeatCount:1];
        BaconBomb5.animationDuration = 0.5;
        [BaconBomb5 startAnimating];
    }
    }
    
    if ([UIScreen mainScreen].bounds.size.height<599){
        UpMovement = UpMovement - 0.3;
    }
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        UpMovement = UpMovement - 0.6;
    }
    
}


-(IBAction)MusicButton{
    
    if (Music == YES){
        Music = NO;
        if (MusicStop == NO){
            [self StopMusic];
        }
        UIImage *MusicImageOff = [UIImage imageNamed:@"MusicOff.png"];
        [MusicOnOff setImage:MusicImageOff forState:UIControlStateNormal];
        
    }else {
        Music = YES;
        if (MusicStop == NO){
        [newPlayer setVolume:0.3];
        }
        UIImage *MusicImageOn = [UIImage imageNamed:@"MusicOn.png"];
        [MusicOnOff setImage:MusicImageOn forState:UIControlStateNormal];
        
    }
}

-(IBAction)StartMusic{
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"Guitar" ofType:@"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    newPlayer.numberOfLoops = -1; // Loop indefinately
    newPlayer.volume = 0.3;
    [newPlayer play];
}

-(IBAction)StopMusic{
        [newPlayer setVolume:0];
}

-(IBAction)StartGame:(id)sender{
    
    AudioServicesPlaySystemSound(PlayWindSoundID);
    
    
    [self StartMusic];
    if (Music == NO){
        [self StopMusic];
    }
    

    StartGame.hidden = YES;
    Rank.hidden = YES;
    FadeBG.hidden = YES;
    MusicOnOff.hidden = NO;
    UpMovement = -8;
    ScoreNumber = 0;
    
    Movement = [NSTimer scheduledTimerWithTimeInterval:0.015 target:self selector:@selector(Moving) userInfo:nil repeats:YES];
    
    Bacon1.hidden = NO;
    Bacon2.hidden = NO;
    Bacon3.hidden = NO;
    Bacon4.hidden = NO;
    Bacon5.hidden = NO;
    
    Bacon1Used = NO;
    Bacon2Used = NO;
    Bacon3Used = NO;
    Bacon4Used = NO;
    Bacon5Used = NO;
    
    if ([UIScreen mainScreen].bounds.size.height<599){
    Bacon1SideMovement = 0.1;
    Bacon2SideMovement = -0.1;
    Bacon3SideMovement = 0.1;
    Bacon4SideMovement = -0.1;
    Bacon5SideMovement = 0.1;
    }
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        Bacon1SideMovement = 0.2;
        Bacon2SideMovement = -0.2;
        Bacon3SideMovement = 0.2;
        Bacon4SideMovement = -0.2;
        Bacon5SideMovement = 0.2;
    }
    
    Cloud1.hidden = NO;
    Cloud2.hidden = NO;
    Cloud3.hidden = NO;
    
    Piggy.hidden = NO;
    Ground.hidden = NO;
    Sun.hidden = NO;
    Instructions.hidden = NO;
    MusicStop = NO;
    
    GameOver.hidden = YES;
    FinalScore.hidden = YES;
    HighScore.hidden = YES;
    HighScore2.hidden = YES;
    NightBG.hidden = YES;
    ScoreBoard.hidden = YES;
    HighScoreBoard.hidden = YES;
    
    
    
    Piggy.center = CGPointMake(160, 541);
    Ground.center = CGPointMake(160, 560);
    GroundBG.center = CGPointMake(160, 536);
    
    if ([UIScreen mainScreen].bounds.size.height<568){
        
        Piggy.center = CGPointMake(160, 454);
        Ground.center = CGPointMake(160, 472);
        GroundBG.center = CGPointMake(160, 450);
        
    }
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        
        Piggy.center = CGPointMake(384, 965);
        Ground.center = CGPointMake(384, 1007);
        GroundBG.center = CGPointMake(384, 959);
    }
    
    if ([UIScreen mainScreen].bounds.size.height>567 && [UIScreen mainScreen].bounds.size.height<599){
    RandomPosition = arc4random()%248;
    RandomPosition = RandomPosition + 36;
    Bacon1.center = CGPointMake(RandomPosition, 469);
    }
   
    if ([UIScreen mainScreen].bounds.size.height<567){
        RandomPosition = arc4random()%248;
        RandomPosition = RandomPosition + 36;
        Bacon1.center = CGPointMake(RandomPosition, 382);
        Instructions.center = CGPointMake(160, 250);
        StartGame.center = CGPointMake(108, 390);
        Rank.center = CGPointMake(212, 390);
        ScoreBoard.center = CGPointMake(160, 248);
        HighScore.center = CGPointMake(160, 200);
        HighScore2.center = CGPointMake(160, 294);
        FinalScore.center = CGPointMake(220, 231);
        HighScoreBoard.center = CGPointMake(232, 260);
        
        
        RandomPosition = arc4random()%248;
        RandomPosition = RandomPosition + 36;
        Cloud1.center = CGPointMake(RandomPosition, 400);
        
        RandomPosition = arc4random()%248;
        RandomPosition = RandomPosition + 36;
        Cloud2.center = CGPointMake(RandomPosition, 225);
        
        RandomPosition = arc4random()%248;
        RandomPosition = RandomPosition + 36;
        Cloud3.center = CGPointMake(RandomPosition, 50);
        
    }
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        RandomPosition = arc4random()%248;
        RandomPosition = RandomPosition + 36;
        Bacon1.center = CGPointMake(RandomPosition, 850);
        Instructions.center = CGPointMake(384, 513);
        StartGame.center = CGPointMake(270, 822);
        Rank.center = CGPointMake(498, 822);
        ScoreBoard.center = CGPointMake(384, 513);
        HighScore.center = CGPointMake(414, 414);
        HighScore2.center = CGPointMake(414, 606);
        FinalScore.center = CGPointMake(393, 489);
        HighScoreBoard.center = CGPointMake(393, 539);
        
        
        RandomPosition = arc4random()%611;
        RandomPosition = RandomPosition + 78;
        Cloud1.center = CGPointMake(RandomPosition, 800);
        
        RandomPosition = arc4random()%611;
        RandomPosition = RandomPosition + 78;
        Cloud2.center = CGPointMake(RandomPosition, 450);
        
        RandomPosition = arc4random()%611;
        RandomPosition = RandomPosition + 78;
        Cloud3.center = CGPointMake(RandomPosition, 50);
        
    }
    
    if ([UIScreen mainScreen].bounds.size.height<599){
    RandomPosition = arc4random()%248;
    RandomPosition = RandomPosition + 36;
    Bacon2.center = CGPointMake(RandomPosition, Bacon1.center.y - 116);
    
    RandomPosition = arc4random()%248;
    RandomPosition = RandomPosition + 36;
    Bacon3.center = CGPointMake(RandomPosition, Bacon2.center.y - 116);
    
    RandomPosition = arc4random()%248;
    RandomPosition = RandomPosition + 36;
    Bacon4.center = CGPointMake(RandomPosition, Bacon3.center.y - 116);
    
    RandomPosition = arc4random()%248;
    RandomPosition = RandomPosition + 36;
    Bacon5.center = CGPointMake(RandomPosition, Bacon4.center.y - 116);
    }
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        RandomPosition = arc4random()%740;
        RandomPosition = RandomPosition + 14;
        Bacon2.center = CGPointMake(RandomPosition, Bacon1.center.y - 232);
        
        RandomPosition = arc4random()%740;
        RandomPosition = RandomPosition + 14;
        Bacon3.center = CGPointMake(RandomPosition, Bacon2.center.y - 232);
        
        RandomPosition = arc4random()%740;
        RandomPosition = RandomPosition + 14;
        Bacon4.center = CGPointMake(RandomPosition, Bacon3.center.y - 232);
        
        RandomPosition = arc4random()%740;
        RandomPosition = RandomPosition + 14;
        Bacon5.center = CGPointMake(RandomPosition, Bacon4.center.y - 232);
    }
    
    if ([UIScreen mainScreen].bounds.size.height>567 && [UIScreen mainScreen].bounds.size.height<599){
    RandomPosition = arc4random()%248;
    RandomPosition = RandomPosition + 36;
    Cloud1.center = CGPointMake(RandomPosition, 450);
    
    RandomPosition = arc4random()%248;
    RandomPosition = RandomPosition + 36;
    Cloud2.center = CGPointMake(RandomPosition, 250);
    
    RandomPosition = arc4random()%248;
    RandomPosition = RandomPosition + 36;
    Cloud3.center = CGPointMake(RandomPosition, 50);
    }
    
    BaconBomb1.hidden = YES;
    BaconBomb2.hidden = YES;
    BaconBomb3.hidden = YES;
    BaconBomb4.hidden = YES;
    BaconBomb5.hidden = YES;
    
    Backlight1.hidden = NO;
    Backlight2.hidden = NO;
    Backlight3.hidden = NO;
    Backlight4.hidden = NO;
    Backlight5.hidden = NO;
    
    Sun.center = CGPointMake(295, 45);
    
    if ([UIScreen mainScreen].bounds.size.height>600){
        Sun.center = CGPointMake(708, 86);
    }
    
}



@end
