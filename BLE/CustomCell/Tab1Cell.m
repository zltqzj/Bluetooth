//
//  Tab1Cell.m
//  BLE
//
//  Created by ZKR on 5/5/15.
//  Copyright (c) 2015 ZKR. All rights reserved.
//

#import "Tab1Cell.h"

@implementation Tab1Cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        NSArray* array = [[NSBundle mainBundle] loadNibNamed:@"Tab1Cell" owner:self options:nil];
        self = [array firstObject];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
