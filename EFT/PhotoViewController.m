//
//  PhotoViewController.m
//  EFT
//
//  Created by Twinklestar on 12/16/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "PhotoViewController.h"
#import "CGlobal.h"
#import "CellPicture.h"
@interface PhotoViewController ()
@property (weak,nonatomic) EftPlace*place;
@property (assign,nonatomic) CGFloat itemcount;
@property (assign,nonatomic) CGFloat itemwidth;
@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self calcRegion];
    [self initControls];
}
-(void)calcRegion{
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        _itemcount = 4.0;
    }else{
        _itemcount = 2.0;
    }
    
    _itemwidth = (size.width-40)/_itemcount;
    
    
    
}
-(void)initControls{

    _place = [g_places objectAtIndex:g_selectedReview];
    
    NSString *identifier = @"CellPicture";
    UINib *nib = [UINib nibWithNibName:identifier bundle: nil];
    [_collectionview registerNib:nib forCellWithReuseIdentifier:identifier];
    
    [_btn_back addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_back.tag = 100;
    
    _flowlayout_collection.itemSize = CGSizeMake(_itemwidth, _itemwidth);
    _flowlayout_collection.minimumInteritemSpacing = 0;
    _flowlayout_collection.minimumLineSpacing = 0;
    _collectionview.backgroundColor = [UIColor grayColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
    
}
-(NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [_place.ep_reviewpictures count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;

    CellPicture*cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CellPicture" forIndexPath:indexPath];
    NSString*url = [_place.ep_reviewpictures objectAtIndex:row];
    
    AsyncImageLoader *manager = [AsyncImageLoader sharedLoader];
    [manager  cancelLoadingImagesForTarget:cell.img_content];
    
    cell.img_content.imageURL = [NSURL URLWithString:url];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    int row = indexPath.row;
    NSString*url = [_place.ep_reviewpictures objectAtIndex:row];
    
    _img_large.imageURL = [NSURL URLWithString:url];
    
    [self showDetail];
}
-(void)showDetail{
    _collectionview.hidden = true;
    _img_large.hidden = false;
}
-(void)hideDetail{
    _collectionview.hidden = false;
    _img_large.hidden = true;
}
-(void)ClickView:(UIView*)sender{
    int tag = sender.tag;
    if (tag == 100) {
        if (_img_large.hidden == false) {
            [self hideDetail];
        }else{
            // go back to category controller
            [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController2"}];
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(_itemwidth, _itemwidth);
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
