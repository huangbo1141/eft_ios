//
//  PostViewController.h
//  EFT
//
//  Created by Twinklestar on 12/8/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "AsyncImageView/AsyncImageView.h"
@interface PostViewGoogleController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak,nonatomic) IBOutlet UILabel *lbl_place;
@property (weak,nonatomic) IBOutlet UIImageView *img_star;
@property (weak,nonatomic) IBOutlet AsyncImageView *img_content;
@property (weak,nonatomic) IBOutlet UILabel *lbl_title;
@property (weak,nonatomic) IBOutlet UIImageView *img_camera;
@property (weak,nonatomic) IBOutlet UILabel *lbl_rating;
@property (weak,nonatomic) IBOutlet HCSStarRatingView *hcss_star;
@property (weak,nonatomic) IBOutlet UILabel *lbl_ratingright;
@property (weak,nonatomic) IBOutlet UILabel *lbl_itemcategory;
@property (weak,nonatomic) IBOutlet UIView *view_call;
@property (weak,nonatomic) IBOutlet UIView *view_direction;
@property (weak,nonatomic) IBOutlet UILabel *lbl_desc;
@property (weak,nonatomic) IBOutlet UILabel *lbl_address;
@property (weak,nonatomic) IBOutlet UILabel *lbl_time;
@property (weak,nonatomic) IBOutlet UILabel *lbl_phone;

@property (strong,nonatomic) NSLayoutConstraint *constraint_viewwidth;
@property (strong,nonatomic) NSLayoutConstraint *constraint_viewheight;
@property (strong,nonatomic) NSLayoutConstraint *constraint_viewleading;
@property (strong,nonatomic) NSLayoutConstraint *constraint_viewtop;

@property (weak,nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak,nonatomic) IBOutlet UIButton *btn_topcell;
@property (weak,nonatomic) IBOutlet UIButton *btn_star;

@property (weak,nonatomic) IBOutlet UIButton *btn_back;

@property (weak,nonatomic) IBOutlet UITableView *tableview_reviews;
@end
