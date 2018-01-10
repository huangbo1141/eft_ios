//
//  CellCategoryHeader.m
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CellCategoryHeader.h"

@implementation CellCategoryHeader

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataForHeader:(EftCategory*)category IndexPath:(NSIndexPath*)indexPath Delegate:(id)delegate{
    int section = indexPath.section;
    _lbl_content.text = category.ec_name;
    
    if ([delegate respondsToSelector:@selector(ClickTableViewCellHeader:)]) {
        [_btn_cell addTarget:delegate action:@selector(ClickTableViewCellHeader:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    if ([delegate respondsToSelector:@selector(ClickTableViewCellHeaderRight:)]) {
        [_btn_right addTarget:delegate action:@selector(ClickTableViewCellHeaderRight:) forControlEvents:UIControlEventTouchUpInside];
    }
    _btn_cell.tag = section + 100;
    _btn_right.tag = section+100;
    
    
    if (section == 0) {
        _img_left.image = [UIImage imageNamed:@"ico_eat"];
        
        _img_left.hidden = false;
        _img_left_small.hidden = true;
    }else if (section == 1){
        _img_left.image = [UIImage imageNamed:@"ico_fit"];
        
        _img_left.hidden = false;
        _img_left_small.hidden = true;
    }else if (section == 2){
        _img_left_small.image = [UIImage imageNamed:@"ico_travel"];
        
        _img_left.hidden = true;
        _img_left_small.hidden = false;
    }else{
        _img_left.image = nil;
    }
    
}

@end
