//
//  SeasonsViewController.m
//  iCalvingBook
//
//  Created by Ed Herring on 10/14/13.
//  Copyright (c) 2013 SquirrelScatSoftware. All rights reserved.
//

#import "SeasonsViewController.h"

@interface SeasonsViewController ()

@end

@implementation SeasonsViewController

@synthesize dataArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
     NSLog(@"--- SeasonsViewController(viewDidLoad) ---");
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //create an array to help load Table View cells
    self.dataArray = [NSArray arrayWithObjects:
                      @"2010 - 2011",
                      @"2011 - 2012",
                      @"2012 - 2013",
                      nil];
    NSLog(@">>> SeasonsViewController (dataArray: %@)<<<", dataArray );
    

}

-(void)print_Message {
    NSLog(@"Eh up, someone just pressed the button!");
}

//set the number of rows to the number of entries in the array
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger result;
    NSLog(@"--- SeasonsViewController(numberOfRowsInSection) ---");
    result = [self.dataArray count];
    NSLog(@"--- SeasonsViewController(cellForRowAtIndexPath) result = %d ---", result);
    return result;
}

//this to initialize the table view cell with data from the array
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"--- AddSeasonViewController(cellForRowAtIndexPath ---");
    
    
    UITableViewCell *cell = nil;
    
    //check if this our table view
    if ([tableView isEqual:self.myTableView]){
        
        static NSString *TableViewCellIdentifier = @"MyCells";
        cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellIdentifier];
        if (cell == nil){
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:TableViewCellIdentifier];
        }
        
        //set the text for the cell with the data from the array
        cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
        
        //depending on the row set the sample calving seasons
        /*
        switch (indexPath.row) {
            case 0:
                cell.detailTextLabel.text = [self.dateFormatter1 stringFromDate:[NSDate date]];
                break;
            case 1:
                cell.detailTextLabel.text = [self.dateFormatter1 stringFromDate:[NSDate date]];
                break;
            default:
                break;
        }
        */
    }
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
