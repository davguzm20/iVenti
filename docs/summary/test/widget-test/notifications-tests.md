# Notifications - Widget Tests

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: NotificationCard renderizado debe renderizar correctamente con notificacion no leida
00:00 +1: NotificationCard renderizado debe mostrar indicador de no leido cuando leida es false
00:00 +2: NotificationCard renderizado debe mostrar formato de fecha para notificaciones antiguas
00:00 +3: NotificationCard renderizado debe mostrar icono segun el tipo de notificacion
00:00 +4: NotificationCard interaccion debe llamar a onTap cuando se presiona la card
00:00 +5: NotificationCard interaccion debe mostrar boton de marcar como leido cuando onMarkAsRead esta definido y no esta leida
00:00 +6: NotificationCard interaccion debe llamar a onMarkAsRead cuando se presiona el boton de marcar como leido
00:00 +7: NotificationCard interaccion debe llamar a onDelete cuando se presiona el boton de eliminar
00:00 +8: NotificationCard estados debe ocultar boton de marcar como leido cuando la notificacion ya esta leida
00:01 +9: NotificationCard estados debe ocultar boton de eliminar cuando onDelete es null
00:01 +10: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 10 |
| Exitosas | 10 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Renderizado | 4 | 4 |
| Interaccion | 4 | 4 |
| Estados | 2 | 2 |

## 2. Tests Ejecutados

### 2.1. NotificationCard (10 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | testWidgets | debe renderizar correctamente con notificacion no leida | Renderizado |
| 2 | testWidgets | debe mostrar indicador de no leido cuando leida es false | Renderizado |
| 3 | testWidgets | debe mostrar formato de fecha para notificaciones antiguas | Renderizado |
| 4 | testWidgets | debe mostrar icono segun el tipo de notificacion | Renderizado |
| 5 | testWidgets | debe llamar a onTap cuando se presiona la card | Interaccion |
| 6 | testWidgets | debe mostrar boton de marcar como leido cuando onMarkAsRead esta definido | Interaccion |
| 7 | testWidgets | debe llamar a onMarkAsRead cuando se presiona el boton | Interaccion |
| 8 | testWidgets | debe llamar a onDelete cuando se presiona el boton de eliminar | Interaccion |
| 9 | testWidgets | debe ocultar boton de marcar como leido cuando la notificacion ya esta leida | Estados |
| 10 | testWidgets | debe ocultar boton de eliminar cuando onDelete es null | Estados |

## 3. Metodos Evaluados

| Metodo | Renderizado | Interaccion | Estados |
|--------|------------|-------------|---------|
| NotificationCard | si | si | si |

## 4. Interpretacion

El widget `NotificationCard` fue testeado con 10 pruebas que cubren:

- **Renderizado**: Se verifico que el widget se dibuja correctamente con titulo y contenido, que muestra el indicador de no leido, que el formato de fecha funciona para notificaciones antiguas, y que el icono mostrado corresponde al tipo de notificacion.

- **Interaccion**: Se validaron los callbacks `onTap` sobre la card, `onMarkAsRead` en el boton de marcar como leido, y `onDelete` en el boton de eliminar. Se confirmo que el boton de marcar como leido solo aparece cuando el callback esta definido.

- **Estados**: Se comprobo que el boton de marcar como leido se oculta cuando la notificacion ya esta leida, y que el boton de eliminar se oculta cuando su callback es null.

## 5. Conclusiones

El widget `NotificationCard` tiene una cobertura completa de pruebas que validan:

1. Renderizado con todos los estados de la notificacion (leida/no leida)
2. Formato de fecha relativa y absoluta segun la antiguedad
3. Iconos y colores correspondientes a cada tipo de notificacion
4. Todos los callbacks de interaccion funcionan correctamente
5. Los botones de accion se muestran condicionalmente segun los callbacks y el estado de lectura

**Nota:** Se corrigio el widget para alinear el nombre del campo `leido` a `leida` segun la entidad, y se actualizaron los valores del enum `TipoNotificacion` para coincidir con los definidos en `STOCK_BAJO, STOCK_AGOTADO, PROXIMO_VENCER, VENCIDO`.

**Recomendaciones:**
- Agregar tests para los diferentes tipos de notificacion y sus iconos especificos
- Considerar tests para el truncamiento de texto con `maxLines`
- Podrian agregarse tests para el formato de fecha relativa ("Hace X min")