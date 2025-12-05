//
//  Desafio.m
//  appHuellaSaludable
//
//  
//


#import "Desafio.h"

@implementation Desafio

// Claves para guardar en disco
static NSString *const kTituloKey = @"Titulo";
static NSString *const kDescKey = @"Descripcion";
static NSString *const kCompletadoKey = @"Completado";

- (instancetype)initWithTitulo:(NSString *)titulo descripcion:(NSString *)descripcion {
    self = [super init];
    if (self) {
        _titulo = titulo;
        _descripcion = descripcion;
        _estaCompletado = NO;
    }
    return self;
}

// Generamos datos "dummy" para que la app no empiece vacía
+ (NSArray<Desafio *> *)obtenerDesafiosSemanales {
    return @[
        [[Desafio alloc] initWithTitulo:@"Sin Plásticos" descripcion:@"Evita usar botellas o bolsas de plástico por 3 días."],
        [[Desafio alloc] initWithTitulo:@"Transporte Verde" descripcion:@"Usa bicicleta o camina a tu destino 2 veces esta semana."],
        [[Desafio alloc] initWithTitulo:@"Desconexión Total" descripcion:@"Desconecta aparatos electrónicos al dormir durante 5 días."],
        [[Desafio alloc] initWithTitulo:@"Ducha Rápida" descripcion:@"Báñate en menos de 5 minutos durante toda la semana."],
        [[Desafio alloc] initWithTitulo:@"Día sin Carne" descripcion:@"Intenta llevar una dieta vegetariana por un día completo para reducir emisiones."],
        [[Desafio alloc] initWithTitulo:@"Luz Natural" descripcion:@"Mantén las luces apagadas y usa solo luz solar hasta que anochezca."],
        [[Desafio alloc] initWithTitulo:@"Modo Eco" descripcion:@"Lava tu ropa usando agua fría y sécala al sol en lugar de usar secadora."],
        [[Desafio alloc] initWithTitulo:@"Termo Propio" descripcion:@"Lleva tu propia taza o termo si compras café para evitar vasos desechables."],
        [[Desafio alloc] initWithTitulo:@"Cero Desperdicio" descripcion:@"Planifica tus comidas para no tirar nada de comida a la basura esta semana."]
    ];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_titulo forKey:kTituloKey];
    [aCoder encodeObject:_descripcion forKey:kDescKey];
    [aCoder encodeBool:_estaCompletado forKey:kCompletadoKey];
}

- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _titulo = [aDecoder decodeObjectForKey:kTituloKey];
        _descripcion = [aDecoder decodeObjectForKey:kDescKey];
        _estaCompletado = [aDecoder decodeBoolForKey:kCompletadoKey];
    }
    return self;
}

@end
