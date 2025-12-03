#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Configuración inicial visual
    self.title = @"Dashboard";
}

// IMPORTANTE: Usamos viewWillAppear en lugar de viewDidLoad
// Esto asegura que cada vez que "regreses" de la pantalla de registro,
// los datos se refresquen.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self actualizarDatos];
}

- (void)actualizarDatos {
    // 1. Obtener la huella total del Gestor
    double totalHuella = [[GestorDeHabitos sharedInstance] calcularHuellaTotal];
    
    // 2. Actualizar la etiqueta grande
    // Usamos %.2f para mostrar solo 2 decimales.
    // Si es negativo (ahorro), lo mostramos en verde.
    self.lblHuellaTotal.text = [NSString stringWithFormat:@"%.2f kg CO2", totalHuella];
    
    if (totalHuella < 0) {
        self.lblHuellaTotal.textColor = [UIColor systemGreenColor];
        self.lblMensajeMotivacional.text = @"¡Estás ayudando al planeta!";
    } else {
        self.lblHuellaTotal.textColor = [UIColor blackColor];
        self.lblMensajeMotivacional.text = @"Registra hábitos para reducir tu huella.";
    }
    
    // 3. Dibujar la gráfica
    [self dibujarGraficaSemanal];
}

- (void)dibujarGraficaSemanal {
    // Limpiamos la gráfica anterior para no encimar dibujos
    for (UIView *v in self.vistaGrafica.subviews) {
        [v removeFromSuperview];
    }
    
    NSArray *datos = [[GestorDeHabitos sharedInstance] obtenerHistorialImpactoUltimos7Dias];
    
    // Configuraciones de dimensiones
    CGFloat anchoTotal = self.vistaGrafica.frame.size.width;
    CGFloat altoTotal = self.vistaGrafica.frame.size.height;
    CGFloat anchoBarra = (anchoTotal / 7.0) - 5.0; // Espacio para 7 barras con margen
    CGFloat maxValor = 2.0; // Escala máxima arbitraria (2kg) para que la barra no se salga
    
    for (int i = 0; i < datos.count; i++) {
        double valor = [datos[i] doubleValue];
        
        // Calculamos la altura de la barra (valor absoluto porque el ahorro es negativo)
        double altura = (fabs(valor) / maxValor) * altoTotal;
        if (altura > altoTotal) altura = altoTotal; // Tope visual
        if (altura < 5) altura = 5; // Altura mínima para que se vea algo
        
        CGFloat xPos = i * (anchoTotal / 7.0);
        CGFloat yPos = altoTotal - altura; // Dibujamos de abajo hacia arriba
        
        // Crear la vista de la barra
        UIView *barra = [[UIView alloc] initWithFrame:CGRectMake(xPos, yPos, anchoBarra, altura)];
        
        // Color: Verde si ahorró (negativo), Rojo si contaminó (positivo), Gris si es 0
        if (valor < 0) {
            barra.backgroundColor = [UIColor systemGreenColor];
        } else if (valor > 0) {
            barra.backgroundColor = [UIColor systemRedColor];
        } else {
            barra.backgroundColor = [UIColor systemGray5Color];
        }
        
        // Redondear esquinas superiores
        barra.layer.cornerRadius = 4;
        
        [self.vistaGrafica addSubview:barra];
    }
}

// Acciones de los botones (Navegación ya hecha por Segues en Storyboard)
// Solo necesitamos declararlos vacíos si el Storyboard se encarga,
// o usarlos si queremos hacer algo extra antes de cambiar de pantalla.

- (IBAction)btnRegistrarHabitoPresionado:(id)sender {
    // El Segue del storyboard hace el trabajo de navegación.
}

- (IBAction)btnVerDesafiosPresionado:(id)sender {
    // El Segue del storyboard hace el trabajo.
}

@end
