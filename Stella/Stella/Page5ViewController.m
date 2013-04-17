//
//  Page5ViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import "Page5ViewController.h"
#import "SoundPlayer.h"

@interface Page5ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *laser;
@property (weak, nonatomic) IBOutlet UIImageView *rocket;
@property (weak, nonatomic) IBOutlet UIButton *ufoButton;
@property (weak, nonatomic) IBOutlet UITextView *page5Text;
@property (weak, nonatomic) IBOutlet UIButton *readToMeButton;

@end

@implementation Page5ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.pageNumber = 5;
    self.readToMeButtonOutlet = self.readToMeButton;
}


#pragma mark - Button/animation methods

- (IBAction)readToMeButtonTapped
{
    NSLog(@"Read to me button tapped");
    [[SoundPlayer sharedSoundPlayer] playAVAudioPlayerSound:[NSString stringWithFormat:@"page%d",self.pageNumber]];
    [self readToMe:self.page5Text pageNumber:self.pageNumber];
}

// Animates the UFO firing a laser beam at the rocket ship, and the rocket ship dodging in one of there directions
- (IBAction)ufoButtonTapped
{
    NSLog(@"UFO button tapped");
    
    // UFO button is disabled until animation is complete
    self.ufoButton.enabled = NO;
    
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"laser"];
    
    // Randomly chooses one of three points on the screen to move the rocket ship to
    CGPoint rocketNewPoint;
    int i = arc4random() % 3;
    if (i == 0) {
        rocketNewPoint = CGPointMake(100, 200);
    } else if (i == 1) {
        rocketNewPoint = CGPointMake(300, 100);
    } else {
        rocketNewPoint = CGPointMake(600, 394);
    }
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         self.laser.center = CGPointMake(-100, 600);
                         self.rocket.center = rocketNewPoint;
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"UFO fired laser");
                         NSLog(@"Rocket dodged laser");
                         
                         // Resets the laser beam underneath the UFO image
                         self.laser.center = CGPointMake(800, 125);
                         
                         [self returnRocketToNormalPosition];
                         self.ufoButton.enabled = YES;
                     }];
}

// Animates the rocket moving back to its initial position
- (void)returnRocketToNormalPosition
{
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         self.rocket.center = CGPointMake(288, 394);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Rocket returned to normal position");
                     }];
}


@end