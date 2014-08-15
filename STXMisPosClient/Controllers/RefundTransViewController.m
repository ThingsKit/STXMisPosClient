//
//  CancelTransViewController.m
//  STXMisPosClient
//
//  Created by 马远征 on 14-8-13.
//  Copyright (c) 2014年 马远征. All rights reserved.
//

#import "RefundTransViewController.h"

@interface RefundTransViewController ()
@property (weak, nonatomic) IBOutlet UITextField *moneyTextField;
@property (weak, nonatomic) IBOutlet UITextField *transDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *batchNoTextField;
@property (weak, nonatomic) IBOutlet UITextField *voucherNOTextField;
@property (weak, nonatomic) IBOutlet UITextField *refNoTextField;
@property (copy, nonatomic) refundBlock refundBlock;
@end

@implementation RefundTransViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
    }
    return self;
}

- (void)execRefund:(refundBlock)refund
{
    _refundBlock = refund;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)clickToBack:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)clickToDismissWithParams:(id)sender
{
    if (_refNoTextField.text.length <= 0)
    {
        [[YZProgressHUD HUD]showWithError:self.view.window labelText:@"请输入原参考号" detailText:nil];
        return;
    }
    
    if (_voucherNOTextField.text.length <= 0)
    {
        [[YZProgressHUD HUD]showWithError:self.view.window labelText:@"请输入原交易流水号" detailText:nil];
        return;
    }
    if (_batchNoTextField.text.length <= 0)
    {
        [[YZProgressHUD HUD]showWithError:self.view.window labelText:@"请输入原交易批次号" detailText:nil];
        return;
    }
    if (_transDateTextField.text.length <= 0)
    {
        [[YZProgressHUD HUD]showWithError:self.view.window labelText:@"请输入原交易日期" detailText:nil];
        return;
    }
    if (_moneyTextField.text.length <= 0)
    {
        [[YZProgressHUD HUD]showWithError:self.view.window labelText:@"请输入退货金额" detailText:nil];
        return;
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (_refundBlock)
        {
            _refundBlock(_refNoTextField.text,_voucherNOTextField.text,
                         _batchNoTextField.text,_transDateTextField.text,_moneyTextField.text);
        }
        
    }];
}


@end
