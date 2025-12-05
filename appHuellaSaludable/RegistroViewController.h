#import <UIKit/UIKit.h>
#import "GestorDeHabitos.h" // Necesitamos esto para guardar

@interface RegistroViewController : UIViewController

// NUEVO: Outlet para el Picker (borra los de segmented y textfield si quieres limpiar)
@property (weak, nonatomic) IBOutlet UIPickerView *pickerHabitos;

// Acción del botón
- (IBAction)btnGuardarPresionado:(id)sender;

// Acción para cerrar el teclado si tocan fuera (opcional pero recomendado)
- (IBAction)fondoTocado:(id)sender;

@end
