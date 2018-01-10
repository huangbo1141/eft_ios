//
//  CellCategoryHeader.h
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CGlobal.h"
@interface CellCategoryHeader : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel * lbl_content;
@property (weak,nonatomic) IBOutlet UIImageView * img_left;
@property (weak,nonatomic) IBOutlet UIImageView * img_left_small;

@property (weak,nonatomic) IBOutlet UIImageView * img_right;

@property (weak,nonatomic) IBOutlet UIButton * btn_right;
@property (weak,nonatomic) IBOutlet UIButton * btn_cell;

-(void)setDataForHeader:(EftCategory*)category IndexPath:(NSIndexPath*)indexPath Delegate:(id)delegate;
@end
