//
//  GUItineraryTableViewCell.h
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/25/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GUItineraryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *providerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timesLabel;
@property (weak, nonatomic) IBOutlet UILabel *noOfStopsLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
