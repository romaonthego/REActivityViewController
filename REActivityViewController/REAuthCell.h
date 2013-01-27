//
//  REAuthCell.h
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/27/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REAuthCell : UITableViewCell

@property (strong, nonatomic) UITextField *textField;
@property (copy, nonatomic) void (^onChange)(UITextField *textField, NSString *value);

@end
