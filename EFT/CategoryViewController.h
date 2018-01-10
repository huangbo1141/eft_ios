//
//  CategoryViewController.h
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import "ViewSetting.h"
@interface CategoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate , UINavigationControllerDelegate>
@property (weak,nonatomic) IBOutlet UILabel *lbl_category;
@property (weak,nonatomic) IBOutlet UITableView *tableview_category;
@property (weak,nonatomic) IBOutlet UITableView *tableview_searchres;
@property (weak,nonatomic) IBOutlet UIImageView *img_star;

@property (weak,nonatomic) IBOutlet UIView * view_content;
@property (weak,nonatomic) IBOutlet UIButton *btn_back;

@property (weak,nonatomic) UIImageView *img_currentphoto;
@property (weak,nonatomic) GCPlaceholderTextView *txt_currentReview;

@property (strong,nonatomic) ViewSetting*view_setting;
@property (weak,nonatomic) NSLayoutConstraint *constraint_setting;

@property (weak,nonatomic) IBOutlet UIImageView * img_setting;
@end
