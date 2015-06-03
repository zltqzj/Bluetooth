//
//  PeripheralsViewController.m
//  BLE-Demo
//
//  Created by Joseph Lin on 4/19/14.
//  Copyright (c) 2014 Joseph Lin. All rights reserved.
//

#import "PeripheralsViewController.h"
#import "PeripheralViewController.h"
#import "CBCentralManager+Blocks.h"
#import "CBPeripheral+Debug.h"
#import "PeripheralCell.h"


@interface PeripheralsViewController ()
@property (nonatomic, weak) IBOutlet UIBarButtonItem *scanButton;
@property (nonatomic, strong) NSMutableArray *peripherals;
@property (nonatomic, strong) NSMutableArray *RSSIs;
@property (nonatomic, getter = isScanning) BOOL scanning;
@end


@implementation PeripheralsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.peripherals = [NSMutableArray new];
    self.RSSIs = [NSMutableArray new];
    __weak typeof(self) weakSelf = self;
    [self.tableView registerClass:[PeripheralCell class] forCellReuseIdentifier:@"PeripheralCell"];
    if (!self.isScanning) {
        [self.peripherals removeAllObjects];
        [self.RSSIs removeAllObjects];
        [self.tableView reloadData];
        [[CBCentralManager defaultManager] scanForPeripheralsWithServices:nil options:nil didDiscover:^(CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
            [weakSelf addPeripheral:peripheral RSSI:RSSI];
            [self.tableView reloadData];

        }];
        self.scanning = YES;
        self.scanButton.title = @"Stop";
    }
    else {
        [[CBCentralManager defaultManager] stopScanAndRemoveHandler];
        self.scanButton.title = @"Rescan";
        self.scanning = NO;
    }


}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark -

- (IBAction)scanButtonTapped:(id)sender
{
   }

- (void)addPeripheral:(CBPeripheral *)peripheral RSSI:(NSNumber *)RSSI
{
    if (![self.peripherals containsObject:peripheral]) {
        [self.tableView beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.peripherals.count inSection:0];
        [self.peripherals addObject:peripheral];
        [self.RSSIs addObject:RSSI];
        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.peripherals.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PeripheralCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PeripheralCell" forIndexPath:indexPath];
    cell.peripheral = self.peripherals[indexPath.row];
    cell.RSSI =@-58; //self.RSSIs[indexPath.row];
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    PeripheralCell *cell = sender;
    PeripheralViewController *controller = segue.destinationViewController;
    controller.peripheral = cell.peripheral;
}

@end
