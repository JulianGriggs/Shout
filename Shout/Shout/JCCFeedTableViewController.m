//
//  JCCFeedTableViewController.m
//  Shout
//
//  Created by Julian Griggs on 3/28/14.
//  Copyright (c) 2014 Shout. All rights reserved.
//

#import "JCCFeedTableViewController.h"
#import "JCCTableViewCell.h"
@interface JCCFeedTableViewController ()
{
    // Who the message is to
    NSString *to;
    
    // Who the message is from
    NSString *from;
    
    // The contents of the message
    NSString *message;
    
    
    // A dictionary object to hold feature:value
    // ex. "to":"Cottage Club"
    NSDictionary *dictionary;
    
    // An array where each element will be a dictionary holding a feature:value
    NSMutableArray *myObject;
    
}
@end

@implementation JCCFeedTableViewController

- (void)fetchShouts
{
    [super viewDidLoad];
    to = @"Recipient";
    from = @"Sender";
    message = @"Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat vol.";
    
    // Creates myObject every time  this function is called
    myObject = [[NSMutableArray alloc] init];
    
    // This is sends a get request to the URL and saves the response in an NSData object
    NSData *jsonSource = [NSData dataWithContentsOfURL:
                          [NSURL URLWithString:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"]];
    
    // This parses the response from the server as a JSON object
    NSDictionary *jsonObjects = [NSJSONSerialization JSONObjectWithData:
                                 jsonSource options:kNilOptions error:nil];
    
    // Takes the section of the JSON object with the key 'loans'
    NSArray *latestShouts = [jsonObjects objectForKey:@"loans"];
    
    for (NSDictionary *dataDict in latestShouts) {
        NSString *title_data = [dataDict objectForKey:@"activity"];
        NSString *author_data = [dataDict objectForKey:@"name"];
        
        NSLog(@"TITLE: %@",title_data);
        NSLog(@"AUTHOR: %@",author_data);
        
        dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                      title_data, to,
                      author_data,from,
                      nil];
        [myObject addObject:dictionary];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return myObject.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This is how to efficiently use table cells such that they only load when they should
    static NSString *CellIdentifier = @"messageCell";
    JCCTableViewCell *cell = (JCCTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    
    /* Will eventually save the image here*/
    //[cell.imageView setImage:<#(UIImage *)#>];
    
    // Begin configuration of Cell
    [cell.toLabel setText:to];
    [cell.fromLabel setText:from];
    [cell.postTextView setText:message];
    
    return cell;
    
}

// Number of sections in our table view.  Our app will only use 1.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchShouts];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
