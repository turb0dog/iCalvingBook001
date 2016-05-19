
#import <UIKit/UIKit.h>



@class Animal;

@protocol AddAnimalViewControllerDelegate;

@interface AddAnimalViewController : UITableViewController <UITextFieldDelegate>

//@property (strong, nonatomic) DateFormatter *dateFormatter;
@property (strong, nonatomic) Animal *animal;
@property (strong, nonatomic) UIPickerView *pickerView;

@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *calfIdInput;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *cowIdInput;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *sireIdInput;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *birthDateInput;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *birthWeightInput;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *sexInput;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *weenDateInput;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *weenWeightInput;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *notesInput;

@property (weak, nonatomic) id <AddAnimalViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

@protocol AddAnimalViewControllerDelegate <NSObject>
- (void)addAnimalViewControllerDidCancel:(AddAnimalViewController *)controller;
- (void)addAnimalViewControllerDidFinish:(AddAnimalViewController *)controller calfId:(NSString *)calfId sex:(NSString *)sex;
@end
