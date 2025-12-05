#import "RegistroViewController.h"

@interface RegistroViewController () <UIPickerViewDelegate, UIPickerViewDataSource> // 1. Agregamos protocolos

@property (nonatomic, strong) NSArray<NSDictionary *> *opcionesHabitos; // La lista de datos
@property (nonatomic, strong) NSDictionary *seleccionActual; // Lo que el usuario eligió

@end

@implementation RegistroViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Registrar Hábito";
    
    // 2. Definimos las opciones predeterminadas con su impacto real
    self.opcionesHabitos = @[
        @{@"nombre": @"Caminar al trabajo/escuela", @"categoria": @"Transporte", @"impacto": @(-0.5)},
        @{@"nombre": @"Usar bicicleta", @"categoria": @"Transporte", @"impacto": @(-0.4)},
        @{@"nombre": @"Compartir automóvil (Car pooling)", @"categoria": @"Transporte", @"impacto": @(-0.2)},
        @{@"nombre": @"Apagar luces al salir", @"categoria": @"Energía", @"impacto": @(-0.15)},
        @{@"nombre": @"Desconectar cargadores", @"categoria": @"Energía", @"impacto": @(-0.1)},
        @{@"nombre": @"Usar focos LED", @"categoria": @"Energía", @"impacto": @(-0.05)},
        @{@"nombre": @"Reciclar plástico/vidrio", @"categoria": @"Reciclaje", @"impacto": @(-0.2)},
        @{@"nombre": @"Llevar bolsas de tela al súper", @"categoria": @"Reciclaje", @"impacto": @(-0.15)},
        @{@"nombre": @"Compostar residuos orgánicos", @"categoria": @"Reciclaje", @"impacto": @(-0.3)}
    ];
    
    // Selección por defecto (el primero)
    self.seleccionActual = self.opcionesHabitos[0];
}

- (IBAction)btnGuardarPresionado:(id)sender {
    // Ya no hay validaciones de texto vacío porque siempre hay algo seleccionado en el picker
        
        // Extraemos los datos del diccionario seleccionado
        NSString *nombre = self.seleccionActual[@"nombre"];
        NSString *categoria = self.seleccionActual[@"categoria"];
        double impacto = [self.seleccionActual[@"impacto"] doubleValue];
        
        // Creamos el hábito
        Habito *nuevoHabito = [[Habito alloc] initWithNombre:nombre
                                                   categoria:categoria
                                                     impacto:impacto];
        
        // Guardamos
        [[GestorDeHabitos sharedInstance] agregarHabito:nuevoHabito];
        
        // Confirmación
        [self mostrarAlertaExito];
    }

//Métodos UI picker
// ¿Cuántas columnas tiene?
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// ¿Cuántas filas tiene?
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.opcionesHabitos.count;
}

// ¿Qué texto muestro en cada fila?
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSDictionary *item = self.opcionesHabitos[row];
    return item[@"nombre"];
}

// ¿Qué pasa cuando seleccionan una fila?
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.seleccionActual = self.opcionesHabitos[row];
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
