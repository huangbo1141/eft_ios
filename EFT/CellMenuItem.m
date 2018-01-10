//
//  CellMenuItem.m
//  EFT
//
//  Created by Lion King on 12/14/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CellMenuItem.h"

@implementation CellMenuItem

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //[super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)initData{
    _img_left.image = [UIImage imageNamed:@"ico_home"];
    _lbl_content.text = @"";
}

@end
