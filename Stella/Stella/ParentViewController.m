//
//  ParentViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/12/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//
//  The parent view controller manages the pages displayed in the book using a page view controller.  The starting page is either page 1
//  or the numbered page that the user left off at.  The data source methods determine which view controllers to create when the user
//  moves forward or backward between pages.  

#import "ParentViewController.h"
#import "BasePageViewController.h"
#import "Page6ViewController.h"

@implementation ParentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Sets up the page view controller that the parent view controller uses to manage pages
    UIPageViewController *pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    // Getting the most recent page number to see where the user left off
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    id pageNumber = [defaults objectForKey:@"page_number"];
    
    // Determines which page to start on based on where the user left off
    UIViewController *startingViewController;
    if ([pageNumber intValue] == 6) {
        startingViewController = [[Page6ViewController alloc] init];
    } else {
        NSString *startingPage = [pageNumber integerValue] < 1 ? @"page1" : [NSString stringWithFormat:@"page%@",pageNumber];
        startingViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:startingPage];
    }

    // Sets the view controller for the starting page
    NSArray *viewControllers = @[startingViewController];
    [pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:NULL];
    
    pageViewController.dataSource = self;
    
    // Sets parent/child relationships up for parent view controller and page view controller
    [self addChildViewController:pageViewController];
    [self.view addSubview:pageViewController.view];    
    [pageViewController didMoveToParentViewController:self];
    
    // Add the page view controller's gesture recognizers to the book view controller's view so that the gestures are started more easily
    self.view.gestureRecognizers = pageViewController.gestureRecognizers;
}


#pragma mark - Data source methods

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    BasePageViewController *bvc = (BasePageViewController *)viewController;

    // Special case b/c page 6 was implemented as a .xib outside of the storyboard
    if (bvc.pageNumber == 5) {
        return [[Page6ViewController alloc] init];
    }

    // Page 7 is the last page - do not return a new page because there is nothing after it
    if (bvc.pageNumber == 7) {
        return nil;
    }
    
    // Instantiates a view controller with the storyboard identifier "pageX", where X is the page number after the current page number
    return [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"page%d",bvc.pageNumber+1]];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    BasePageViewController *bvc = (BasePageViewController *)viewController;
    
    // First page - do not return a new page because there is nothing before it
    if (bvc.pageNumber == 1) {
        return nil;
    }
    
    // Special case b/c page 6 was implemented as a .xib outside of the storyboard
    if (bvc.pageNumber == 7) {
        return [[Page6ViewController alloc] init];
    }

    // Instantiates a view controller with the storyboard identifier "pageX", where X is the page number before the current page number    
    return [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:[NSString stringWithFormat:@"page%d",bvc.pageNumber-1]];
}


@end
