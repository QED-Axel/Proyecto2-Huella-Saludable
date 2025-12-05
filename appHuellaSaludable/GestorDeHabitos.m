//
//  GestorDeHabitos.m
//  ProyectoEcologia
//

#import "GestorDeHabitos.h"
#import <UserNotifications/UserNotifications.h>

@interface GestorDeHabitos ()
// Redefinimos internamente como readwrite para poder modificar las listas aquí dentro
@property (nonatomic, strong, readwrite) NSMutableArray<Habito *> *listaHabitos;
@property (nonatomic, strong, readwrite) NSMutableArray<Desafio *> *listaDesafios;
@property (nonatomic, assign) NSInteger diasSimulados;
@end

@implementation GestorDeHabitos

#pragma mark - Singleton

+ (instancetype)sharedInstance {
    static GestorDeHabitos *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // Al iniciar la app, cargamos todo lo que esté guardado
        [self cargarDatosLocales];
        
        // Verificación de seguridad: Si no hay desafíos (primera vez que se usa la app), cargamos los default
        if (self.listaDesafios.count == 0) {
            [self cargarDesafiosIniciales];
        }
    }
    return self;
}

#pragma mark - Gestión de Hábitos (CRUD)

- (void)agregarHabito:(Habito *)nuevoHabito {
    if (!nuevoHabito) return;
    
    // TRUCO: Si estamos simulando días, alteramos la fecha del hábito
    if (self.diasSimulados > 0) {
        nuevoHabito.fechaRegistro = [[NSDate date] dateByAddingTimeInterval:self.diasSimulados * 86400];
    }
    
    [self.listaHabitos addObject:nuevoHabito];
    [self guardarDatosLocales];
}

- (void)eliminarHabitoEnIndice:(NSUInteger)indice {
    if (indice < self.listaHabitos.count) {
        [self.listaHabitos removeObjectAtIndex:indice];
        [self guardarDatosLocales];
    }
}

- (double)calcularHuellaTotal {
    double total = 0.0;
    for (Habito *h in self.listaHabitos) {
        total += h.impactoCarbono;
    }
    return total;
}

#pragma mark - Gestión de Desafíos

- (void)cargarDesafiosIniciales {
    // Obtenemos la lista estática de la clase Desafio y la convertimos en mutable
    self.listaDesafios = [[Desafio obtenerDesafiosSemanales] mutableCopy];
    [self guardarDatosLocales];
}

- (void)completarDesafioEnIndice:(NSUInteger)indice {
    if (indice < self.listaDesafios.count) {
        Desafio *desafio = self.listaDesafios[indice];
        
        // Invertimos el estado (si estaba NO pasa a YES, y viceversa)
        // O simplemente lo ponemos en YES si solo queremos marcar como hecho.
        desafio.estaCompletado = !desafio.estaCompletado;
        
        // Guardamos los cambios para que se recuerde al cerrar la app
        [self guardarDatosLocales];
    }
}

#pragma mark - Persistencia (Almacenamiento Local)

// Ruta para el archivo de hábitos
- (NSString *)rutaArchivoHabitos {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return [documentsDirectory stringByAppendingPathComponent:@"habitos.archive"];
}

// Ruta para el archivo de desafíos
- (NSString *)rutaArchivoDesafios {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return [documentsDirectory stringByAppendingPathComponent:@"desafios.archive"];
}

- (void)guardarDatosLocales {
    // Guardamos ambos arrays en archivos separados
    [NSKeyedArchiver archiveRootObject:self.listaHabitos toFile:[self rutaArchivoHabitos]];
    [NSKeyedArchiver archiveRootObject:self.listaDesafios toFile:[self rutaArchivoDesafios]];
    
    NSLog(@"Datos guardados correctamente.");
}

- (void)cargarDatosLocales {
    // 1. Cargar Hábitos
    NSMutableArray *habitosGuardados = [NSKeyedUnarchiver unarchiveObjectWithFile:[self rutaArchivoHabitos]];
    if (habitosGuardados) {
        self.listaHabitos = habitosGuardados;
    } else {
        self.listaHabitos = [[NSMutableArray alloc] init];
    }
    
    // 2. Cargar Desafíos
    NSMutableArray *desafiosGuardados = [NSKeyedUnarchiver unarchiveObjectWithFile:[self rutaArchivoDesafios]];
    if (desafiosGuardados) {
        self.listaDesafios = desafiosGuardados;
    } else {
        self.listaDesafios = [[NSMutableArray alloc] init];
    }
}

