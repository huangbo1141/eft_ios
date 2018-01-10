//
//  CategoryViewController.m
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "CategoryViewController.h"
#import "CellCategoryHeader.h"
#import "CellSubCategory.h"
#import "CellForReviewEdit.h"
#import "CellForReview.h"
#import "CGlobal.h"
#import "MHCustomTabBarController.h"
//#import "SWRevealViewController.h"
#import "NetworkParser.h"
#import "NSString+Common.h"
#import "AppDelegate.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


@interface CategoryViewController ()
@property (nonatomic,assign) int m_reviewIndex;
@property (nonatomic,strong) NSMutableDictionary *dic_imgcellright;
@property (nonatomic,strong) NSMutableDictionary *dic_imgcellright2;
@property (nonatomic,assign) BOOL hidden_setting;
@property (nonatomic,assign) int mode;

@end
int temp_sel = 0;
@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = true;
    
    [self initData];
    [self initControls];
    [self showDetail:1];
}
-(void) initData{
    g_selIndexPath = nil;
    _m_reviewIndex = -1;
    
    if (g_curRegion!=nil) {
        _lbl_category.text = [g_curRegion getAddress];
        
    }
    _dic_imgcellright = [[NSMutableDictionary alloc] init];
    _dic_imgcellright2 = [[NSMutableDictionary alloc] init];
}
-(void) LayoutConfigure{
    //control layoutconfigure....
    
    CGSize size = _view_setting.frame.size;
    NSLayoutConstraint* leadingConst = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0];
    NSLayoutConstraint* trailingConst = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0];
    
    NSLayoutConstraint* widthConst = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint* heightConst = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeHeight multiplier:0.5 constant:0];
    
    _constraint_setting = [NSLayoutConstraint constraintWithItem:_view_setting attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_view_content attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    _view_setting.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:[[NSArray alloc] initWithObjects:leadingConst,trailingConst,widthConst,heightConst,_constraint_setting, nil]];
    
}
-(void) initControls{
    _view_setting = [[[NSBundle mainBundle] loadNibNamed:@"ViewSetting" owner:self options:nil] objectAtIndex:0];
    [_view_setting initControl];
    
    [_view_setting.btn_ok addTarget:self action:@selector(ClickDialogButton:) forControlEvents:UIControlEventTouchUpInside];
    _view_setting.btn_ok.tag = ClickDialogButton_SETTINGOK;
    
    [_view_content addSubview:_view_setting];
    [self LayoutConfigure];
    
    
    _hidden_setting  = true;
    _view_setting.hidden = _hidden_setting;
    
    
    [_tableview_category registerNib:[UINib nibWithNibName:@"CellCategoryHeader" bundle:nil] forCellReuseIdentifier:@"CellCategoryHeader"];
    [_tableview_category registerNib:[UINib nibWithNibName:@"CellSubCategory" bundle:nil] forCellReuseIdentifier:@"CellSubCategory"];
    
    [_tableview_searchres registerNib:[UINib nibWithNibName:@"CellCategoryHeader" bundle:nil] forCellReuseIdentifier:@"CellCategoryHeader"];
    [_tableview_searchres registerNib:[UINib nibWithNibName:@"CellForReviewEdit" bundle:nil] forCellReuseIdentifier:@"CellForReviewEdit"];
    [_tableview_searchres registerNib:[UINib nibWithNibName:@"CellForReview" bundle:nil] forCellReuseIdentifier:@"CellForReview"];
    
    for (int i=0; i< [g_category count]; i++) {
        EftCategory *cat = [g_category objectAtIndex: i];
        cat.isopened = false;
    }
    
    _tableview_category.delegate = self;
    _tableview_category.dataSource = self;
    
    _tableview_searchres.delegate = self;
    _tableview_searchres.dataSource = self;
    
    _tableview_searchres.hidden = true;
    _tableview_category.hidden = false;
    
    _tableview_searchres.alpha = 1;
    
    if (g_curRegion.isSavedToDb) {
        _img_star.image = [UIImage imageNamed:@"ico_star_yellow"];
    }else{
        _img_star.userInteractionEnabled = true;
        UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickGesture:)];
        [_img_star addGestureRecognizer:gesture];
    }
    
    _img_star.tag = 100;
    
    [_btn_back addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_back.tag = 100;
    _btn_back.hidden = true;
    
    _img_setting.userInteractionEnabled = true;
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickGesture:)];
    [_img_setting addGestureRecognizer:gesture];
    _img_setting.tag = 101;
    
    _tableview_category.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableview_searchres.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}
