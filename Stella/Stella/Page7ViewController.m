//
//  Page7ViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/14/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import "Page7ViewController.h"
#import "SoundPlayer.h"

@interface Page7ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *stellaImageView;
@property (weak, nonatomic) IBOutlet UITextView *page7Text;
@property (weak, nonatomic) IBOutlet UIButton *readToMeButton;

@end


@implementation Page7ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.pageNumber = 7;
    self.readToMeButtonOutlet = self.readToMeButton;
    
    // Moves the stella image offscreen before the view appears
    self.stellaImageView.center = CGPointMake(-200, 460);
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Starts the animation of stella running on screen, jumping, and running off screen
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(stellaRunsOnScreen)
                                   userInfo:nil
                                    repeats:NO];
}


#pragma mark - Button methods

- (IBAction)readToMeButtonTapped
{
    NSLog(@"Read to me button tapped");
    [[SoundPlayer sharedSoundPlayer] playAVAudioPlayerSound:[NSString stringWithFormat:@"page%d",self.pageNumber]];
    [self readToMe:self.page7Text pageNumber:self.pageNumber];
}


#pragma mark - Animation methods

// Animates stella running onscreen from the left, plays a sound effect
- (void)stellaRunsOnScreen
{
    [[SoundPlayer sharedSoundPlayer] playSound:@"barks" givenNarrating:self.narrationPlaying];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         self.stellaImageView.center = CGPointMake(512, 460);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Stella at center of screen");
                         [self stellaStartJump];
                     }];
}

// Animates stella jumping up, plays a sound effect
- (void)stellaStartJump
{
    [[SoundPlayer sharedSoundPlayer] playSound:@"pant" givenNarrating:self.narrationPlaying];
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         self.stellaImageView.center = CGPointMake(512, 360);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Stella jumped up");
                         [self stellaFinishJump];
                     }];
}

// Animates stella returning to the ground
- (void)stellaFinishJump
{
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         self.stellaImageView.center = CGPointMake(512, 460);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Stella finished jump");
                         [self stellaRunOffScreen];
                     }];
}

// Animates stella running offscreen to the right
- (void)stellaRunOffScreen
{
    [UIView animateWithDuration:0.6
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         self.stellaImageView.center = CGPointMake(1200, 460);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Stella ran off screen");
                     }];
}


@end
