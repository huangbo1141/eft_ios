//
//  ViewPostReview.h
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GCPlaceholderTextView.h"
#import "EftCategory.h"
#import "EftGooglePlace.h"
@interface ViewPostReview : UIScrollView<UIImagePickerControllerDelegate , UINavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak,nonatomic) IBOutlet UIView *view_usemyloc;
@property (weak,nonatomic) IBOutlet UIView *view_searchloc;
@property (weak,nonatomic) IBOutlet UITextField *txt_business;
@property (weak,nonatomic) IBOutlet UITextField *txt_category;
@property (weak,nonatomic) IBOutlet UITextField *txt_address;
@property (weak,nonatomic) IBOutlet GCPlaceholderTextView *txt_review;
@property (weak,nonatomic) IBOutlet UIImageView *img_photo;

@property (weak,nonatomic) IBOutlet UIButton *btn_category;
@property (weak,nonatomic) IBOutlet UIButton *btn_post;
@property (weak,nonatomic) IBOutlet UIButton *btn_clear;

@property (nonatomic,strong) IBOutlet UITableView *autocompleteTable;

@property (nonatomic,strong) EftCategory *category_selected;
@property (nonatomic,strong) EftGooglePlace *googleplace;
-(void)setCategory:(EftCategory*)category;
-(void)setPlace:(EftGooglePlace*)place;

@property (nonatomic,strong) NSString*reference;

@property (weak,nonatomic) id mydelegate;
-(void)setMyDelegate:(id) delegate;

-(void)initControls;
-(void)initData;

@property (strong,nonatomic) UIImage *picture;

@end
