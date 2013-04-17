//
//  BasePageViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//
//  This is a base class that each numbered (1 through 7) page of the book subclasses.  The home page and credits page do
//  not subclass this class.  This class implements the word highlighting of the 'read to me' functionality, disables the
//  'read to me' button when narration is playing, and provides the 'wiggle view' method that several pages use.  It also
//  handles storing the page number in NSUserDefaults, which allows the reader to resume where they left off when they
//  open the app again, and it stops any AVAudioPlayer sounds that are playing when the page is turned.  

#import "BasePageViewController.h"
#import "SoundPlayer.h"
#import <AudioToolbox/AudioToolbox.h>

@interface BasePageViewController ()
@property (strong, nonatomic) UITextView *pageText;

@end


@implementation BasePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.narrationPlaying = NO;
}

// Sets the current page number for the page number key in NSUserDefaults
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:self.pageNumber forKey:@"page_number"];
    [defaults synchronize];
    
    NSLog(@"On page %@",[defaults objectForKey:@"page_number"]);
}

// Stops the audio for any AVAudioPlayer sounds
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[SoundPlayer sharedSoundPlayer] stopAVAudioPlayer];
}


#pragma mark - Button methods

// Note that the segues are wired up on the storyboard - when the home button is pressed, the app segues to the home page
- (IBAction)homeButtonTapped
{
    NSLog(@"Home button tapped");

    // Sets the page number to 0 if the user goes to the home page
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:0 forKey:@"page_number"];
    [defaults synchronize];
}


#pragma mark - Read to me methods

// Highlights words on the page as they are read by the narrator
- (void)readToMe:(UITextView *)textView pageNumber:(NSUInteger)pageNumber
{
    [self turnOnNarration];
    
    self.pageText = textView;   // textView is an outlet that is passed in by the subclass calling this method
    
    // Parses the text in the textView into an array of words
    NSArray *wordList = [textView.text componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Get an array of times (floats) used for timing when words are highlighted
    NSArray *times = [self getReadToMeWordTimesForPageNumber:pageNumber];

    int indexToStartAt = 0; // an int that keeps track of the index in the textView's text where each word starts
    
    for (int i = 0; i < [wordList count]; i++) {

        NSString *word = wordList[i];
        if ([word length] > 0) {

            // The range of the word in the textView's text
            NSRange range = NSMakeRange(indexToStartAt, [word length]);
            NSString *rangeLength = [NSString stringWithFormat:@"%d",range.length];
            NSString *rangeLocation = [NSString stringWithFormat:@"%d",range.location];
            
            // A timer to highlight each word at the appropriate time (when it is read by the narrator)
            [NSTimer scheduledTimerWithTimeInterval:[times[i] doubleValue]
                                             target:self
                                           selector:@selector(highlightWord:)
                                           userInfo:@{@"rangeLocation": rangeLocation, @"rangeLength": rangeLength}
                                            repeats:NO];
            
            indexToStartAt += [word length] + 1;
        }
    }
    [self unHighlightLastWord:wordList withDelay:([[times lastObject] doubleValue] + 0.5)];
}

// Parses the appropriate .txt file based on page number to return an array of times (floats) used for timing when words are highlighted
- (NSArray *)getReadToMeWordTimesForPageNumber:(NSUInteger)pageNumber
{
    // Parses the file into individual lines
    NSString *filepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"page%d_labels",pageNumber] ofType:@"txt"];
    NSString *fileText = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:NULL];
    NSArray *lines = [fileText componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    // Gets the first number on each line, which is the start time of each word
    NSMutableArray *times = [[NSMutableArray alloc] init];
    for (NSString *line in lines) {
        NSArray *words = [line componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [times addObject:words[0]];
    }
    return times;
}

// Highlights a range of characters in the textView - the range is passed in through the userInfo dictionary of a timer
- (void)highlightWord:(NSTimer *)timer
{
    NSRange range = NSMakeRange([timer.userInfo[@"rangeLocation"] intValue], [timer.userInfo[@"rangeLength"] intValue]);
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:self.pageText.text];
    [mutableText addAttributes:@{NSBackgroundColorAttributeName: [UIColor cyanColor]} range:range];
    [self.pageText setAttributedText:mutableText];
}

// Unhighlights the last word in the textView after a specified time delay
- (void)unHighlightLastWord:(NSArray *)wordList withDelay:(NSTimeInterval)delay
{
    NSString *lastWord = [wordList lastObject];
    
    [NSTimer scheduledTimerWithTimeInterval:delay
                                     target:self
                                   selector:@selector(unHighlightEndOfText:)
                                   userInfo:@{@"wordLength": [NSNumber numberWithInt:[lastWord length]]}
                                    repeats:NO];
}

// Unhighlights the last word in the textView - length of the last word in the textView is passed in through the userInfo of a timer
- (void)unHighlightEndOfText:(NSTimer *)timer
{
    NSDictionary *userInfo = [timer userInfo];
    int wordLength = [userInfo[@"wordLength"] intValue];
    
    // finds the range by backtracking from the end of the textViews' text
    NSRange range = NSMakeRange([self.pageText.text length] - wordLength, wordLength);
    
    NSMutableAttributedString *mutableText = [[NSMutableAttributedString alloc] initWithString:self.pageText.text];
    [mutableText addAttributes:@{NSBackgroundColorAttributeName: [UIColor clearColor]} range:range];
    [self.pageText setAttributedText:mutableText];
    
    [self turnOffNarration];
}

// Turns on the boolean narration varaible and disables the read to me button
- (void)turnOnNarration
{
    self.narrationPlaying = YES;
    self.readToMeButtonOutlet.enabled = NO;
}

// Turns off the boolean narration varaible and enables the read to me button
- (void)turnOffNarration
{
    self.narrationPlaying = NO;
    self.readToMeButtonOutlet.enabled = YES;
}


#pragma mark - Animation methods

// Converts a number from degrees to radians (formula found at stackoverflow.com/questions/12656961)
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)

// "wiggles" a view by animating it moving up 45 degrees, down 90 degrees, then back up 45 degrees
- (void)wiggleView:(UIView *)view
{
    [UIView animateWithDuration:0.2
                            delay:0.0
                          options:UIViewAnimationOptionCurveEaseOut
                       animations:^(void) {
                           view.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(45));
                       }completion:^(BOOL finished) {
                           NSLog(@"View rotated up");
                           
                           [UIButton animateWithDuration:0.2
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveEaseOut
                                              animations:^(void) {
                                                  view.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-45));
                                              }completion:^(BOOL finished) {
                                                  NSLog(@"View rotated down");
                                                  
                                                  [self restoreViewPosition:view];
                                              }];
                           
                       }];
}

// Returns a view to its normal position by rotating back up 45 degrees
- (void)restoreViewPosition:(UIView *)view
{
    [UIView animateWithDuration:0.2
                            delay:0.0
                          options:UIViewAnimationOptionCurveEaseOut
                       animations:^(void) {
                           view.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
                       }completion:^(BOOL finished) {
                           NSLog(@"View returned to normal position");
                       }];
}


@end
