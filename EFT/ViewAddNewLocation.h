//
//  ViewAddNewLocation.h
//  EFT
//
//  Created by Twinklestar on 12/7/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewAddNewLocation : UIView

@property (strong, nonatomic) IBOutlet UITextField *searchField;
//@property (strong, nonatomic) IBOutlet UITableView *tableView;

//@property (weak,nonatomic) IBOutlet UITextField *txt_city;
//@property (weak,nonatomic) IBOutlet UITextField *txt_region;
//@property (weak,nonatomic) IBOutlet UITextField *txt_country;
//@property (weak,nonatomic) IBOutlet UITextField *txt_zipcode;
@property (weak,nonatomic) IBOutlet UIImageView *img_search;

-(void)initData;
-(void)initControls;
@end