- (NSArray<NSNumber *> *)obtenerHistorialImpactoUltimos7Dias {
    NSMutableArray *historial = [NSMutableArray array];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // --- CAMBIO AQUÍ: ---
    // En lugar de usar la fecha real directamente, calculamos la fecha simulada.
    NSDate *hoyReal = [NSDate date];
    // Sumamos los días simulados (86400 segundos por día)
    NSDate *hoy = [hoyReal dateByAddingTimeInterval:self.diasSimulados * 86400];
    // --------------------
    
    // Iteramos los últimos 7 días (de hace 6 días hasta la fecha "hoy" simulada)
    for (NSInteger i = 6; i >= 0; i--) {
        // Calcular la fecha objetivo (Hoy - i días)
        NSDate *fechaObjetivo = [calendar dateByAddingUnit:NSCalendarUnitDay value:-i toDate:hoy options:0];
        
        double sumaDelDia = 0.0;
        
        // Buscamos en todos los hábitos cuáles coinciden con este día
        for (Habito *h in self.listaHabitos) {
            if ([calendar isDate:h.fechaRegistro inSameDayAsDate:fechaObjetivo]) {
                sumaDelDia += h.impactoCarbono;
            }
        }
        
        // Agregamos la suma al array
        [historial addObject:@(sumaDelDia)];
    }
    
    return [historial copy];
}

#pragma mark - Notificaciones

- (void)programarNotificacionesLocales {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    // 1. Pedir permiso al usuario
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            NSLog(@"Permiso de notificaciones concedido.");
            [self agendarRecordatorioDiario];
        } else {
            NSLog(@"Permiso denegado.");
        }
    }];
}

- (void)agendarRecordatorioDiario {
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    
    // Eliminar notificaciones previas para no duplicar
    [center removeAllPendingNotificationRequests];

    // 2. Configurar el contenido
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"🌿 Recordatorio Sostenible";
    content.body = @"¿Qué hiciste por el planeta hoy? Registra tus hábitos.";
    content.sound = [UNNotificationSound defaultSound];

    // 3. Configurar el disparador (Ejemplo: Todos los días a las 8:00 PM)
    NSDateComponents *dateInfo = [[NSDateComponents alloc] init];
    dateInfo.hour = 17; // 20:00 horas
    dateInfo.minute = 31;
    
    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateInfo repeats:YES];

    // 4. Crear la petición
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"RecordatorioDiario" content:content trigger:trigger];

    // 5. Agregar al centro de notificaciones
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error al agendar notificación: %@", error);
        }
    }];
}

// Reset

- (void)reiniciarDatosDeFabrica {
    // 1. Borrar todos los hábitos
    [self.listaHabitos removeAllObjects];
    
    // 2. Reiniciar los desafíos a su estado original (sin checks)
    self.listaDesafios = [[Desafio obtenerDesafiosSemanales] mutableCopy];
    
    // 3. Guardar estos cambios vacíos en el disco inmediatamente
    [self guardarDatosLocales];
    
    NSLog(@"App reiniciada a estado de fábrica.");
}

- (void)simularAvanceDeDia {
    // 1. Aumentamos el contador de días
    self.diasSimulados += 1;
    NSLog(@"Has viajado al futuro: +%ld días", (long)self.diasSimulados);
    
    // 2. Disparamos la notificación INMEDIATAMENTE (para la demo)
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = [NSString stringWithFormat:@"Día %ld: ¡Sigue así!", (long)self.diasSimulados];
    content.body = @"Nuevo día, nueva oportunidad. ¡Registra tus hábitos!";
    content.sound = [UNNotificationSound defaultSound];
    
    // Trigger de 1 segundo (casi inmediato)
    UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO];
    
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"SimulacionDia" content:content trigger:trigger];
    
    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
}

@end
