//
//  GestorDeHabitos.h
//  appHuellaSaludable
//
//  Created by Manolo Mijares Lara on 03/12/25.
//


//
//  GestorDeHabitos.h
//  ProyectoEcologia
//
//  Encargado de la lógica de negocio y persistencia de datos (Singleton).
//

#import <Foundation/Foundation.h>
#import "Habito.h"
#import "Desafio.h"

@interface GestorDeHabitos : NSObject

// Propiedades de acceso público (solo lectura para proteger la integridad)
@property (nonatomic, strong, readonly) NSMutableArray<Habito *> *listaHabitos;
@property (nonatomic, strong, readonly) NSMutableArray<Desafio *> *listaDesafios;

// Método de clase para acceder a la instancia única (Singleton)
+ (instancetype)sharedInstance;

// --- Métodos para gestión de HÁBITOS ---
- (void)agregarHabito:(Habito *)nuevoHabito;
- (void)eliminarHabitoEnIndice:(NSUInteger)indice;
- (double)calcularHuellaTotal;

// --- Métodos para gestión de DESAFÍOS ---
// Marca un desafío como completado y guarda el cambio
- (void)completarDesafioEnIndice:(NSUInteger)indice;

// Reinicia los desafíos (útil para pruebas o inicio de semana)
- (void)cargarDesafiosIniciales;

// Metodo para la grafica
- (NSArray<NSNumber *> *)obtenerHistorialImpactoUltimos7Dias;

// Metodo para notificaciones
- (void)programarNotificacionesLocales;
@end
