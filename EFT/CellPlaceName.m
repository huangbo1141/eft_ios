//
//  CellPlaceName.m
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CellPlaceName.h"

@implementation CellPlaceName

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setData:(EftRegion*)region{
    _lbl_content.text = [region getAddress];
    _img_right.image = [UIImage imageNamed:@"ab_btn_close.png"];
    
}
+(CGFloat)getLabelWidth:(CGFloat) defWidth{
    if (defWidth == 0) {
        defWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return defWidth - 76;
}
-(void)setDataForMenu:(EftRegion*)region{
    _lbl_content.text = [region getAddress];
    _img_right.image = [UIImage imageNamed:@"ico_star_yellow.png"];
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    [_lbl_content setFont:font];
}
-(void)setDataReview:(EftReview*)review IndexPath:(NSIndexPath*)indexPath{
    _indexPath = indexPath;
    _lbl_content.text = review.er_text;
    _img_right.image = [UIImage imageNamed:@"ab_btn_close.png"];
    
    [_btn_close addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_close.tag = 100;
    
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:14.0];
    [_lbl_content setFont:font];
    
    _constraint_label.constant = [review getHeightForSubMenuForReviewText];
    [_lbl_content setNeedsUpdateConstraints];
    
}
-(void)setDelegate:(id)delegate{
    if (_delegate != delegate) {
        _delegate = delegate;
    }
}
-(void) ClickView:(UIView*)sender{
    int tag = sender.tag;
    if (tag == 100) {
        if ([_delegate respondsToSelector:@selector(ClickReviewDelete:)]) {
            [_delegate performSelector:@selector(ClickReviewDelete:) withObject:_indexPath];
        }
    }
}
@end
