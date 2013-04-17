//
//  Page4ViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import "Page4ViewController.h"
#import "SoundPlayer.h"

@interface Page4ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *stellaButton;
@property (weak, nonatomic) IBOutlet UIImageView *rocketImageView;
@property (weak, nonatomic) IBOutlet UIImageView *flamesImageView;
@property (weak, nonatomic) IBOutlet UITextView *page4Text;
@property (weak, nonatomic) IBOutlet UIButton *readToMeButton;

@end

@implementation Page4ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.pageNumber = 4;
    self.readToMeButtonOutlet = self.readToMeButton;
    
    // Flames image is hidden initially as the rocket is not 'launching' yet
    self.flamesImageView.hidden = YES;
}


#pragma mark - Button methods

- (IBAction)readToMeButtonTapped
{
    NSLog(@"Read to me button tapped");
    [[SoundPlayer sharedSoundPlayer] playAVAudioPlayerSound:[NSString stringWithFormat:@"page%d",self.pageNumber]];
    [self readToMe:self.page4Text pageNumber:self.pageNumber];
}

- (IBAction)stellaButtonTapped
{
    NSLog(@"Stella button tapped");
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"barks"];    
    [self wiggleView:self.stellaButton];
}

- (IBAction)dinosaurHeadButtonTapped
{
    NSLog(@"Dinosaur head button tapped");
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"dinosaur_growl"];
}


#pragma mark - Gesture/animation methods

// Gesture recognizer that allows the stellaButton to be dragged across the screen
- (IBAction)panGestureDetected:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *piece = [panGestureRecognizer view];
    
    if ([panGestureRecognizer state] == UIGestureRecognizerStateBegan || [panGestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        // The change in the x and y values as the piece is dragged
        CGPoint translation = [panGestureRecognizer translationInView:[piece superview]];
        
        // Moves the piece according to the x and y values detected in translation
        [piece setCenter:CGPointMake([piece center].x + translation.x, [piece center].y + translation.y)];
        
        // Resets the translation to zero - we want to measure incremental changes, not cumulative
        [panGestureRecognizer setTranslation:CGPointZero inView:[piece superview]];
    }
    
    // Detects whether the stellaButton has been dragged 'into' the rocket ship
    if ((piece.center.x > 816 && piece.center.x < 989) && (piece.center.y > 220 && piece.center.y < 411)) {
        NSLog(@"Stella in rocket ship");
        [self putStellaInRocketShip];
    }
}

// Handles the animation of stella getting into the rocket ship and blasting off into space
- (void)putStellaInRocketShip
{
    // Hides and disables the stellaButton once she is 'in' the rocket ship
    self.stellaButton.hidden = YES;
    self.stellaButton.enabled = NO;
    
    // Updates rocket image to one with stella inside it
    NSString *rocketWithStellaFilePath = [[NSBundle mainBundle] pathForResource:@"rocket_w_stella" ofType:@"png"];
    UIImage *rocketWithStellaImage = [UIImage imageWithContentsOfFile:rocketWithStellaFilePath];
    [self.rocketImageView setImage:rocketWithStellaImage];
    
    [[SoundPlayer sharedSoundPlayer] playSound:@"launch" givenNarrating:self.narrationPlaying];
    
    [UIView animateWithDuration:2.0
                          delay:1.5
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^(void) {
                         
                         self.flamesImageView.hidden = NO;
                         
                         // flames image has a different center than the rocket to create the illusion that they are growing longer
                         self.flamesImageView.center = CGPointMake(867, -400);
                         self.rocketImageView.center = CGPointMake(867, -725);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Rocket ship launched");
                     }];
}


@end