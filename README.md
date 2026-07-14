# Habio

Habio es una app mobile para crear y seguir hábitos diarios, combinada con un temporizador de enfoque Pomodoro. Desarrollada con Flutter.

## Características

- **Gestión de hábitos**: crea hábitos con frecuencia personalizada (todos los días, entre semana, fin de semana o días específicos)
- **Historial de 30 días**: seguimiento visual del progreso con porcentajes diarios
- **Temporizador de enfoque**: sesiones cronometradas con registro automático en el historial
- **Notificaciones y recordatorios**: alertas programadas para no perder un hábito
- **Categorías visuales**: organización por colores (Estudio, Trabajo, Salud, Personal)
- **Soft delete**: los hábitos borrados se conservan en el historial para mantener el registro de días pasados
- **Modo inactivo**: pausa hábitos sin perder su historial
- **Sin anuncios**: compra integrada para remover publicidad

## Stack técnico

- **Framework**: Flutter (Dart)
- **Estado**: Riverpod
- **Almacenamiento local**: Hive (NoSQL embebido)
- **Notificaciones**: flutter_local_notifications + Android AlarmManager nativo
- **Compra in-app**: in_app_purchase
- **Testing**: flutter_test (100+ tests)
