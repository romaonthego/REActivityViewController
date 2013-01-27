//
//  REAuthCell.m
//  REActivityViewControllerExample
//
//  Created by Roman Efimov on 1/27/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "REAuthCell.h"

@implementation REAuthCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(120, 0, self.frame.size.width - 140, 44)];
        _textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [_textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:_textField];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [_textField becomeFirstResponder];
    }
}

- (void)textFieldChanged:(UITextField *)textField
{
    if (_onChange)
        _onChange(textField, textField.text);
}

@end
