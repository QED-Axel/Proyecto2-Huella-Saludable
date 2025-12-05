# 🌱 Huella Saludable

**Huella Saludable** es una aplicación nativa para iOS desarrollada en **Objective-C** que ayuda a los usuarios a monitorear, analizar y reducir su impacto ambiental diario. A través de un sistema de registro de hábitos, cálculo de huella de carbono y desafíos ecológicos, la app incentiva un estilo de vida más sostenible.

> **Proyecto Académico:** Desarrollo de Aplicaciones Móviles en iOS.

---

## 📱 Características Principales

* **📊 Dashboard Interactivo:** Visualización en tiempo real del ahorro total de CO2 y gráficas de progreso semanal.
* **📝 Registro de Hábitos:** Interfaz intuitiva con `UIPickerView` para registrar actividades en categorías como *Transporte*, *Energía* y *Reciclaje*, con cálculos de impacto predefinidos.
* **🏆 Desafíos Semanales:** Sistema de "Checklist" con retos ecológicos (ej. "Día sin Carne", "Sin Plásticos") que persisten entre sesiones.
* **📉 Historial y Estadísticas:** Gráfica de barras personalizada (`UIView` custom drawing) que muestra el desempeño de los últimos 7 días.
* **💾 Persistencia de Datos:** Almacenamiento local seguro utilizando `NSCoding` y `NSKeyedArchiver` para mantener el historial y configuraciones del usuario.
* **⚡ Modo Demo (Simulación):** Herramienta de depuración para exposiciones que permite "viajar en el tiempo" (+1 día) para visualizar cambios en la gráfica y disparar notificaciones instantáneas.

---

## 🛠️ Arquitectura y Tecnologías

El proyecto sigue estrictamente el patrón de diseño **MVC (Modelo-Vista-Controlador)** para garantizar un código limpio y escalable.

* **Lenguaje:** Objective-C.
* **Frameworks:** UIKit, Foundation, UserNotifications.
* **Patrón Singleton:** Implementado en la clase `GestorDeHabitos` para centralizar la lógica de negocio y ser la única fuente de verdad (Source of Truth) de la app.
* **Persistencia:** Serialización de objetos (`Habito` y `Desafio`) a archivos binarios locales.

### Estructura de Clases Clave
* `GestorDeHabitos`: El "cerebro" de la app. Maneja los arrays de datos, cálculos matemáticos y operaciones de I/O (Guardar/Cargar).
* `Habito`: Modelo de datos que representa una acción sostenible con propiedades como nombre, categoría, impacto de carbono y fecha.
* `ViewController` (Dashboard): Se encarga de dibujar la gráfica manualmente basándose en los datos históricos.

---

## 🚀 Instalación y Uso

1.  **Clonar el repositorio:**
    ```bash
    git clone [https://github.com/tu-usuario/Proyecto2-Huella-Saludable.git](https://github.com/tu-usuario/Proyecto2-Huella-Saludable.git)
    ```
2.  **Abrir en Xcode:**
    Navega a la carpeta y abre el archivo `appHuellaSaludable.xcodeproj`.
3.  **Ejecutar:**
    Selecciona un simulador (ej. iPhone 15 o 16) y presiona `Cmd + R`.

### 🧪 Cómo probar el "Modo Demo" (Para Exposiciones)
La app incluye funciones ocultas para facilitar la demostración en vivo:
1.  **Registrar un Hábito:** Agrega una actividad hoy (aparecerá una barra a la derecha de la gráfica).
2.  **Presionar "Simular Día":**
    * La app avanzará su calendario interno 1 día al futuro.
    * Recibirás una notificación local inmediata.
    * La barra de la gráfica se desplazará a la izquierda (convirtiéndose en "ayer").
3.  **Botón de Reinicio:** Utiliza el botón rojo "Reiniciar App" en el Dashboard para borrar todos los datos y dejar la app como recién instalada.

---

## 📸 Capturas de Pantalla

| Dashboard | Registro | Desafíos | Historial |
|:---------:|:--------:|:--------:|:---------:|
| *(Inserta aquí tu captura)* | *(Inserta aquí tu captura)* | *(Inserta aquí tu captura)* | *(Inserta aquí tu captura)* |

---

## 📄 Créditos

Desarrollado por **Manolo Mijares Lara** y equipo.
*Materia de Desarrollo de Aplicaciones en iOS.*

---

## ⚖️ Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo [LICENSE](LICENSE) para más detalles.
