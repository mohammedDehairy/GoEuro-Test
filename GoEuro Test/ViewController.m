//
//  ViewController.m
//  GoEuro Test
//
//  Created by mohamed mohamed El Dehairy on 11/24/16.
//  Copyright © 2016 mohamed El Dehairy. All rights reserved.
//

#import "ViewController.h"
#import "GUTabBarView.h"
#import "GUItineraryLoader.h"
#import "GUItineraryTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

static NSString * const cellId = @"cellId";

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)GUTabBarView *tabBar;
@property(nonatomic,strong)NSMutableArray<NSArray<GUItinerary*>*>* dataSource;
@property(nonatomic,assign)NSUInteger selectedIndex;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 0;
    
    // Top tab bar
    {
        GUTabBarViewItem *item1 = [GUTabBarViewItem new];
        item1.title = @"Train";
        GUTabBarViewItem *item2 = [GUTabBarViewItem new];
        item2.title = @"Bus";
        GUTabBarViewItem *item3 = [GUTabBarViewItem new];
        item3.title = @"Flight";
        self.tabBar = [[GUTabBarView alloc] initWithItems:@[item1,item2,item3] frame:CGRectZero];
        [self.view addSubview:self.tabBar];
        [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_tabBar);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tabBar]|" options:0 metrics:nil views:viewsDict]];
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.tabBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self.tabBar addConstraint:[NSLayoutConstraint constraintWithItem:_tabBar attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0.0 constant:70]];
        
        __weak ViewController *weakSelf = self;
        self.tabBar.tapCallBack = ^(NSInteger itemIndex){
            __strong ViewController *strongSelf = weakSelf;
            strongSelf.selectedIndex = itemIndex;
            [strongSelf.tableView reloadData];
        };
    }
    
    // Table View
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        self.tableView.rowHeight = 100;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
        
        [self.tableView registerNib:[UINib nibWithNibName:@"GUItineraryTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
        
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_tableView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:viewsDict]];
    }
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_tableView,_tabBar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tabBar][_tableView]|" options:0 metrics:nil views:viewsDict]];
    
    self.dataSource = [NSMutableArray arrayWithArray:@[[NSArray array],[NSArray array],[NSArray array]]];
    
    [self loadDataWithType:GUItineraryTypeTrain];
    [self loadDataWithType:GUItineraryTypeBus];
    [self loadDataWithType:GUItineraryTypeFlight];
    
}

-(void)loadDataWithType:(GUItineraryType)type{
    [GUItineraryLoader loadItinerariesWithType:type completionBlock:^(NSArray<GUItinerary*>* result,NSError *error){
        if(!error){
            self.dataSource[type] = result;
            if(type == _selectedIndex){
                [self.tableView reloadData];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate/DataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource[self.selectedIndex].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GUItineraryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    if(!cell){
        cell = [[GUItineraryTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    
    GUItinerary *itinerary = self.dataSource[self.selectedIndex][indexPath.row];
    [cell.providerImageView sd_setImageWithURL:itinerary.logoUrl];
    [cell.timesLabel setText:[NSString stringWithFormat:@"%02lu:%02lu - %02lu:%02lu",itinerary.depHour,itinerary.depMinute,itinerary.arrivalHour,itinerary.arrivalMinute]];
    [cell.priceLabel setText:itinerary.priceFormatedString];
    
    NSString *noOfStopsString = nil;
    
    if(itinerary.noOfStops == 0){
        noOfStopsString = [NSString stringWithFormat:@"%@  %@",@"Direct",itinerary.durationFormattedString];
    }else{
        noOfStopsString = [NSString stringWithFormat:@"%lu  %@",itinerary.noOfStops,itinerary.durationFormattedString];
    }
    cell.noOfStopsLabel.text = noOfStopsString;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Offer details are not yet implemented!" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
                                          
}
@end
