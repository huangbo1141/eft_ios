//
//  PlaceAddViewController.m
//  EFT
//
//  Created by Twinklestar on 12/21/15.
//  Copyright © 2015 Twinklestar. All rights reserved.
//

#import "PlaceAddViewController.h"
#import "CGlobal.h"

@interface PlaceAddViewController ()

@end

@implementation PlaceAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}
-(void) initControls{
    [CGlobal makeButtonStyleBlue:_btn_back];
    [_btn_back addTarget:self action:@selector(ClickView:) forControlEvents:UIControlEventTouchUpInside];
    _btn_back.tag = 100;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)ClickView:(id)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton*button = (UIButton*)sender;
        int tag = button.tag;
        if (tag == 100) {
            [[NSNotificationCenter defaultCenter] postNotificationName:GLOBALNOTIFICATION_CHANGEVIEWCONTROLLER object:nil userInfo:@{@"id":@"viewController1"}];
        }
    }
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
