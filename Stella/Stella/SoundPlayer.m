//
//  SoundPlayer.m
//  Stella
//
//  Created by Rob Timpone on 4/13/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//
//  SoundPlayer is a utility class that provides convenience methods to other classes that would like to play
//  sounds.  The class uses a Singleton so only one SoundPlayer can be instantiated.  All classes share this
//  same sound player by calling 'sharedSoundPlayer'.  Methods allow classes to play sounds using the System
//  Sound method or the AVAudioPlayer method, with or without a delay.  This class also provides methods to
//  determine which method to use based on a boolean variable, and a method to stop an AVAudioPlayer sound
//  currently playing.  

#import "SoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundPlayer()
@property (strong, nonatomic) AVAudioPlayer *player;

@end


@implementation SoundPlayer

// This follows the Singleton design pattern (learned about this in Object-Oriented Design class this week)
// Takes advantage of Grand Central Dispatch's 'dispatch_once' (this appears to be Apple's preferred method for creating Singletons)
// Used posts like stackoverflow.com/questions/7598820/ and stackoverflow.com/questions/9119042/ to verify this is the preferred method
+ (id)sharedSoundPlayer
{
    static SoundPlayer *sharedSoundPlayer = nil;            // static variable declaration - static, so this line is only called once
    static dispatch_once_t onceToken;                       // variable used to store the state of the dispatch_once call - also static, also only called once
    dispatch_once(&onceToken, ^{                            // only runs the following block of code one time
        sharedSoundPlayer = [[SoundPlayer alloc] init];
    });
    return sharedSoundPlayer;
}

// Sets itself as the AVAudioPlayer's delegate upon initialization
- (id)init
{
    self = [super init];
    if (self) {
        _player.delegate = self;
    }
    return self;
}


#pragma mark - System sound methods

// Plays a sound using the AudioServicesPlaySystemSound method
- (void)playSystemSound:(NSString *)fileName
{
    NSLog(@"Playing system sound");
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundFileURL, &soundID);
    AudioServicesPlaySystemSound(soundID);
}

// Plays a sound after a delay using the AudioServicesPlaySystemSound method
- (void)playSystemSound:(NSString *)fileName withDelay:(CGFloat)delay
{
    [NSTimer scheduledTimerWithTimeInterval:delay
                                     target:self
                                   selector:@selector(playSystemSoundWithTimer:)
                                   userInfo:@{@"filename": fileName}
                                    repeats:NO];
}

// Helper method that receives the sound's file name after the timer fires
- (void)playSystemSoundWithTimer:(NSTimer *)timer
{
    NSDictionary *userInfo = [timer userInfo];
    [self playSystemSound:userInfo[@"filename"]];
}


#pragma mark - AVAudioPlayer sound methods

// Plays a sound using the AVAudioPlayer 'play' method
- (void)playAVAudioPlayerSound:(NSString *)fileName
{
    NSLog(@"Playing AVAudioPlayer sound");
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
    NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
    
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:NULL];
    [self.player play];
}

// Plays a sound after a delay using the AVAudioPlayer 'play' method
- (void)playAVAudioPlayerSound:(NSString *)fileName withDelay:(CGFloat)delay
{
    [NSTimer scheduledTimerWithTimeInterval:delay
                                     target:self
                                   selector:@selector(playAVAudioPlayerSoundWithTimer:)
                                   userInfo:@{@"filename": fileName}
                                    repeats:NO];
}

// Helper method that receives the sound's file name after the timer fires
- (void)playAVAudioPlayerSoundWithTimer:(NSTimer *)timer
{
    NSDictionary *userInfo = [timer userInfo];
    [self playAVAudioPlayerSound:userInfo[@"filename"]];
}

// Stops any AVAudioPlayer sounds being played by the @property 'player'
- (void)stopAVAudioPlayer
{
    [self.player stop];
}


#pragma mark - Conditional sound methods

// If narration is currently playing, uses a system sound so the narration is not interrupted
- (void)playSound:(NSString *)fileName givenNarrating:(BOOL)narrating
{
    if (narrating) {
        [self playSystemSound:fileName];
        NSLog(@"Narration is playing, used system sound");
    } else {
        [self playAVAudioPlayerSound:fileName];
        NSLog(@"Narration is not playing, used AVAudioPlayer sound");
    }
}

// If narration is currently playing, uses a system sound so the narration is not interrupted (with a given delay)
- (void)playSound:(NSString *)fileName givenNarrating:(BOOL)narrating withDelay:(CGFloat)delay
{
    if (narrating) {
        [self playSystemSound:fileName withDelay:delay];
        NSLog(@"Narration is playing, used system sound");
    } else {
        [self playAVAudioPlayerSound:fileName withDelay:delay];
        NSLog(@"Narration is not playing, used AVAudioPlayer sound");
    }
}


#pragma mark - AVAudioPlayer delegate methods

// After a sound is finished playing, the player is set to nil to free up memory
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.player = nil;
}


@end
