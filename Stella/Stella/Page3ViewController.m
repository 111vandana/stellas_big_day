//
//  Page3ViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import "Page3ViewController.h"
#import "SoundPlayer.h"

@interface Page3ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *stellaButton;
@property (weak, nonatomic) IBOutlet UIImageView *frisbeeImage;
@property (weak, nonatomic) IBOutlet UITextView *page3Text;
@property (weak, nonatomic) IBOutlet UIButton *readToMeButton;

@end

@implementation Page3ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.pageNumber = 3;
    self.readToMeButtonOutlet = self.readToMeButton;
    
    // Moves the frisbee image just offscreen before the view appears
    self.frisbeeImage.center = CGPointMake(-100, 400);
}


#pragma mark - Button/animation methods

- (IBAction)readToMeButtonTapped
{
    NSLog(@"Read to me button tapped");
    [[SoundPlayer sharedSoundPlayer] playAVAudioPlayerSound:[NSString stringWithFormat:@"page%d",self.pageNumber]];
    [self readToMe:self.page3Text pageNumber:self.pageNumber];
}

// Animates a frisbee flying onscreen and stella jumping up to catch it, plays a sound effect
- (IBAction)stellaButtonTapped
{
    NSLog(@"Stella button tapped");
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"barks_short"];
    [UIView animateWithDuration:0.6
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseOut
                          animations:^(void) {
                              self.frisbeeImage.center = CGPointMake(840, 180);
                              self.stellaButton.center = CGPointMake(900, 200);
                          }
                          completion:^(BOOL finished) {
                              NSLog(@"Frisbee was thrown");
                              NSLog(@"Stella jumped for the frisbee");                              
                              [self stellaReturnToGround];
                          }];
}

// Animates stella returning to the ground with the frisbee in her mouth, plays a sound effect
- (void)stellaReturnToGround
{
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"catch"];
    [UIView animateWithDuration:0.6
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseIn
                          animations:^(void) {
                              self.frisbeeImage.center = CGPointMake(840, 415);
                              self.stellaButton.center = CGPointMake(900, 435);
                          }
                          completion:^(BOOL finished) {
                              NSLog(@"Stella returned to ground with frisbee");
                              [self returnFrisbeeToThrower];
                          }];
}

// Animates stella returning the frisbee to the thrower offscreen to the left, plays a sound effect
- (void)returnFrisbeeToThrower
{
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"running"];
    [UIView animateWithDuration:1.3
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseIn
                          animations:^(void) {
                              self.frisbeeImage.center = CGPointMake(-300, 415);
                              self.stellaButton.center = CGPointMake(-300, 435);
                          }
                          completion:^(BOOL finished) {
                              NSLog(@"Stella returned the frisbee");
                              self.frisbeeImage.center = CGPointMake(-100, 400);
                              [self stellaReturnToScreen];
                          }];
}

// Animates stella running across the screen from left to right, plays a sound effect
- (void)stellaReturnToScreen
{
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"running"];
    [UIView animateWithDuration:1.5
                               delay:0.0
                             options:UIViewAnimationOptionCurveEaseIn
                          animations:^(void) {
                              
                              // Changes the image on the stellaButton to the image of the dog facing right
                              NSString *stellaFacingRightFilePath = [[NSBundle mainBundle] pathForResource:@"stella_right" ofType:@"png"];
                              UIImage *stellaFacingRightImage = [UIImage imageWithContentsOfFile:stellaFacingRightFilePath];
                              [self.stellaButton setImage:stellaFacingRightImage forState:UIControlStateNormal];
                              
                              self.stellaButton.center = CGPointMake(1200, 435);
                          }
                          completion:^(BOOL finished) {
                              NSLog(@"Stella returned to the screen");
                              [self stellaTurnAround];
                          }];
}

// Animates stella returning to her original position from the right side of the screen, plays a sound effect
- (void)stellaTurnAround
{
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"pant"];
    [UIView animateWithDuration:0.7
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         
                              // Changes the image on the stellaButton to the image of the dog facing left                         
                         NSString *stellaFacingLeftFilePath = [[NSBundle mainBundle] pathForResource:@"stella_left" ofType:@"png"];
                         UIImage *stellaFacingLeftImage = [UIImage imageWithContentsOfFile:stellaFacingLeftFilePath];
                         [self.stellaButton setImage:stellaFacingLeftImage forState:UIControlStateNormal];
                         
                         self.stellaButton.center = CGPointMake(900, 435);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Stella turned around");
                     }];
}


@end
