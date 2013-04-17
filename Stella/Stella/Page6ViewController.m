//
//  Page6ViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

//  NOTE:  The view for page 6's view controller was implemented as a .xib file per the assignment requirements.

#import "Page6ViewController.h"
#import "SoundPlayer.h"

@interface Page6ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *rocket;
@property (weak, nonatomic) IBOutlet UIButton *stellaButton;
@property (weak, nonatomic) IBOutlet UITextView *page6Text;
@property (weak, nonatomic) IBOutlet UIButton *readToMeButton;

@end


@implementation Page6ViewController

// Overrides init to use the Page6View .xib file as the ViewController's view
- (id)init
{
    self = [super init];
    if (self) {
        self = [super initWithNibName:@"Page6View" bundle:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.pageNumber = 6;
    self.readToMeButtonOutlet = self.readToMeButton;
    
    // Moves the rocket image and stella button offscreen before the view appears
    self.rocket.center = CGPointMake(659.5, -200);
    self.stellaButton.center = CGPointMake(1400, 407.5);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // stellaButton is hidden until she is about to run onscreen
    self.stellaButton.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Starts the stellaLandRocketShip animation automatically 1 second after the view appears
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(stellaLandRocketShip)
                                   userInfo:nil
                                    repeats:NO];
}


#pragma mark - Button methods

- (IBAction)readToMeButtonTapped
{
    NSLog(@"Read to me button tapped");
    [[SoundPlayer sharedSoundPlayer] playAVAudioPlayerSound:[NSString stringWithFormat:@"page%d",self.pageNumber]];
    [self readToMe:self.page6Text pageNumber:self.pageNumber];
}

- (IBAction)homeButtonTapped
{
    [super homeButtonTapped];
    
    // Had to create this segue manually because this view controller does not use the Storyboard - couldn't wire it up like the other individual pages
    UIViewController *home = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"home"];
    [self presentViewController:home animated:YES completion:NULL];
}

- (IBAction)stellaButtonTapped
{
    NSLog(@"Stella button tapped");
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"barks"];    
    [self wiggleView:self.stellaButton];
}


#pragma mark - Animation methods

// Animates stella landing the rocket ship in the backyard and plays a sound effect
- (void)stellaLandRocketShip
{
    // This method determines whether to play a system sound or an AVAudioPlayer sound depending on whether narration is being played
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"landing"];
    
    [UIView animateWithDuration:4.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         self.rocket.center = CGPointMake(659.5, 307.5);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Rocket landed");
                         [self stellaWalkInTheFrontDoor];
                     }];
}

// Animates stella running in from the right side of the screen and going to her dog bed, plays two sound effects
- (void)stellaWalkInTheFrontDoor
{
    [[SoundPlayer sharedSoundPlayer] playSound:@"door" givenNarrating:self.narrationPlaying withDelay:1.0];
    [[SoundPlayer sharedSoundPlayer] playSound:@"running" givenNarrating:self.narrationPlaying withDelay:1.5];
    
    [UIView animateWithDuration:2.0
                          delay:1.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^(void) {
                         self.stellaButton.hidden = NO;
                         self.stellaButton.center = CGPointMake(161, 407.5);
                     }
                     completion:^(BOOL finished) {
                         NSLog(@"Stella is back in her bed");
                     }];
}


@end