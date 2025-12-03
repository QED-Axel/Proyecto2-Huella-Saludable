#import <UIKit/UIKit.h>
#import "GestorDeHabitos.h" // Necesitamos esto para guardar

@interface RegistroViewController : UIViewController

// UI Elements
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectorCategoria;
@property (weak, nonatomic) IBOutlet UITextField *campoTextoDescripcion;

// Acción del botón
- (IBAction)btnGuardarPresionado:(id)sender;

// Acción para cerrar el teclado si tocan fuera (opcional pero recomendado)
- (IBAction)fondoTocado:(id)sender;

@end
