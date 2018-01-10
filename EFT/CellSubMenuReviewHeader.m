//
//  CellSubMenuReviewHeader.m
//  EFT
//
//  Created by Twinklestar on 12/16/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CellSubMenuReviewHeader.h"
#import "CGlobal.h"
@implementation CellSubMenuReviewHeader

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(EftPlace*)place{
    _lbl_name.text = place.ep_name;
    if (place.googlePlace!=nil) {
        _lbl_address.text = place.googlePlace.formatted_address;
    }else{
        _lbl_address.text = @"";
    }
    
    _constraint_name.constant = [place getHeightForSubMenuForName];
    _constraint_address.constant = [place getHeightForSubMenuForAddress];
    
    [_lbl_address setNeedsUpdateConstraints];
    [_lbl_name setNeedsUpdateConstraints];
    
    [_lbl_name layoutIfNeeded];
    [_lbl_address layoutIfNeeded];
    
}
+(CGFloat)getLabelWidth:(CGFloat) defWidth{
    if (defWidth == 0) {
        defWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return defWidth - 20;
}
@end
