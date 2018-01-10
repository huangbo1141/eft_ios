//
//  CellForReviewEdit.h
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "GCPlaceholderTextView.h"
#include "CGlobal.h"
#import "RounderBorderGcTextView.h"
@interface CellForReviewEdit : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (weak,nonatomic) IBOutlet UILabel * lbl_title;
@property (weak,nonatomic) IBOutlet UILabel * lbl_address;
@property (weak,nonatomic) IBOutlet UILabel * lbl_distance;
//@property (weak,nonatomic) IBOutlet HCSStarRatingView * hcss_star;
//
//@property (weak,nonatomic) IBOutlet UILabel * lbl_rating;
//@property (weak,nonatomic) IBOutlet UILabel * lbl_ratingright;
@property (weak, nonatomic) IBOutlet UIButton *btn_review;
@property (weak, nonatomic) IBOutlet UIButton *btn_comment;
@property (weak, nonatomic) IBOutlet UIButton *btn_photo;
//
@property (weak, nonatomic) IBOutlet UIStackView *stackReviewTool1;


@property (weak,nonatomic) IBOutlet RounderBorderGcTextView * txt_review;
@property (weak, nonatomic) IBOutlet UIButton *btn_takephoto;

@property (weak,nonatomic) IBOutlet UIButton *btn_addreview;
@property (weak,nonatomic) IBOutlet UIButton *btn_clear;

@property (assign,nonatomic) int mIndex;
@property (weak,nonatomic) id delegate;
-(void)setData:(EftPlace*)place Index:(int)index Delegate:(id)delegate;
-(void)setDataForGoogle:(EftGooglePlace*)place Index:(int)index Delegate:(id)delegate;

@property (strong,nonatomic) NSString* picture_path;
@property (weak,nonatomic) EftPlace*place;
@property (weak,nonatomic) EftGooglePlace*googleplace;

@end
