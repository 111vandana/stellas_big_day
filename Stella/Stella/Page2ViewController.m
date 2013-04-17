//
//  Page2ViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import "Page2ViewController.h"
#import "SoundPlayer.h"

@interface Page2ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *stellaButton;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *hotDogs;     // collection of all hot dog image outlets
@property (weak, nonatomic) IBOutlet UIButton *vendorButton;
@property (weak, nonatomic) IBOutlet UITextView *page2Text;
@property (weak, nonatomic) IBOutlet UIButton *readToMeButton;

@end


@implementation Page2ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageNumber = 2;
    self.readToMeButtonOutlet = self.readToMeButton;
}


#pragma mark - Button methods

// Converts a number from degrees to radians (formula found at stackoverflow.com/questions/12656961)
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

- (IBAction)readToMeButtonTapped
{
    NSLog(@"Read to me button tapped");
    [[SoundPlayer sharedSoundPlayer] playAVAudioPlayerSound:[NSString stringWithFormat:@"page%d",self.pageNumber]];
    [self readToMe:self.page2Text pageNumber:self.pageNumber];
}

- (IBAction)stellaButtonTapped
{
    NSLog(@"Stella button tapped");
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"barks"];    
    [self wiggleView:self.stellaButton];
}

- (IBAction)vendorButtonTapped
{
    NSLog(@"Vendor button tapped");
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"hotdogs"];
    
    // Passes a hot dog in the outlet collection to the feedStellaHotDog: method
    [self feedStellaHotDog:[self.hotDogs lastObject]];
}


#pragma mark - Animation methods

// Animates a hot dog being thrown to stella using nested animation blocks and sound effects
- (void)feedStellaHotDog:(UIView *)hotDogImageView
{
    [UIView animateWithDuration:0.6
                               delay:0.0
                             options:UIViewAnimationOptionCurveLinear
                          animations:^(void) {
                              
                              // disables vendor button while animation is in progress
                              self.vendorButton.enabled = NO;
                              
                              hotDogImageView.center = CGPointMake(175, 415);
                              
                          }completion:^(BOOL finished) {
                              
                              // hot dog disappears when animation is completed (stella 'ate' it)
                              hotDogImageView.hidden = YES;

                              // removes the hot dog image that was thrown from the outlet collection
                              NSMutableArray *mutableHotDogs = [self.hotDogs mutableCopy];
                              [mutableHotDogs removeObject:hotDogImageView];
                              self.hotDogs = mutableHotDogs;
                            
                              [[SoundPlayer sharedSoundPlayer] playSystemSound:@"eating"];
                              [self angleViewUp:self.stellaButton];
                              
                              NSLog(@"Vendor threw hot dog, %d remaining",[self.hotDogs count]);
                              
                              // Animates the vendor moving offscreen if all of the hot dog have been thrown
                              if ([self.hotDogs count] == 0) {
                                  [self moveViewOffscreenToRight:self.vendorButton];
                              }
                              
                              // Re-enables the vendor button once the animations are complete
                              self.vendorButton.enabled = YES;
                          }];
}

// Angles a view up 45 degrees (also plays a sound effect in this implementation)
- (void)angleViewUp:(UIView *)view
{
    [UIView animateWithDuration:0.2
                            delay:0.3
                          options:UIViewAnimationOptionCurveEaseOut
                       animations:^(void) {
                           view.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45));
                       }completion:^(BOOL finished) {
                           NSLog(@"View nodded up");
                           [[SoundPlayer sharedSoundPlayer] playSystemSound:@"pant"];
                           [self restoreViewPosition:view];
                       }];
}

// Restores a view to its original position at 0 degrees
- (void)restoreViewPosition:(UIView *)view
{
    [UIView animateWithDuration:0.2
                            delay:0.0
                          options:UIViewAnimationOptionCurveEaseOut
                       animations:^(void) {
                           view.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
                       }completion:^(BOOL finished) {
                           NSLog(@"View nodded down");
                       }];
}

// Moves a view offscreen to the right
- (void)moveViewOffscreenToRight:(UIView *)view
{
    [UIView animateWithDuration:0.5
                            delay:0.5
                          options:UIViewAnimationOptionCurveEaseIn
                       animations:^(void) {
                           view.center = CGPointMake(1200, view.center.y);
                       }completion:^(BOOL finished) {
                           NSLog(@"View moved off screen");
                       }];
}


@end