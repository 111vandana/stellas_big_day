//
//  CreditsViewController.m
//  Stella
//
//  Created by Rob Timpone on 4/15/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import "CreditsViewController.h"
#import "CreditsCell.h"
#import <QuartzCore/QuartzCore.h>

@interface CreditsViewController ()

// Outlets for the three table views shown on the credits page
@property (weak, nonatomic) IBOutlet UITableView *creditsTable;
@property (weak, nonatomic) IBOutlet UITableView *photoCreditsTable;
@property (weak, nonatomic) IBOutlet UITableView *soundCreditsTable;

// Arrays that store data for the three table views
@property (strong, nonatomic) NSMutableArray *creditsData;
@property (strong, nonatomic) NSMutableArray *photoCreditsData;
@property (strong, nonatomic) NSMutableArray *soundCreditsData;

@end


@implementation CreditsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.creditsTable.layer.borderWidth = 2.0;
    self.photoCreditsTable.layer.borderWidth = 2.0;
    self.soundCreditsTable.layer.borderWidth = 2.0;
    
    [self setupDataArrays];
}

// Reads the file credits.txt and parses data into three arrays - credits, photo credits, and sound credits
- (void)setupDataArrays
{
    NSString *filepath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"credits"] ofType:@"txt"];
    NSString *fileText = [NSString stringWithContentsOfFile:filepath encoding:NSUTF8StringEncoding error:NULL];
    NSArray *sections = [fileText componentsSeparatedByString:@"-------------------------------"];
    
    self.creditsData = [[sections[0] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    self.photoCreditsData = [[sections[1] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    self.soundCreditsData = [[sections[2] componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]] mutableCopy];
    
    [self.photoCreditsData removeObjectAtIndex:0];
    [self.soundCreditsData removeObjectAtIndex:0];
    
    [self.creditsData removeLastObject];
    [self.photoCreditsData removeLastObject];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.creditsTable) {
        return [self.creditsData count];
    }
    else if (tableView == self.photoCreditsTable) {
        return [self.photoCreditsData count];
    }
    else if (tableView == self.soundCreditsTable) {
        return [self.soundCreditsData count];
    }
    return 0;
}

// Reads data from the appropriate array to setup cells for each table view; uses custom cell CreditsCell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreditsCell *cell;
    
    if (tableView == self.creditsTable) {

        static NSString *CellIdentifier = @"creditsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        NSString *line = self.creditsData[indexPath.row];
        NSArray *labels = [line componentsSeparatedByString:@"|"];
        
        cell.creditsCellLeftLabel.text = labels[0];
        cell.creditsCellRightLabel.text = labels[1];
    }
    else if (tableView == self.photoCreditsTable) {

        static NSString *CellIdentifier = @"photoCreditsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        NSString *line = self.photoCreditsData[indexPath.row];
        NSArray *labels = [line componentsSeparatedByString:@"|"];
        
        cell.photoCreditsCellLeftLabel.text = labels[0];
        cell.photoCreditsCellRightLabel.text = labels[1];
    }
    else if (tableView == self.soundCreditsTable) {
        
        static NSString *CellIdentifier = @"soundCreditsCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        NSString *line = self.soundCreditsData[indexPath.row];
        NSArray *labels = [line componentsSeparatedByString:@"|"];
        
        cell.soundCreditsCellLeftLabel.text = labels[0];
        cell.soundCreditsCellRightLabel.text = labels[1];
    }
    
    return cell;
}


#pragma mark - Button methods

- (IBAction)stellaButtonTapped:(UIButton *)sender
{
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"barks"];
    [self wiggleView:sender];
}

- (IBAction)rocketButtonTapped:(UIButton *)sender
{
    [[SoundPlayer sharedSoundPlayer] playSystemSound:@"landing"];    
    [self wiggleView:sender];
}


@end
