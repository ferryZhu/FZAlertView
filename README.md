# FZAlertView
支持title、message字体颜色修改。
# 如何使用
    [FZAlertView showAlertViewWithTitle:@"提示" message:@"这是一个AlertView！" customzizationBlock:^(FZAlertView *alertView) {
                // 修改title、message字体颜色
                alertView.titleColor = [UIColor redColor];
                alertView.messageColor = [UIColor blackColor];
                alertView.cancleButtonColor = [UIColor redColor];
                alertView.otherButtonColor = [UIColor blackColor];
    } completionBlock:^(FZAlertView *alertView, NSInteger indexPath) {
        NSLog(@"click : %ld", (long)indexPath);
    } cancleButtonTitle:@"cancle" otherButtonTitles:@"other_1", @"other_2", nil];