//
//  XYZViewController.m
//  Shout
//
//  Created by Julian Griggs on 3/25/14.
//
//

#import "XYZViewController.h"

@interface XYZViewController ()

@end

@implementation XYZViewController
{
    NSDictionary *sampleTweets;
    NSArray *sampleTweetTitles;
    
    NSDictionary *sampleTweets2;
    NSArray *sampleTweetTitles2;
}

// Optional method that adds a title to a section
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return @"Section 1";
    else
        return @"Section 2";
}

// Optional method that tells how many sections there are in the tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

// This is required to implement to be a data source for a table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
        return [sampleTweets count];
    else
        return [sampleTweets2 count];
}


// This is required to implement to be a data source for a table view
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // This is the way to create a cell, it is more efficient because it looks to see if there is a cell with identifier @"cell" available for reuse
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    // indexPath has a section property and a row property.
    if (indexPath.section == 0)
    {
        cell.textLabel.text = sampleTweetTitles[indexPath.row];
        cell.detailTextLabel.text = sampleTweets[sampleTweetTitles[indexPath.row]];
    }
    else
    {
        cell.textLabel.text = sampleTweetTitles2[indexPath.row];
        cell.detailTextLabel.text = sampleTweets2[sampleTweetTitles2[indexPath.row]];
    }
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSURL *pathToFile = [[NSBundle mainBundle] URLForResource:@"SampleTweets" withExtension:@"plist"];
    
    // load the plist into the dictionary
    sampleTweets = [NSDictionary dictionaryWithContentsOfURL:pathToFile];
    // create an array with just the tweet titles(keys)
    sampleTweetTitles = [sampleTweets allKeys];
    
    NSURL *pathToFile2 = [[NSBundle mainBundle] URLForResource:@"SampleTweets2" withExtension:@"plist"];
    sampleTweets2 = [NSDictionary dictionaryWithContentsOfURL:pathToFile2];
    sampleTweetTitles2 = [sampleTweets2 allKeys];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
