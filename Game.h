//
//  Game.h
//  Bacon Piggy
//
//  Created by Pierre on 2014-02-16.
//  Copyright (c) 2014 Pierre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <GameKit/GameKit.h>
#import "GAITrackedViewController.h"

AVAudioPlayer *newPlayer;

float UpMovement;
int RandomPosition;

float BaconMoveDown;
float Bacon1SideMovement;
float Bacon2SideMovement;
float Bacon3SideMovement;
float Bacon4SideMovement;
float Bacon5SideMovement;

int ScoreNumber;
int HighScoreNumber;
int AddedScore;

BOOL Bacon1Used;
BOOL Bacon2Used;
BOOL Bacon3Used;
BOOL Bacon4Used;
BOOL Bacon5Used;

BOOL TouchesBeganUsed;
BOOL Music;
BOOL MusicStop;

@interface Game : GAITrackedViewController <GKGameCenterControllerDelegate>

{

    IBOutlet UIButton *StartGame;
    IBOutlet UIButton *MusicOnOff;
    IBOutlet UIButton *Rank;
    IBOutlet UIImageView *Piggy;
    IBOutlet UIImageView *Bacon1;
    IBOutlet UIImageView *Bacon2;
    IBOutlet UIImageView *Bacon3;
    IBOutlet UIImageView *Bacon4;
    IBOutlet UIImageView *Bacon5;
    IBOutlet UIImageView *Cloud1;
    IBOutlet UIImageView *Cloud2;
    IBOutlet UIImageView *Cloud3;
    IBOutlet UIImageView *Ground;
    IBOutlet UIImageView *Sun;
    IBOutlet UIImageView *FadeBG;
    IBOutlet UIImageView *NightBG;
    IBOutlet UIImageView *GameOver;
    IBOutlet UIImageView *ScoreBoard;
    IBOutlet UIImageView *BaconBomb1;
    IBOutlet UIImageView *BaconBomb2;
    IBOutlet UIImageView *BaconBomb3;
    IBOutlet UIImageView *BaconBomb4;
    IBOutlet UIImageView *BaconBomb5;
    IBOutlet UIImageView *Backlight1;
    IBOutlet UIImageView *Backlight2;
    IBOutlet UIImageView *Backlight3;
    IBOutlet UIImageView *Backlight4;
    IBOutlet UIImageView *Backlight5;
    IBOutlet UIImageView *GroundBG;
    IBOutlet UIImageView *Instructions;
    
    IBOutlet UILabel *Score;
    IBOutlet UILabel *FinalScore;
    IBOutlet UILabel *HighScore;
    IBOutlet UILabel *HighScore2;
    IBOutlet UILabel *HighScoreBoard;
    
    SystemSoundID PlayBellSoundID;
    SystemSoundID PlayWindSoundID;
    SystemSoundID PlayGuitarSoundID;
    
    NSTimer *Movement;
    
    
}

-(IBAction)StartGame:(id)sender;
-(IBAction)MusicButton;
-(void)Moving;
-(void)Bounce;
-(void)BaconMovement;
-(void)BaconFall;
-(void)Scoring;
-(void)GameOver;
-(IBAction)ShowRank:(id)sender;

@end
