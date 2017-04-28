//
//  TableViewController.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 27/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "TableViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"

@interface TableViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Login";
            break;
        case 1:
            cell.textLabel.text = @"Register";
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            switch (indexPath.row) {
                case 0: {
                    LoginViewController *loginVC1 = [[LoginViewController alloc] init];
                    loginVC1.flag = YES;
                    [self.navigationController pushViewController:loginVC1 animated:YES];
                }
                    break;
                case 1: {
                    RegisterViewController *registerVC1 = [[RegisterViewController alloc] init];
                    registerVC1.flag = YES;
                    [self.navigationController pushViewController:registerVC1 animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    LoginViewController *loginVC2 = [[LoginViewController alloc] init];
                    [self.navigationController pushViewController:loginVC2 animated:YES];
                }
                    break;
                case 1: {
                    RegisterViewController *registerVC2 = [[RegisterViewController alloc] init];
                    [self.navigationController pushViewController:registerVC2 animated:YES];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

@end
