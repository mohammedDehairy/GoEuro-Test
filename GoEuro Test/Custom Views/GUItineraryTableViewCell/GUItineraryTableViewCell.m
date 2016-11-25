//
//  GUItineraryTableViewCell.m
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/25/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import "GUItineraryTableViewCell.h"

@implementation GUItineraryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _priceLabel.textColor = [UIColor colorWithRed:(49.0f/255.0f) green:(57.0f/255.0f) blue:(72.0f/255.0f) alpha:1.0];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    
    _timesLabel.textColor = [UIColor colorWithRed:(115.0f/255.0f) green:(115.0f/255.0f) blue:(115.0f/255.0f) alpha:1.0];
    _timesLabel.textAlignment = NSTextAlignmentCenter;
    
    _noOfStopsLabel.textColor = [UIColor colorWithRed:(115.0f/255.0f) green:(115.0f/255.0f) blue:(115.0f/255.0f) alpha:1.0];
    _noOfStopsLabel.textAlignment = NSTextAlignmentCenter;
    
    _providerImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
