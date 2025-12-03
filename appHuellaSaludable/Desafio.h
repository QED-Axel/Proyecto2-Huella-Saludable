//
//  Desafio.h
//  appHuellaSaludable
//
//  Created by Manolo Mijares Lara on 03/12/25.
//


#import <Foundation/Foundation.h>

@interface Desafio : NSObject <NSCoding> // También necesitamos guardarlos

@property (nonatomic, strong) NSString *titulo;
@property (nonatomic, strong) NSString *descripcion;
@property (nonatomic, assign) BOOL estaCompletado;

- (instancetype)initWithTitulo:(NSString *)titulo descripcion:(NSString *)descripcion;

// Método de clase para generar una lista rápida de retos
+ (NSArray<Desafio *> *)obtenerDesafiosSemanales;

@end