-(void)ClickView:(UIView*)sender{
    int tag = sender.tag;
    if (tag == 100) {
        if (_tableview_searchres.hidden == true) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController1"}];
        }else{
            [self showDetail:1];
        }
    }
}
-(void)ClickGesture:(UITapGestureRecognizer*)sender{
    int tag = sender.view.tag;
    if (tag == 100) {
        // star image click
        if (!g_curRegion.isSavedToDb) {
            AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
            [delegate saveCurrentRegion];
            
            _img_star.image = [UIImage imageNamed:@"ico_star_yellow"];
        }
    }else if(tag == 101){
        
        _hidden_setting = !_hidden_setting;
        [self setSetting:_hidden_setting withAnimation:true];
        
        
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)ClickTableViewCellHeader:(UIView*)sender{
    //action to go
    int tag = sender.tag-100;
    if (tag >0 && tag <3) {
        EftCategory*category =  [g_category objectAtIndex:tag];
        // clicked tag section;
        
    }
}
-(void)ClickTableViewCellHeaderRight:(UIView*)sender{
    if (_mode== 1) {
        int tag = sender.tag - 100;
        if (tag >=0 && tag <3) {
            EftCategory*category =  [g_category objectAtIndex:tag];
            category.isopened = !category.isopened;
            
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:tag];
            [_tableview_category reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
            
            [UIView beginAnimations:@"rotate" context:nil];
            [UIView setAnimationDuration:0.2];
            NSString*mid = [NSString stringWithFormat:@"%d_0",tag];
            UIView*img = _dic_imgcellright[mid];
            if (category.isopened) {
                img.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(-90));
            }else{
                img.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
            }
            
            [UIView commitAnimations];
        }
    }else{
        int tag = sender.tag;
        [UIView beginAnimations:@"rotate" context:nil];
        [UIView setAnimationDuration:0.2];
        NSString*mid = [NSString stringWithFormat:@"%d_0",tag];
        UIView*img = _dic_imgcellright2[mid];
        img.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0));
        
        [UIView commitAnimations];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.18 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showDetail:1];
            });
        });
    }
    
    
    
}
-(void)ClickDialogButton:(UIView*)sender{
    int tag = sender.tag;
    if (tag == ClickDialogButton_ADDREVIEW) {
        //
        if (_m_reviewIndex>=0) {
            id arplace = [g_places objectAtIndex:_m_reviewIndex];
            NSString*reference;
            UIImage*picture = nil;
            if ([arplace isKindOfClass:[EftPlace class]]) {
                EftPlace*place = (EftPlace*)arplace;
                reference = place.reference;
                picture = place.tmpImage;
            }else if ([arplace isKindOfClass:[EftGooglePlace class]]){
                EftGooglePlace*place = (EftGooglePlace*)arplace;
                reference = place.reference;
                
                picture = place.tmpImage;
            }
            UIButton*btn = (UIButton*)sender;
            btn.enabled = false;
            if (picture!=nil) {
                NSString*filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                filename = [filename stringByAppendingString:@".jpg"];
                NSString* uploadpath = [g_baseUrl stringByAppendingString:@"uploads/"];
                uploadpath = [uploadpath stringByAppendingString:filename];
                
                
                [CGlobal showIndicator:self];
                NetworkParser *manager = [NetworkParser sharedManager];
                [manager uploadImage:picture ImagePath:uploadpath FileName:filename withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                    if (error== nil) {
                        g_curReview.er_picture = uploadpath;
                        [self postReview:reference Sender:btn];
                    }else{
                        [CGlobal AlertMessage:@"There's error on uploading Image" Title:nil];
                        [CGlobal stopIndicator:self];
                        btn.enabled = true;
                    }
                }];
            }else{
                [self postReview:reference Sender:btn];
                
            }
            
            
        }
    }else if(tag == ClickDialogButton_SETTINGOK ){
        [self setSetting:true withAnimation:true];
        [_view_setting endEditing:YES];
    }
}
-(void)setSetting:(BOOL)show withAnimation:(BOOL)animation{
    CGSize size = _view_setting.frame.size;
    if (!show) {
        _view_setting.hidden = false;
        _constraint_setting.constant = -1*size.height;
        [_view_setting setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                [_view_setting layoutIfNeeded];
            }];
        }else{
            [_view_setting layoutIfNeeded];
        }
    }else{
        _constraint_setting.constant = 0;
        [_view_setting setNeedsUpdateConstraints];
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                
                [_view_setting layoutIfNeeded];
                _view_setting.hidden = true;
            }];
        }else{
            _view_setting.hidden = true;
            [_view_setting layoutIfNeeded];
        }
        
    }
}
-(void)postReview:(NSString*)reference Sender:(UIButton*)sender{
    [CGlobal showIndicator:self];
    NetworkParser *manager = [NetworkParser sharedManager];
    [manager onAddReview:g_curReview Reference:reference Category:g_selectedCategory withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if (error == nil) {
            EftPlace* place = [[EftPlace alloc] initWithDictionary:[dict objectForKey:@"row_place"]];
            
            [g_places replaceObjectAtIndex:_m_reviewIndex withObject:place];
            NSIndexPath*indexpath = [NSIndexPath indexPathForRow:_m_reviewIndex+1 inSection:0];
            
            _m_reviewIndex = -1;
            
            EftReview *review = [[EftReview alloc] initWithDictionary:[dict objectForKey:@"ep_review"]];
            //update my review table
            BOOL found = false;
            for (EftPlace*iplace in g_myplaces) {
                if (iplace.ep_id == place.ep_id) {
                    
                    [iplace.ep_reviews addObject:review];
                    found = true;
                    break;
                }
            }
            if (!found) {
                [g_myplaces addObject:place];
            }
            
            //update table
            NSArray*indexes = [[NSArray alloc] initWithObjects:indexpath, nil];
            [_tableview_searchres reloadRowsAtIndexPaths:indexes withRowAnimation:UITableViewRowAnimationNone];
            
            
        }else{
            [CGlobal AlertMessage:@"Failed to Post Review" Title:nil];
        }
        UIButton* btn = (UIButton*)sender;
        sender.enabled = true;
        
        [CGlobal stopIndicator:self];
    }];
    
}
-(void)ClickViewComment:(UITapGestureRecognizer*)sender{
    int tag = sender.view.tag-100;
    g_selectedReview = tag;
    NSObject*object = [g_places objectAtIndex:g_selectedReview];
    
    if ([object isKindOfClass:[EftPlace class]]) {
        EftPlace*place = (EftPlace*)object;
        NetworkParser *manager = [NetworkParser sharedManager];
        [CGlobal showIndicator:self];
        [manager onQueryReview:place withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (error == nil) {
                NSArray* reviews = [dict objectForKey:@"rows"];
                NSMutableArray*list = [[NSMutableArray alloc] init];
                for (id review in reviews) {
                    EftReview* item = [[EftReview alloc] initWithDictionary:review];
                    [list addObject:item];
                }
                place.ep_reviews = list;
                
                [self gotoDetailScreen];
                
            }else{
                [CGlobal AlertMessage:@"Fail to load" Title:nil];
            }
            [CGlobal stopIndicator:self];
        }];
    }
}
-(void) gotoDetailScreen{
    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController3",@"reset":@"1"}];
}
-(void) gotoGoogleDetailScreen{
    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController7",@"reset":@"1"}];
}
-(void) gotoPhotoScreen{
    [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController5",@"reset":@"1"}];
}
-(void)ClickViewPhoto:(UITapGestureRecognizer*)sender{
    
    int tag = sender.view.tag-100;
    g_selectedReview = tag;
    NSObject*object = [g_places objectAtIndex:g_selectedReview];
    
    if ([object isKindOfClass:[EftPlace class]]) {
        EftPlace*place = (EftPlace*)object;
        if ([place.ep_reviews count] >0 ) {
            if ([place.ep_reviewpictures count] >0) {
                [self gotoPhotoScreen];
            }else{
                [CGlobal AlertMessage:@"No Photos Yet" Title:nil];
            }
        }else{
            NetworkParser *manager = [NetworkParser sharedManager];
            [CGlobal showIndicator:self];
            [manager onQueryReview:place withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                if (error == nil) {
                    NSArray* reviews = [dict objectForKey:@"rows"];
                    NSMutableArray*list = [[NSMutableArray alloc] init];
                    NSMutableArray*listpath = [[NSMutableArray alloc] init];
                    for (id review in reviews) {
                        EftReview* item = [[EftReview alloc] initWithDictionary:review];
                        [list addObject:item];
                        
                        if (![item.er_picture isBlank]) {
                            [listpath addObject:item.er_picture];
                        }
                    }
                    place.ep_reviews = list;
                    place.ep_reviewpictures = listpath;
                    
                    [self gotoPhotoScreen];
                }else{
                    [CGlobal AlertMessage:@"Fail to load" Title:nil];
                }
                
                [CGlobal stopIndicator:self];
            }];
        }
        
        
    }
    
    
}
-(void)ClickViewLink:(UITapGestureRecognizer*)sender{
    int tag = sender.view.tag-100;
    g_selectedReview = tag;
    NSObject*object = [g_places objectAtIndex:g_selectedReview];
    
    if ([object isKindOfClass:[EftPlace class]]) {
        EftPlace*place = (EftPlace*)object;
        NetworkParser *manager = [NetworkParser sharedManager];
        [CGlobal showIndicator:self];
        [manager onQueryReview:place withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (error == nil) {
                NSArray* reviews = [dict objectForKey:@"rows"];
                NSMutableArray*list = [[NSMutableArray alloc] init];
                for (id review in reviews) {
                    EftReview* item = [[EftReview alloc] initWithDictionary:review];
                    [list addObject:item];
                }
                place.ep_reviews = list;
                
                [self gotoDetailScreen];
                
            }else{
                [CGlobal AlertMessage:@"Fail to load" Title:nil];
            }
            [CGlobal stopIndicator:self];
        }];
    }else if ([object isKindOfClass:[EftGooglePlace class]]){
        EftGooglePlace*place = (EftGooglePlace*)object;
        NetworkParser *manager = [NetworkParser sharedManager];
        [CGlobal showIndicator:self WithMode:1];
        [manager onGooglePlaceDetail:place withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (error == nil) {
                NSDictionary* row = [dict objectForKey:@"row"];
                EftGooglePlace*detail = [[EftGooglePlace alloc] initWithDictionary:row];
                
                [g_places replaceObjectAtIndex:tag withObject:detail];
                
                [self gotoGoogleDetailScreen];
            }else{
                [CGlobal AlertMessage:@"Fail to load" Title:nil];
            }
            [CGlobal stopIndicator:self WithMode:1];
        }];
    }
}
-(void)ClickViewEdit:(UIView*)sender{
//    int tag = sender.view.tag-100;
    int tag = sender.tag - 100;
    int temp = _m_reviewIndex;
    _m_reviewIndex = tag;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (temp == tag) {
        _m_reviewIndex = -1;
        NSIndexPath *path1 = [NSIndexPath indexPathForRow:temp+1 inSection:0];
        [array addObject:path1];
    }else{
        NSIndexPath *path1 = [NSIndexPath indexPathForRow:temp+1 inSection:0];
        NSIndexPath *path2 = [NSIndexPath indexPathForRow:_m_reviewIndex+1 inSection:0];
        
        [array addObject:path1];
        [array addObject:path2];
    }
    if (temp != -1) {
        
        NSObject *object = [g_places objectAtIndex:temp];
        if ([object isKindOfClass:[EftPlace class]]) {
            EftPlace*place = (EftPlace*)object;
            place.tmpReview = _txt_currentReview.text;
        }else if([object isKindOfClass:[EftGooglePlace class]]){
            EftGooglePlace*place = (EftGooglePlace*)object;
            place.tmpReview = _txt_currentReview.text;
        }
    }
    
    
    
    [_tableview_searchres reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
}
-(void)ClickAttachPhoto:(UIView*)sender{
    
    UIAlertController*controller = [UIAlertController alertControllerWithTitle:@"Select Option" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
//    int tag = sender.view.tag-100;
    int tag = sender.tag - 100;
    UIAlertAction*camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        // go to camera
        
        
        BOOL authrozied = false;
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusAuthorized) {
            // do your logic
            authrozied = true;
        } else if(authStatus == AVAuthorizationStatusDenied){
            // denied
        } else if(authStatus == AVAuthorizationStatusRestricted){
            // restricted, normally won't happen
        } else if(authStatus == AVAuthorizationStatusNotDetermined){
            // not determined?!
            [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
                [self doCaptureCamera:granted];
            }];
            return;
        } else {
            
        }
        [self doCaptureCamera:authrozied];
        
    }];
    
    UIAlertAction*gallery = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        BOOL authrozied = false;
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized){
                authrozied = true;
            }else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied){
                authrozied = false;
            }else if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined){
                [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                    
                    [self doSelectAlbum:status == PHAuthorizationStatusAuthorized];
                }];
                return;
            }
        }else{
            authrozied = true;
        }
        
        [self doSelectAlbum:authrozied];
        
    }];
    
    UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [controller addAction:camera];
    [controller addAction:gallery];
    [controller addAction:cancel];
    
    if([controller popoverPresentationController] != nil){
        [controller popoverPresentationController].sourceView = sender;
    }
    
    [self presentViewController:controller animated:YES completion:nil];
}
-(void)doCaptureCamera:(BOOL)authrozied{
    if (authrozied) {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            picker.allowsEditing = false;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
            picker.delegate = self;
            [self presentViewController:picker animated:true completion:nil];
        }else{
            [CGlobal AlertMessage:@"No Camera" Title:nil];
        }
    }else{
        [CGlobal AlertMessage:@"To continue , please enable EFT access to your Camera" Title:nil];
    }
}
-(void)doSelectAlbum:(BOOL)authrozied{
    if (authrozied) {
        
        
        //picture
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            picker.allowsEditing = false;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.delegate = self;
            [self presentViewController:picker animated:true completion:nil];
        }else{
            [CGlobal AlertMessage:@"No PhotoLibrary" Title:nil];
        }
    }else{
        [CGlobal AlertMessage:@"To continue , please enable EFT access to your Photo Album" Title:nil];
    }
}
-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    UIImage * pickedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_m_reviewIndex >=0) {
        
        NSObject *object = [g_places objectAtIndex:_m_reviewIndex];
        if ([object isKindOfClass:[EftPlace class]]) {
            EftPlace*place = (EftPlace*)object;
            place.tmpImage = pickedImage;
        }else if([object isKindOfClass:[EftGooglePlace class]]){
            EftGooglePlace*place = (EftGooglePlace*)object;
            place.tmpImage = pickedImage;
        }
        _img_currentphoto.image = pickedImage;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];

}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int section = indexPath.section;
    int row = indexPath.row;
    if (tableView == _tableview_category) {
        
        EftCategory*category = [g_category objectAtIndex:section];
        if (row == 0) {
            static NSString *cellIdentifier = @"CellCategoryHeader";
            CellCategoryHeader *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell setDataForHeader:category IndexPath:indexPath Delegate:self];
            
            NSString*mid = [NSString stringWithFormat:@"%d_%d",indexPath.section,indexPath.row];
            _dic_imgcellright[mid] = cell.img_right;
            
            
            return cell;
        }else{
            EftCategory *subcategory = [category.ec_subcategory objectAtIndex:row-1];
            
            static NSString *cellIdentifier = @"CellSubCategory";
            CellSubCategory *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell setData:subcategory IndexPath:indexPath Delegate:self];
            
            cell.backgroundColor = [UIColor clearColor];
            return cell;
        }
        
    }else{
        if (row == 0) {
            int tsec = g_selIndexPath.section;
            EftCategory *category = [g_category objectAtIndex:tsec];
            
            static NSString *cellIdentifier = @"CellCategoryHeader";
            CellCategoryHeader *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            [cell setDataForHeader:category IndexPath:indexPath Delegate:self];
            
            NSString*mid = [NSString stringWithFormat:@"%d_%d",indexPath.section,indexPath.row];
            _dic_imgcellright2[mid] = cell.img_right;
            cell.img_right.image = [UIImage imageNamed:@"ico_arrowright.png"];
            
            return cell;
        }else{
            if (_m_reviewIndex == row - 1) {
                
                static NSString *cellIdentifier = @"CellForReviewEdit";
                CellForReviewEdit *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                
                _img_currentphoto = cell.imgPhoto;
                _txt_currentReview = cell.txt_review;
                
                NSObject*arplace = [g_places objectAtIndex:row-1];
                
                if ([arplace isKindOfClass:[EftPlace class]]) {
                    EftPlace *place = (EftPlace*)arplace;
                    [cell setData:place Index:row-1 Delegate:self];
                    
                }else{
                    EftGooglePlace*place = (EftGooglePlace*)arplace;
                    [cell setDataForGoogle:place Index:row-1 Delegate:self];
                    
                }
                
                return cell;
            }else{
                static NSString *cellIdentifier = @"CellForReview";
                CellForReview*cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                NSObject*arplace = [g_places objectAtIndex:row-1];
                if ([arplace isKindOfClass:[EftPlace class]]) {
                    EftPlace *place = (EftPlace*)arplace;
                    [cell setData:place Index:row-1 Delegate:self];
                }else{
                    EftGooglePlace*place = (EftGooglePlace*)arplace;
                    [cell setDataForGoogle:place Index:row-1 Delegate:self];
                }
                
                return cell;
            }
            
        }
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableview_category) {
        EftCategory *category = [g_category  objectAtIndex:section];
        if (category.isopened) {
            return [category.ec_subcategory count] + 1;
        }else{
            return 1;
        }
    }else{
        return [g_places count] + 1;
    }
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableview_category) {
        return [g_category count];
    }else{
        return 1;
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableview_category) {
        int row = indexPath.row;
        if (row == 0) {
            return 66.0;
        }else{
            return 50.0;
        }
    }else{
        int row = indexPath.row;
        if (row == 0) {
            return 66.0;
        }else if (row == _m_reviewIndex + 1){
            NSObject*arplace = [g_places objectAtIndex:row-1];
            CGFloat height;
            if ([arplace isKindOfClass:[EftPlace class]]) {
                EftPlace *place = (EftPlace*)arplace;
                height = [place getHeightForReviewEdit];
            }else{
                EftGooglePlace*place = (EftGooglePlace*)arplace;
                height = [place getHeightForReviewEdit];
            }
            return height;
        }else{
            NSObject*arplace = [g_places objectAtIndex:row-1];
            CGFloat height;
            if ([arplace isKindOfClass:[EftPlace class]]) {
                EftPlace *place = (EftPlace*)arplace;
                height = [place getHeightForReview];
            }else{
                EftGooglePlace*place = (EftGooglePlace*)arplace;
                height = [place getHeightForReview];
            }
            return height;
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableview_category) {
        int row = indexPath.row;
        int section = indexPath.section;
        g_selIndexPath = indexPath;
        
        EftCategory*selected;
        if (row == 0) {
            selected =  [g_category objectAtIndex:section];
        }else{
            EftCategory*category = [g_category objectAtIndex:section];
            selected = [category.ec_subcategory objectAtIndex:row-1];
        }
        g_selectedCategory = selected;
        
        
        _tableview_category.userInteractionEnabled = false;
    
        EftQuery*query = [[EftQuery alloc] init];
        [query initData];
        if (g_curRegion.erg_type == 1) {
            //textsearch
            
            NSString*strquery = g_selectedCategory.ec_googlekey;
            query.query = [strquery stringByAppendingString:[g_curRegion getAddressForQuery]];
            
        } else if(g_curRegion.erg_type ==2){
            
            
            query.catid = selected.ec_id;
            query.lat = g_curRegion.erg_lat;
            query.lon = g_curRegion.erg_lon;
            query.radius = g_curRadius;
            
            
        }else{
            return;
        }
        [CGlobal showIndicator:self];
        NetworkParser*manager = [NetworkParser sharedManager];
        [manager onGoogleSearch:query Mode:g_curRegion.erg_type withCompletionBlock:^(NSDictionary *dict, NSError *error) {
            if (error == nil) {
                NSMutableArray*ret = [[NSMutableArray alloc] init];
                if ([dict objectForKey:@"rows_match"]) {
                    NSArray*rows = [dict objectForKey:@"rows_match"];
                    for (int i=0; i<[rows count]; i++) {
                        NSDictionary*subdict = [rows objectAtIndex:i];
                        EftPlace*place = [[EftPlace alloc] initWithDictionary:subdict];
                        [ret addObject:place];
                    }
                }
                if ([dict objectForKey:@"rows_notmatch"]){
                    NSArray*rows = [dict objectForKey:@"rows_notmatch"];
                    for (int i=0; i<[rows count]; i++) {
                        NSDictionary*subdict = [rows objectAtIndex:i];
                        EftGooglePlace*place = [[EftGooglePlace alloc] initWithDictionary:subdict];
                        [ret addObject:place];
                    }
                }
                
                g_places = ret;
                
                
                [self showDetail:2];
            }else{
                [CGlobal AlertMessage:@"Failed to Load" Title:nil];
            }
            _tableview_category.userInteractionEnabled = true;
            [CGlobal stopIndicator:self];
        }];
        
    }else{
        
        int row = indexPath.row;
        
        
    }
    
    
}
-(void)showDetail:(int)mode{
    if (mode == 2) {
        _tableview_category.userInteractionEnabled = true;
        
        _tableview_category.hidden = true;
        _tableview_searchres.hidden = false;
        
        [_tableview_searchres reloadData];
    }else if(mode == 1){
        
        _tableview_searchres.hidden = true;
        _tableview_category.hidden = false;
        
    }
    _mode = mode;
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
