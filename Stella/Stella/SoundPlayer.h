//
//  SoundPlayer.h
//  Stella
//
//  Created by Rob Timpone on 4/13/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface SoundPlayer : NSObject <AVAudioPlayerDelegate>

+ (id)sharedSoundPlayer;

- (void)playSystemSound:(NSString *)fileName;
- (void)playSystemSound:(NSString *)fileName withDelay:(CGFloat)delay;

- (void)playAVAudioPlayerSound:(NSString *)filename;
- (void)playAVAudioPlayerSound:(NSString *)fileName withDelay:(CGFloat)delay;
- (void)stopAVAudioPlayer;

- (void)playSound:(NSString *)fileName givenNarrating:(BOOL)narrating;
- (void)playSound:(NSString *)fileName givenNarrating:(BOOL)narrating withDelay:(CGFloat)delay;

@end
