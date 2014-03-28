//
//  XYZFirstViewController.m
//  Shout_Interface
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "XYZFirstViewController.h"

@interface XYZFirstViewController ()
{
    NSString *title;
    NSString * message;
    
    NSString *author;
    NSMutableArray *myObject;
    // A dictionary object
    NSDictionary *dictionary;
    // Define keys
}

@end

@implementation XYZFirstViewController

- (void)fetchShouts
{
    [super viewDidLoad];
    title = @"title";
    message = @"message";
    author = @"author";
    
    myObject = [[NSMutableArray alloc] init];
    
    NSData *jsonSource = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]];
    
    NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                      jsonSource options:kNilOptions error:nil];
    
    NSArray *latestShouts = [jsonObjects objectForKey:@"loans"];
    
    for (NSDictionary *dataDict in latestShouts) {
        NSString *title_data = [dataDict objectForKey:@"activity"];
        NSString *author_data = [dataDict objectForKey:@"name"];
        
        NSLog(@"TITLE: %@",title_data);
        NSLog(@"AUTHOR: %@",author_data);
        
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      title_data, title,
                      author_data,author,
                      nil];
        [myObject addObject:dictionary];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return myObject.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"messageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *tmpDict = [myObject objectAtIndex:indexPath.row];
    
    NSMutableString *text;
    //text = [NSString stringWithFormat:@"%@",[tmpDict objectForKey:title]];
    text = [NSMutableString stringWithFormat:@"%@",
            [tmpDict objectForKeyedSubscript:title]];
    
    NSMutableString *detail;
    detail = [NSMutableString stringWithFormat:@"Author: %@ ",
              [tmpDict objectForKey:author]];
    
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text= detail;
    
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
