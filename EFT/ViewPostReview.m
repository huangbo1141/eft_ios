//
//  ViewPostReview.m
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "ViewPostReview.h"
#import "CGlobal.h"
#import "CellGeneral.h"
#import "DataModels.h"
#import "NetworkParser.h"
#import "AFNetworking.h"
#import "NSString+Common.h"
@implementation ViewPostReview{
    NSMutableArray *items;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
#define GoogleDirectionAPI @"AIzaSyCmvC_H5S08MvkO-ixoQTpJQGXdu5qyVWg"

#define kGoogleAutoCompleteAPI @"https://maps.googleapis.com/maps/api/place/autocomplete/json?key=%@&input=%@"

-(void)initControls{
    _txt_review.placeholder = @"Enter Review";
    
    [_btn_category addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_category.tag = ClickDialogButton_CATEGORYTXTCLICK;
    
    _txt_review.backgroundColor = [UIColor grayColor];
    
    _img_photo.userInteractionEnabled = true;
    UITapGestureRecognizer*gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ClickGesture:)];
    [_img_photo addGestureRecognizer:gesture];
    _img_photo.tag = ClickDialogButton_POSTREVIEW_ATTACHIMAGE;
    
    _btn_post.tag = ClickDialogButton_POSTREVIEW_POST;
    [_btn_post addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    
    [_btn_clear addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_clear.tag = 199;
    
    [_autocompleteTable registerNib:[UINib nibWithNibName:@"CellGeneral" bundle:nil] forCellReuseIdentifier:@"CellGeneral"];
    
    [_txt_address setDelegate:self];
    
    _autocompleteTable.hidden = true;
    
    [self initData];
}
-(void)initData{
    _category_selected = nil;
    _txt_business.text = @"blue";
    _txt_category.text = @"";
    _txt_review.text = @"yyyyyy";
    _txt_address.text = @"Florida, United States";
    _picture=nil;
    _img_photo.image = [UIImage imageNamed:@"ic_action_camera_blue.png"];
    _googleplace = nil;
    _category_selected = nil;
}
-(void) ClickGesture:(UITapGestureRecognizer*)sender{
    
    int tag = sender.view.tag;
    if (tag == ClickDialogButton_POSTREVIEW_ATTACHIMAGE) {
        UIAlertController*controller = [UIAlertController alertControllerWithTitle:@"Select Option" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        
        int tag = sender.view.tag-100;
        UIAlertAction*camera = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                picker.allowsEditing = false;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                picker.delegate = self;
                [_mydelegate presentViewController:picker animated:true completion:nil];
            }else{
                [CGlobal AlertMessage:@"No Camera" Title:nil];
            }
        }];
        
        UIAlertAction*gallery = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            
            picker.allowsEditing = false;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            picker.delegate = self;
            [_mydelegate presentViewController:picker animated:true completion:nil];
            
        }];
        
        UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [controller addAction:camera];
        [controller addAction:gallery];
        [controller addAction:cancel];
        
        if([controller popoverPresentationController] != nil){
            [controller popoverPresentationController].sourceView = sender.view;
        }
        
        [_mydelegate presentViewController:controller animated:YES completion:nil];
        
        
    }
    
}
-(BOOL) checkValidate{
    if (_category_selected == nil) {
        return false;
    }
    if ([_txt_review.text isBlank]) {
        return false;
    }
    if ([_txt_address.text isBlank]) {
        return false;
    }
    if ([_txt_business.text isBlank]) {
        return false;
    }
    if ([_txt_category.text isBlank]) {
        return false;
    }
    
    return true;
}
-(void)ClickView:(UIView*)sender{
    int tag = sender.tag;
    if (tag == ClickDialogButton_CATEGORYTXTCLICK) {
        if ([_mydelegate respondsToSelector:@selector(ClickDialogButton:)]) {
            
            [_mydelegate performSelector:@selector(ClickDialogButton:) withObject:sender];
        }
    }else if (tag == ClickDialogButton_POSTREVIEW_POST){
        if ([self checkValidate]) {
            if (_googleplace != nil && _category_selected != nil) {
                if ([_mydelegate respondsToSelector:@selector(ClickDialogButton:)]) {
                    
                    [_mydelegate performSelector:@selector(ClickDialogButton:) withObject:sender];
                }
            }else{
                _btn_post.enabled = false;
                [CGlobal showIndicator:_mydelegate WithMode:1];
                if (_picture != nil) {
                    NSString*filename = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
                    filename = [filename stringByAppendingString:@".jpg"];
                    NSString* uploadpath = [g_baseUrl stringByAppendingString:@"uploads/"];
                    uploadpath = [uploadpath stringByAppendingString:filename];
                    
                    
                    NetworkParser *manager = [NetworkParser sharedManager];
                    [manager uploadImage:_picture ImagePath:uploadpath FileName:filename withCompletionBlock:^(NSDictionary *dict, NSError *error) {
                        if (error== nil) {
                            [self postReview:uploadpath];
                        }else{
                            [CGlobal AlertMessage:@"There's error on uploading Image" Title:nil];
                            
                            [CGlobal stopIndicator:_mydelegate WithMode:1];
                            _btn_post.enabled = true;
                        }
                        
                    }];
                }else{
                    [self postReview:@""];
                }
            }
        }else{
            [CGlobal AlertMessage:@"Fill the information" Title:nil];
        }
    }
    else if(tag == 199){
        _txt_review.text = @"";
        _img_photo.image = [UIImage imageNamed:@"ic_action_camera_blue.png"];
        _picture = nil;
    }
    
}
-(void) postReview:(NSString*)uploadpath{
    EftQuery* query = [EftQuery alloc];
    NSString *querystring = [CGlobal processAddressForQuery:_txt_business.text];
    querystring = [querystring stringByAppendingString:@"+"];
    NSString *temp = [CGlobal processAddressForQuery:_txt_address.text];
    querystring = [querystring stringByAppendingString:temp];
    
    query.query = querystring;
    query.catid = _category_selected.ec_id;
    
    g_curReview = [[EftReview alloc] init];
    [g_curReview initData];
    g_curReview.er_text = _txt_review.text;
    g_curReview.er_picture = uploadpath;
    
    
    NetworkParser *manager = [NetworkParser sharedManager];
    [manager onAddReviewFast:query EftReview:g_curReview Mode:1 withCompletionBlock:^(NSDictionary *dict, NSError *error) {
        if(error == nil){
            if ([_mydelegate respondsToSelector:@selector(ClickFastReview:)]) {
                [_mydelegate performSelector:@selector(ClickFastReview:) withObject:dict];
            }
        }else{
            [CGlobal AlertMessage:@"Failed to Post. Try Again" Title:nil];
        }
        [CGlobal stopIndicator:_mydelegate WithMode:1];
        _btn_post.enabled = true;
    }];
}
-(void) imagePickerController:(UIImagePickerController*) picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info
{
    
    _picture = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    _img_photo.image = _picture;
    _googleplace.tmpImage = _picture;
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:true completion:nil];
}
-(void)setCategory:(EftCategory*)category{
    _category_selected = category;
    _txt_category.text = category.ec_name;
}
-(void)setPlace:(EftGooglePlace*)place{
    if (place != nil) {
        _googleplace = place;
        _googleplace.tmpImage = _picture;
        _txt_address.text  = place.formatted_address;
        _txt_business.text = place.name;
    }
}
-(void)setMyDelegate:(id) delegate{
    if (_mydelegate != delegate) {
        _mydelegate =delegate;
    }
}
#pragma mark - tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        CellGeneral *cell = [tableView dequeueReusableCellWithIdentifier:@"CellGeneral" forIndexPath:indexPath];
        
        cell.lbl_content.text = items[indexPath.row];
        cell.backgroundColor = [UIColor lightGrayColor];
        return cell;
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _autocompleteTable) {
        if (items.count == 0) {
            tableView.hidden = true;
        }
        return items.count;
    }
    return [g_savedLocations count];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 23;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    long row = indexPath.row;
    
    _txt_address.text = items[indexPath.row];
    
    [_autocompleteTable deselectRowAtIndexPath:indexPath animated:YES];
    
    _autocompleteTable.hidden = true;
    
    return;
    
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (![textField.text isEqualToString:@""]) {
        [self getAutoCompletePlaces:textField.text];
    }
    
    return YES;
}
-(void)getAutoCompletePlaces:(NSString *)searchKey{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    // set request timeout
    manager.requestSerializer.timeoutInterval = 5;
    
    NSString *url = [[NSString stringWithFormat:kGoogleAutoCompleteAPI,GoogleDirectionAPI,searchKey] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
    
    NSLog(@"API : %@",url);
    
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"JSON: %@", responseObject);
        
        
        NSDictionary *JSON = responseObject;
        
        items = [NSMutableArray array];
        
        // success
        AutomCompletePlaces *places = [AutomCompletePlaces modelObjectWithDictionary:JSON];
        
        for (Predictions *pred in places.predictions) {
            
            [items addObject:pred.predictionsDescription];
            
        }
        if ([items count]>0) {
            [_autocompleteTable reloadData];
            _autocompleteTable.hidden = false;
        }else{
            _autocompleteTable.hidden = true;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        _autocompleteTable.hidden = true;
    }];
    
}
@end
