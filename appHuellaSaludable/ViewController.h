#import <UIKit/UIKit.h>
#import "GestorDeHabitos.h" // Importante importar el gestor

@interface ViewController : UIViewController

// Etiquetas para mostrar datos
@property (weak, nonatomic) IBOutlet UILabel *lblHuellaTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblMensajeMotivacional;

// Vista para la gráfica (donde dibujaremos las barritas)
@property (weak, nonatomic) IBOutlet UIView *vistaGrafica;

// Acciones (Botones)
- (IBAction)btnRegistrarHabitoPresionado:(id)sender;
- (IBAction)btnVerDesafiosPresionado:(id)sender;

@end
