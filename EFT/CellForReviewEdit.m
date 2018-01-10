//
//  CellForReviewEdit.m
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CellForReviewEdit.h"
#import "NSString+Common.h"
@implementation CellForReviewEdit

- (void)awakeFromNib {
    
    _txt_review.text = @"";
    UIFont*font = [UIFont systemFontOfSize:12.0f];
    [_lbl_title setFont: font];
    [_lbl_address setFont: font];
    [_lbl_distance setFont: font];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setDataForGoogle:(EftGooglePlace*)place Index:(int)index Delegate:(id)delegate{
    _lbl_title.text = place.name;
    _lbl_address.text = place.vicinity;
    @try {
        float distance = [place.distance floatValue];
        _lbl_distance.text = [NSString stringWithFormat:@"%.2f km",distance];
    } @catch (NSException *exception) {
        
    }
    _txt_review.placeholder = @"Enter Review";
    
    _mIndex = index;
    _picture_path = nil;
    
    _btn_review.tag = _mIndex + 100;
    _btn_takephoto.tag = _mIndex + 100;
    _lbl_title.tag = _mIndex + 100;
    
    if ([delegate respondsToSelector:@selector(ClickViewEdit:)]) {
        [_btn_review addTarget:delegate action:@selector(ClickViewEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([delegate respondsToSelector:@selector(ClickAttachPhoto:)]) {
        [_btn_takephoto addTarget:delegate action:@selector(ClickAttachPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    _lbl_title.userInteractionEnabled = true;
    if ([delegate respondsToSelector:@selector(ClickViewLink:)]) {
        UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(ClickViewLink:)];
        [_lbl_title addGestureRecognizer:gesture];
    }
    _delegate = delegate;
    [_btn_addreview addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_addreview.tag = ClickDialogButton_ADDREVIEW;
    
    [_btn_clear addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_clear.tag = ClickDialogButton_CLEARFORM;
    
    if (place.tmpImage!=nil) {
//        _img_attachphoto.image = place.tmpImage;
        _imgPhoto.image = place.tmpImage;
        _btn_takephoto.hidden = true;
        _imgPhoto.hidden = false;
    }else{
        _btn_takephoto.hidden = false;
        _imgPhoto.hidden = true;
    }
    if (place.tmpReview!=nil) {
        _txt_review.text = place.tmpReview;
    }else{
        _txt_review.text = @"";
    }
    
    _stackReviewTool1.hidden = true;
    
    _googleplace = place;
    _place = nil;
}

-(void)setData:(EftPlace*)place Index:(int)index Delegate:(id)delegate{
    _lbl_title.text = place.ep_name;
    _lbl_address.text = place.ep_desc;
    @try {
        float distance = [place.distance floatValue];
        _lbl_distance.text = [NSString stringWithFormat:@"%.2f km",distance];
    } @catch (NSException *exception) {
        
    }
    
    _txt_review.placeholder = @"Enter Review";
    
    _mIndex = index;
    _picture_path = nil;
    
    _btn_review.tag = _mIndex + 100;
    _btn_takephoto.tag = _mIndex + 100;
    _lbl_title.tag = _mIndex + 100;

    
    
    if ([delegate respondsToSelector:@selector(ClickViewEdit:)]) {
        [_btn_review addTarget:delegate action:@selector(ClickViewEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    if ([delegate respondsToSelector:@selector(ClickAttachPhoto:)]) {
        [_btn_takephoto addTarget:delegate action:@selector(ClickAttachPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    _lbl_title.userInteractionEnabled = true;
    if ([delegate respondsToSelector:@selector(ClickViewLink:)]) {
        UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:delegate action:@selector(ClickViewLink:)];
        [_lbl_title addGestureRecognizer:gesture];
    }
    
    _delegate = delegate;
    [_btn_addreview addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_addreview.tag = ClickDialogButton_ADDREVIEW;
    
    [_btn_clear addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_clear.tag = ClickDialogButton_CLEARFORM;
    
    if (place.tmpImage!=nil) {
        _imgPhoto.image = place.tmpImage;
        _imgPhoto.hidden = false;
        _btn_takephoto.hidden = true;
    }else{
        _imgPhoto.hidden = true;
        _btn_takephoto.hidden = false;
    }
    if (place.tmpReview!=nil) {
        _txt_review.text = place.tmpReview;
    }else{
        _txt_review.text = @"";
    }
    
    if(place.reviewcount > 0){
        _stackReviewTool1.hidden = false;
    }else{
        _stackReviewTool1.hidden = true;
    }
    
    _place = place;
    _googleplace = nil;
    
    
}
-(BOOL) checkValidate{
    if ([_txt_review.text isBlank]) {
        return false;
    }
    return true;
}
-(void)ClickView:(UIView*)sender{
    int tag = sender.tag;
    if (tag == ClickDialogButton_ADDREVIEW) {
        if ([self checkValidate]) {
            g_curReview = [[EftReview alloc] init];
            [g_curReview initData];
            
            g_curReview.er_text = _txt_review.text;
            g_curReview.er_picture = _picture_path;
            
            if ([_delegate respondsToSelector:@selector(ClickDialogButton:)]) {
//                [_btn_addreview addTarget:_delegate action:@selector(ClickDialogButton:) forControlEvents:UIControlEventTouchUpInside];
                [_delegate performSelector:@selector(ClickDialogButton:) withObject:sender];
            }
        }else{
            if (_delegate) {
                [CGlobal AlertMessage:@"Enter Review" Title:nil];
            }
        }
        
    }else{
        _txt_review.text = @"";
        if (_googleplace!=nil) {
            _googleplace.tmpImage = nil;
            _googleplace.tmpReview = @"";
        }else if (_place != nil){
            _place.tmpReview = @"";
            _place.tmpImage = nil;
        }
        
    }
    
}
@end
