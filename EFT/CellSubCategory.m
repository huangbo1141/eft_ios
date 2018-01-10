//
//  CellSubCategory.m
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CellSubCategory.h"

@implementation CellSubCategory

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(EftCategory*)category IndexPath:(NSIndexPath*)indexPath Delegate:(id)delegate{
    int section = indexPath.section;
    int row = indexPath.row;
    _lbl_content.text = category.ec_name;
    

//    _btn_cell.tag = section;
//    _btn_right.tag = section;
    
    
}
-(void)setDataForReview:(EftReview*)review{
    _lbl_content.text = review.er_text;
}
@end
