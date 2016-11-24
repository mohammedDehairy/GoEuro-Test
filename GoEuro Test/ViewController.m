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
    }
    
    
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
        [self.view addSubview:self.tableView];
        
        NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_tableView);
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tableView]|" options:0 metrics:nil views:viewsDict]];
    }
    
    NSDictionary *viewsDict = NSDictionaryOfVariableBindings(_tableView,_tabBar);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_tabBar][_tableView]|" options:0 metrics:nil views:viewsDict]];
    
    self.dataSource = [NSMutableArray arrayWithArray:@[[NSArray array],[NSArray array],[NSArray array]]];
    
    [self loadDataWithType:GUItineraryTypeTrain];
    
}

-(void)loadDataWithType:(GUItineraryType)type{
    [GUItineraryLoader loadItinerariesWithType:type completionBlock:^(NSArray<GUItinerary*>* result,NSError *error){
        if(!error){
            self.dataSource[type] = result;
            [self.tableView reloadData];
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
    static NSString * const cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    return cell;
}
@end
