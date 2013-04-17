//
//  CreditsCell.h
//  Stella
//
//  Created by Rob Timpone on 4/15/13.
//  Copyright (c) 2013 Rob Timpone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreditsCell : UITableViewCell

// These are the labels used for the cells of the three table views on the credits page:

@property (weak, nonatomic) IBOutlet UILabel *creditsCellLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *creditsCellRightLabel;

@property (weak, nonatomic) IBOutlet UILabel *photoCreditsCellLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoCreditsCellRightLabel;

@property (weak, nonatomic) IBOutlet UILabel *soundCreditsCellLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *soundCreditsCellRightLabel;

@end