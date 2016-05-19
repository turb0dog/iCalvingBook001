//
// DataGridCell.m
//

#import "DataGridCell.h"

@implementation DataGridCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self setSelectionStyle:UITableViewCellSelectionStyleGray];
        
    }
    return self;
}

- (void)dealloc
{
    //[super dealloc];
}

@end
