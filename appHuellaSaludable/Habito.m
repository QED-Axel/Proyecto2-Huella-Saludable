//
//  Habito.m
//  appHuellaSaludable
//
//  Created by Manolo Mijares Lara on 03/12/25.
//


#import "Habito.h"

@implementation Habito

// Definimos claves constantes para codificar y decodificar.
// Esto evita errores de dedo al escribir los nombres de las variables.
static NSString *const kNombreKey = @"Nombre";
static NSString *const kCategoriaKey = @"Categoria";
static NSString *const kImpactoKey = @"Impacto";
static NSString *const kFechaKey = @"Fecha";

// 1. Inicializador personalizado
- (instancetype)initWithNombre:(NSString *)nombre
                     categoria:(NSString *)categoria
                       impacto:(double)impacto {
    self = [super init];
    if (self) {
        _nombre = nombre;
        _categoria = categoria;
        _impactoCarbono = impacto;
        _fechaRegistro = [NSDate date]; // Se guarda la fecha y hora actual automáticamente
    }
    return self;
}

#pragma mark - NSCoding Protocol

// 2. Método para GUARDAR (Codificar)
// Este método se llama cuando queremos guardar el objeto en disco.
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_nombre forKey:kNombreKey];
    [aCoder encodeObject:_categoria forKey:kCategoriaKey];
    [aCoder encodeDouble:_impactoCarbono forKey:kImpactoKey]; // Nota: encodeDouble para números
    [aCoder encodeObject:_fechaRegistro forKey:kFechaKey];
}

// 3. Método para CARGAR (Decodificar)
// Este método se llama cuando recuperamos los datos del disco y recreamos el objeto.
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _nombre = [aDecoder decodeObjectForKey:kNombreKey];
        _categoria = [aDecoder decodeObjectForKey:kCategoriaKey];
        _impactoCarbono = [aDecoder decodeDoubleForKey:kImpactoKey];
        _fechaRegistro = [aDecoder decodeObjectForKey:kFechaKey];
    }
    return self;
}

@end