#import <UIKit/UIKit.h>
#import "GestorDeHabitos.h"

// Agregamos los protocolos <UITableView...> para decirle que esta clase sabe manejar tablas
@interface DesafiosViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tablaDesafios;

@end
