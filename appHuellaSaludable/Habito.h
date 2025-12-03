// Habito.h
#import <Foundation/Foundation.h>

@interface Habito : NSObject <NSCoding> // NSCoding es vital para guardar en almacenamiento local

@property (nonatomic, strong) NSString *nombre;
@property (nonatomic, strong) NSString *categoria; // Ej: "Energía", "Transporte"
@property (nonatomic, assign) double impactoCarbono; // En kg de CO2
@property (nonatomic, strong) NSDate *fechaRegistro;

// Inicializador personalizado
- (instancetype)initWithNombre:(NSString *)nombre
                     categoria:(NSString *)categoria
                       impacto:(double)impacto;

@end
