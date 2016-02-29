//
//  ViewController.m
//  FZAlertViewDemo
//
//  Created by FerryZhu on 16/2/29.
//  Copyright © 2016年 FerryZhu. All rights reserved.
//

#import "ViewController.h"
#import "FZAlertView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)buttonAction:(id)sender {
    
    [FZAlertView showAlertViewWithTitle:@"提示" message:@"这是一个AlertView！" customzizationBlock:^(FZAlertView *alertView) {
        alertView.titleColor = [UIColor redColor];
        alertView.messageColor = [UIColor blackColor];
        alertView.cancleButtonColor = [UIColor redColor];
        alertView.otherButtonColor = [UIColor blackColor];
    } completionBlock:^(FZAlertView *alertView, NSInteger indexPath) {
        NSLog(@"click : %ld", (long)indexPath);
    } cancleButtonTitle:@"cancle" otherButtonTitles:@"other_1", @"other_2", nil];
}
@end
