//
//  HomeViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//
//  The view controller for the home page, which is the root view controller for this app.  The only custom
//  functionality is to check NSUserDefaults to see if the user left off on a specific numbered page.  If
//  the user left the app from a numbered page, that page appears instead of the home screen when the app
//  is launched.

#import "HomeViewController.h"

@implementation HomeViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // Gets the number of the page where the user left off
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int pageNumber = [[defaults objectForKey:@"page_number"] integerValue];
    
    // The home page only appears if the user did not leave off on a numbered page
    if (pageNumber > 0) {
        [self performSegueWithIdentifier:@"HomeToPageViewController" sender:self];
    }
    else {
        [defaults setInteger:0 forKey:@"page_number"];
        [defaults synchronize];
        
        NSLog(@"On home page");
    }
}

@end
