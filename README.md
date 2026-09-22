# App Notas y Pagos 🚀

Una aplicación integral construida con Flutter para gestionar tus finanzas personales, organizar tus tarjetas de crédito y administrar tu espacio personal. Diseñada con una interfaz moderna, enfocada en brindarte total claridad sobre tus gastos y pagos.

## ✨ Características Principales

*   **Gestión de Tarjetas de Crédito:**
    *   Soporte para compras a Meses Sin Intereses (MSI), calculando automáticamente la fracción que te corresponde pagar cada mes.
    *   Separación inteligente de deuda: Distingue claramente entre tu **Corte Anterior (A Pagar)** y tu **Mes Actual (Acumulado)**.
    *   Opción de **"Saldado Rápido"** para registrar pagos exactos de cortes anteriores con un solo tap.
*   **Control de Suscripciones:**
    *   Registra tus servicios mensuales (Netflix, Internet, Gym, etc.).
    *   Generación automática de cargos en tus tarjetas según tus fechas de cobro.
*   **Dashboard Interactivo:**
    *   Visualiza alertas financieras (vencimientos, montos a pagar).
    *   Gestos intuitivos como "pull-to-refresh" para actualización instantánea.
    *   Accesos rápidos para registro de compras y pagos.
*   **Espacio Personal Seguro:**
    *   Gestor de contraseñas y notas privadas.
    *   Sección especial de "Notas de Amor" y próximos eventos.
*   **Persistencia de Datos:**
    *   Almacenamiento local ultrarrápido implementado con **Isar Database**.

## 🛠️ Tecnologías

*   **[Flutter](https://flutter.dev/)** - Framework de UI
*   **[Riverpod](https://riverpod.dev/)** - Gestión de estado escalable
*   **[Isar](https://isar.dev/)** - Base de datos local NoSQL
*   **[GoRouter](https://pub.dev/packages/go_router)** - Enrutamiento y navegación declarativa

## 🚀 Cómo Ejecutar el Proyecto

1. Clona este repositorio:
   ```bash
   git clone https://github.com/AntonioRM1022/App_Notas_Pagos.git
   ```
2. Instala las dependencias:
   ```bash
   flutter pub get
   ```
3. Ejecuta la aplicación en tu emulador o dispositivo:
   ```bash
   flutter run
   ```

## 🤝 Contribuciones
Este proyecto fue creado como una herramienta personal para llevar el control de finanzas de manera visualmente agradable y matemáticamente exacta, pero el repositorio es de código abierto. ¡Cualquier sugerencia o Pull Request es bienvenido!
