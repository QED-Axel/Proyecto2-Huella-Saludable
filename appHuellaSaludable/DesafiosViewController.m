#import "DesafiosViewController.h"

@interface DesafiosViewController ()
// Variable local para acceder rápido a los datos
@property (nonatomic, strong) NSArray<Desafio *> *misDesafios;
@end

@implementation DesafiosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Retos Semanales";
    
    // Conectamos la tabla visualmente si no lo hiciste en el storyboard (backup)
    // self.tablaDesafios.delegate = self;
    // self.tablaDesafios.dataSource = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Recargamos los datos cada vez que entramos
    [self cargarDatos];
}

- (void)cargarDatos {
    // Pedimos la lista al Singleton
    self.misDesafios = [GestorDeHabitos sharedInstance].listaDesafios;
    // Refrescamos la tabla visual
    [self.tablaDesafios reloadData];
}

#pragma mark - UITableView DataSource (Llenado de datos)

// 1. ¿Cuántas filas tiene la tabla?
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.misDesafios.count;
}

// 2. ¿Qué dibujo en cada fila?
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Reciclamos la celda usando el ID que pusimos en el Storyboard
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CeldaDesafio" forIndexPath:indexPath];
    
    // Obtenemos el desafío correspondiente a esta fila
    Desafio *desafio = self.misDesafios[indexPath.row];
    
    // Configuramos los textos
    cell.textLabel.text = desafio.titulo;
    cell.detailTextLabel.text = desafio.descripcion;
    cell.detailTextLabel.numberOfLines = 0; // Permitir varias líneas si es largo
    
    // Si está completado, ponemos un Checkmark y color verde
    if (desafio.estaCompletado) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor systemGreenColor];
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.textColor = [UIColor blackColor];
    }
    
    return cell;
}

#pragma mark - UITableView Delegate (Interacción)

// 3. ¿Qué pasa si toco una fila?
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Deseleccionar la fila visualmente (animación de gris a blanco)
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    // Llamamos al Gestor para cambiar el estado (Completado SI/NO)
    [[GestorDeHabitos sharedInstance] completarDesafioEnIndice:indexPath.row];
    
    // Recargamos la tabla para ver el cambio (Checkmark)
    [self cargarDatos];
}

@end
