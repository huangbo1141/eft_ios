//
//  CellForReview.m
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CellForReview.h"

@implementation CellForReview

- (void)awakeFromNib {
    UIFont* font = [UIFont systemFontOfSize:12.0];
    [_lbl_title setFont:font];
    [_lbl_addr setFont:font];
    [_lbl_distance setFont:font];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataForGoogle:(EftGooglePlace*)place Index:(int)index Delegate:(id)delegate{
    
    _lbl_title.text = place.name;
    _lbl_addr.text = place.vicinity;
    
    @try {
        float distance = [place.distance floatValue];
        _lbl_distance.text = [NSString stringWithFormat:@"%.2f km",distance];
    } @catch (NSException *exception) {
        
    }
    
    _mIndex = index;
    _btn_review.tag = _mIndex + 100;
    _lbl_title.tag = _mIndex + 100;
    
    if ([delegate respondsToSelector:@selector(ClickViewEdit:)]) {
        [_btn_review addTarget:delegate action:@selector(ClickViewEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    _lbl_title.userInteractionEnabled = true;
    if ([delegate respondsToSelector:@selector(ClickViewLink:)]) {
        UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(ClickViewLink:)];
        [_lbl_title addGestureRecognizer:gesture];
    }
    _stackReview.hidden = true;
    
}
-(void)setData:(EftPlace*)place Index:(int)index Delegate:(id)delegate{

    _lbl_title.text = place.ep_name;
    _lbl_addr.text = place.ep_desc;
    @try {
        float distance = [place.distance floatValue];
        _lbl_distance.text = [NSString stringWithFormat:@"%.2f km",distance];
    } @catch (NSException *exception) {
        
    }
    _mIndex = index;
    
    _btn_review.tag = _mIndex + 100;
    _lbl_title.tag = _mIndex + 100;
    if ([delegate respondsToSelector:@selector(ClickViewEdit:)]) {
        [_btn_review addTarget:delegate action:@selector(ClickViewEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    _lbl_title.userInteractionEnabled = true;
    if ([delegate respondsToSelector:@selector(ClickViewLink:)]) {
        UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(ClickViewLink:)];
        [_lbl_title addGestureRecognizer:gesture];
    }
    if (place.reviewcount>0) {
        _stackReview.hidden = false;
    }else{
        _stackReview.hidden = true;
    }
    
}
@end
