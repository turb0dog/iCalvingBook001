
 #import "AddAnimalViewController.h"
//#import "Animal.h"

@interface AddAnimalViewController ()

@end

@implementation AddAnimalViewController

@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/*
 -(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( indexPath.section == 0 )
    {
        if ( indexPath.row == 3 )
        {
            UITableViewCell *targetCell = [tableView cellForRowAtIndexPath:indexPath];
            self.pickerView.date = [self.dateFormatter dateFromString:targetCell.detailTextLabel.text];
            
            // check if our date picker is already on screen
            if (self.pickerView.superview == nil)
            {
                [self.view.window addSubview: self.pickerView];
                // size up the picker view to our screen and compute the start/end frame origin for our slide up animation
                //
                // compute the start frame
                
                CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
                CGSize pickerSize = [self.pickerView sizeThatFits:CGSizeZero];
                CGRect startRect = CGRectMake(0.0,
                                              screenRect.origin.y + screenRect.size.height,
                                              pickerSize.width, pickerSize.height);
                self.pickerView.frame = startRect;
                
                // compute the end frame
                CGRect pickerRect = CGRectMake(0.0,
                                               screenRect.origin.y + screenRect.size.height - pickerSize.height,
                                               pickerSize.width,
                                               pickerSize.height);
                // start the slide up animation
                [UIView beginAnimations:nil context:NULL];
                [UIView setAnimationDuration:0.3];
                
                // we need to perform some post operations after the animation is complete
                [UIView setAnimationDelegate:self];
                
                self.pickerView.frame = pickerRect;
                
                // shrink the table vertical size to make room for the date picker
                CGRect newFrame = self.tableView.frame;
                newFrame.size.height -= self.pickerView.frame.size.height;
                self.tableView.frame = newFrame;
                [UIView commitAnimations];
                
                // add the "Done" button to the nav bar
                
                self.navigationItem.rightBarButtonItem = self.doneButton;
            }
        }
    }
}


- (IBAction)dateChanged:(id)sender
{
    [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]].detailTextLabel.text = [self.dateFormatter stringFromDate:[sender date]];
}
*/


- (void)slideDownDidStop
{
    [self.pickerView removeFromSuperview];
}

- (IBAction)doneAction:(id)sender
{
    CGRect screenRect = [[UIScreen mainScreen] applicationFrame];
    CGRect endFrame = self.pickerView.frame;
    endFrame.origin.y = screenRect.origin.y + screenRect.size.height;
    
    // start the slide down animation
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    // we need to perform some post operations after the animation is complete
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    
    self.pickerView.frame = endFrame;
    [UIView commitAnimations];
    
    // grow the table back again in vertical size to make room for the date picker
    CGRect newFrame = self.tableView.frame;
    newFrame.size.height += self.pickerView.frame.size.height;
    self.tableView.frame = newFrame;
    
    // remove the "Done" button in the nav bar
    self.navigationItem.rightBarButtonItem = nil;
    
    // deselect the current table row
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //self.navigationItem.rightBarButtonItem = self.nextButton;
}

- (id)initWithCalfId:(NSString *)calfId birthDate:(NSDate *)aBirthDate birthWeight:(NSString *)aBirthWeight
{
    self = [super init];
    if (self) {
        calfId = calfId;
        aBirthDate = aBirthDate;
        aBirthWeight = aBirthWeight;
        return self;
    }
    return nil;
}

/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReturnInput"]) {
        //if ([self.cowIdInput.text length]) {//|| [self.birthWeightInput.text length]) {
        Animal *animal;
        NSDate *today = [NSDate date];
        animal = [[Animal alloc] initWithCalfId:self.cowIdInput birthDate:today birthWeight:self.birthWeightInput];
        self.animal = animal;
    }
}
 */



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ((textField == self.calfIdInput) || (textField == self.cowIdInput)) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
