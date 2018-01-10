//
//  CellSubMenuReviewHeader.h
//  EFT
//
//  Created by Twinklestar on 12/16/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EftPlace.h"
@interface CellSubMenuReviewHeader : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel *lbl_name;
@property (weak,nonatomic) IBOutlet UILabel *lbl_address;

@property (weak,nonatomic) IBOutlet NSLayoutConstraint *constraint_name;
@property (weak,nonatomic) IBOutlet NSLayoutConstraint *constraint_address;
-(void)setData:(EftPlace*)place;
+(CGFloat)getLabelWidth:(CGFloat) defWidth;
@end
