//
//  BasePageViewController.h
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SoundPlayer.h"

@interface BasePageViewController : UIViewController

@property (nonatomic) NSUInteger pageNumber;
@property (nonatomic) BOOL narrationPlaying;            // YES if narration is playing, NO if not
@property (nonatomic) UIButton *readToMeButtonOutlet;   // this outlet is meant to be assigned by subclasses in their viewDidLoad method

- (void)wiggleView:(UIView *)view;
- (void)readToMe:(UITextView *)textView pageNumber:(NSUInteger)pageNumber;
- (void)turnOnNarration;
- (void)turnOffNarration;
- (IBAction)homeButtonTapped;

@end
