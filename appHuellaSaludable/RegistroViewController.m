#import "RegistroViewController.h"

@interface RegistroViewController ()
@end

@implementation RegistroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configuración inicial visual si quieres
    self.title = @"Registrar Hábito";
}

- (IBAction)btnGuardarPresionado:(id)sender {
    // 1. Validar que escribió algo
    NSString *descripcion = self.campoTextoDescripcion.text;
    if (descripcion.length == 0) {
        [self mostrarAlerta:@"Falta información" mensaje:@"Por favor escribe una descripción de tu hábito."];
        return;
    }
    
    // 2. Determinar categoría e impacto (Lógica simple para el proyecto)
    // Indices del segment: 0 = Transporte, 1 = Energía, 2 = Reciclaje
    NSString *categoria = @"";
    double impacto = 0.0;
    
    switch (self.selectorCategoria.selectedSegmentIndex) {
        case 0:
            categoria = @"Transporte";
            impacto = -0.5; // Ahorras 0.5 kg de CO2 (Ej. usar bici)
            break;
        case 1:
            categoria = @"Energía";
            impacto = -0.3; // Ahorras 0.3 kg (Ej. apagar luces)
            break;
        case 2:
            categoria = @"Reciclaje";
            impacto = -0.1; // Ahorras 0.1 kg (Ej. reciclar botella)
            break;
        default:
            break;
    }
    
    // 3. Crear el objeto Habito
    Habito *nuevoHabito = [[Habito alloc] initWithNombre:descripcion
                                               categoria:categoria
                                                 impacto:impacto];
    
    // 4. Guardarlo en el Gestor (Singleton)
    [[GestorDeHabitos sharedInstance] agregarHabito:nuevoHabito];
    
    // 5. Confirmar y salir
    [self mostrarAlertaExito];
}

// Método auxiliar para mostrar alertas
- (void)mostrarAlerta:(NSString *)titulo mensaje:(NSString *)mensaje {
    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:titulo
                                                                    message:mensaje
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alerta addAction:ok];
    [self presentViewController:alerta animated:YES completion:nil];
}

- (void)mostrarAlertaExito {
    UIAlertController *alerta = [UIAlertController alertControllerWithTitle:@"¡Excelente!"
                                                                    message:@"Tu hábito ha sido registrado y tu huella de carbono ha disminuido."
                                                             preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Genial" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // Al darle OK, regresamos a la pantalla anterior (Dashboard)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [alerta addAction:ok];
    [self presentViewController:alerta animated:YES completion:nil];
}

// Cierra el teclado al tocar el fondo
- (IBAction)fondoTocado:(id)sender {
    [self.view endEditing:YES];
}

@end
