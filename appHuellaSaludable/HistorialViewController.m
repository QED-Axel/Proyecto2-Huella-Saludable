#import "HistorialViewController.h"

@interface HistorialViewController ()
@end

@implementation HistorialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Mi Historial";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Recargar datos cada vez que entramos por si agregaste algo nuevo
    [self.tablaHistorial reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Pedimos al Gestor cuántos hábitos hay guardados
    return [GestorDeHabitos sharedInstance].listaHabitos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CeldaHistorial" forIndexPath:indexPath];
    
    // Obtenemos el hábito de la lista
    Habito *h = [GestorDeHabitos sharedInstance].listaHabitos[indexPath.row];
    
    // Configurar textos
    cell.textLabel.text = h.nombre;
    
    // Formato: "Energía: -0.50 kg"
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@: %.2f kg", h.categoria, h.impactoCarbono];
    
    // Color verde si ahorra, rojo si contamina
    if (h.impactoCarbono < 0) {
        cell.detailTextLabel.textColor = [UIColor systemGreenColor];
    } else {
        cell.detailTextLabel.textColor = [UIColor systemRedColor];
    }
    
    return cell;
}

#pragma mark - Borrar Hábito (Delete)

// Habilita la edición de la tabla
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// Este método activa el botón rojo de "Delete" al deslizar
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 1. Borrar del Modelo de Datos (Gestor)
        [[GestorDeHabitos sharedInstance] eliminarHabitoEnIndice:indexPath.row];
        
        // 2. Borrar de la Tabla Visualmente (con animación bonita)
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // Nota: No necesitamos reloadData porque deleteRowsAtIndexPaths ya actualiza la vista
    }
}

@end
