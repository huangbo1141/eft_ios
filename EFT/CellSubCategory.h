//
//  CellSubCategory.h
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGlobal.h"
@interface CellSubCategory : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel * lbl_content;

@property (weak,nonatomic) IBOutlet UIButton * btn_cell;

-(void)setData:(EftCategory*)category IndexPath:(NSIndexPath*)indexPath Delegate:(id)delegate;
-(void)setDataForReview:(EftReview*)review;
@end
