//
//  CellForReview.h
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "CGlobal.h"
@interface CellForReview : UITableViewCell

@property (weak,nonatomic) IBOutlet UILabel * lbl_title;
@property (weak,nonatomic) IBOutlet UILabel * lbl_addr;
@property (weak,nonatomic) IBOutlet UILabel * lbl_distance;

@property (weak, nonatomic) IBOutlet UIButton *btn_comment;
@property (weak, nonatomic) IBOutlet UIButton *btn_photo;
@property (weak, nonatomic) IBOutlet UIButton *btn_review;
@property (weak, nonatomic) IBOutlet UIStackView *stackReview;

-(void)setData:(EftPlace*)place Index:(int)index Delegate:(id)delegate;
-(void)setDataForGoogle:(EftGooglePlace*)place Index:(int)index Delegate:(id)delegate;

@property (assign,nonatomic) int mIndex;

@end
