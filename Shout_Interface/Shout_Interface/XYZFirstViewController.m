//
//  XYZFirstViewController.m
//  Shout_Interface
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "XYZFirstViewController.h"

@interface XYZFirstViewController ()


@end

@implementation XYZFirstViewController

- (void)fetchShouts
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData* data = [NSData dataWithContentsOfURL:
                        [NSURL URLWithString: @"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]];
        
        NSError* error;
        
        JSONshouts = [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return shouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *shout = [shouts objectAtIndex:indexPath.row];
    NSString *messageText = [shout objectForKey:@"loans"];
//    NSString *title = [shout objectForKey:@"title"];
    
//    cell.textLabel.text = title;
    cell.detailTextLabel.text = messageText;
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchShouts];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
