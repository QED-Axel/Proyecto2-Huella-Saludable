#import <UIKit/UIKit.h>
#import "GestorDeHabitos.h"

@interface HistorialViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tablaHistorial;

@end
