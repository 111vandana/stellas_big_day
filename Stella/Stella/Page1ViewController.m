//
//  Page1ViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import "Page1ViewController.h"
#import "SoundPlayer.h"

@interface Page1ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *stellaButton;
@property (weak, nonatomic) IBOutlet UITextView *page1Text;
@property (weak, nonatomic) IBOutlet UIButton *readToMeButton;

@end


@implementation Page1ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageNumber = 1;
    
    // Assigns this class's button outlet to the superclass's button outlet (this allows for cleaner code in the base class)
    self.readToMeButtonOutlet = self.readToMeButton;
}


#pragma mark - Button methods

// Plays the appropriate narration sound file and passes information to the base class's 'read to me' method
- (IBAction)readToMeButtonTapped
{
    NSLog(@"Read to me button tapped");
    [[SoundPlayer sharedSoundPlayer] playAVAudioPlayerSound:[NSString stringWithFormat:@"page%d",self.pageNumber]];
    [self readToMe:self.page1Text pageNumber:self.pageNumber];
}

// Animates the stella button moving off the screen and plays two sound effects
- (IBAction)stellaButtonTapped
{
    NSLog(@"Stella button tapped");
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"running"];
    [UIView animateWithDuration:1.0 delay:0.0
                          options:UIViewAnimationOptionCurveEaseInOut
                       animations:^(void) {
                           self.stellaButton.center = CGPointMake(1150, 450);
                       }
                       completion:^(BOOL completed) {
                           NSLog(@"Stella moved");
                           self.stellaButton.hidden = YES;
                           [[SoundPlayer sharedSoundPlayer] playSystemSound:@"door"];
                       }];
}


@end
