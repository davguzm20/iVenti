# Sales - Widget Tests

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: cart_item_widget_test: CartItemWidget renderizado debe renderizar correctamente
00:00 +1: CartWidget renderizado debe mostrar mensaje cuando la lista esta vacia
00:01 +5: CartWidget renderizado debe mostrar items del carrito
00:01 +6: CartWidget renderizado debe mostrar el total correctamente
00:01 +7: CartWidget renderizado debe mostrar boton Confirmar
00:01 +8: CartWidget renderizado debe mostrar boton Agregar producto cuando onAddProduct esta definido
00:01 +9: CartWidget renderizado no debe mostrar boton Agregar producto cuando onAddProduct es null
00:01 +10: CartWidget interaccion debe llamar a onConfirm cuando se presiona el boton Confirmar
00:01 +11: CartWidget interaccion debe llamar a onDeleteItem con el indice correcto
00:01 +12: SaleCard renderizado debe renderizar venta al contado correctamente
00:02 +13: SaleCard renderizado debe renderizar venta a credito no cancelada
00:02 +14: SaleCard renderizado debe renderizar venta a credito cancelada
00:02 +15: SaleCard renderizado debe mostrar boton Detalles cuando onDetails esta definido
00:02 +16: SaleCard renderizado no debe mostrar boton Detalles cuando onDetails es null
00:02 +17: SaleCard interaccion debe llamar a onTap cuando se presiona la card
00:02 +18: SaleCard interaccion debe llamar a onDetails cuando se presiona el boton Detalles
00:02 +19: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 19 |
| Exitosas | 19 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Renderizado | 11 | 11 |
| Interaccion | 6 | 6 |
| Estados | 2 | 2 |

## 2. Tests Ejecutados

### 2.1. SaleCard (8 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | testWidgets | debe renderizar venta al contado correctamente | Renderizado |
| 2 | testWidgets | debe renderizar venta a credito no cancelada | Renderizado |
| 3 | testWidgets | debe renderizar venta a credito cancelada | Renderizado |
| 4 | testWidgets | debe mostrar boton Detalles cuando onDetails esta definido | Renderizado |
| 5 | testWidgets | no debe mostrar boton Detalles cuando onDetails es null | Estados |
| 6 | testWidgets | debe llamar a onTap cuando se presiona la card | Interaccion |
| 7 | testWidgets | debe llamar a onDetails cuando se presiona el boton Detalles | Interaccion |

### 2.2. CartItemWidget (4 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | testWidgets | debe renderizar correctamente con datos del producto | Renderizado |
| 2 | testWidgets | debe mostrar boton de eliminar cuando onDelete esta definido | Renderizado |
| 3 | testWidgets | no debe mostrar boton de eliminar cuando onDelete es null | Estados |
| 4 | testWidgets | debe llamar a onDelete cuando se presiona el boton de eliminar | Interaccion |

### 2.3. CartWidget (8 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | testWidgets | debe mostrar mensaje cuando la lista esta vacia | Renderizado |
| 2 | testWidgets | debe mostrar items del carrito | Renderizado |
| 3 | testWidgets | debe mostrar el total correctamente | Renderizado |
| 4 | testWidgets | debe mostrar boton Confirmar | Renderizado |
| 5 | testWidgets | debe mostrar boton Agregar producto cuando onAddProduct esta definido | Renderizado |
| 6 | testWidgets | no debe mostrar boton Agregar producto cuando onAddProduct es null | Estados |
| 7 | testWidgets | debe llamar a onConfirm cuando se presiona el boton Confirmar | Interaccion |
| 8 | testWidgets | debe llamar a onDeleteItem con el indice correcto | Interaccion |

## 3. Metodos Evaluados

| Metodo | Renderizado | Interaccion | Estados |
|--------|------------|-------------|---------|
| SaleCard | si | si | si |
| CartItemWidget | si | si | si |
| CartWidget | si | si | si |

## 4. Interpretacion

Los widgets de Sales fueron testeados con 19 pruebas que cubren:

**SaleCard (7 tests):**
- **Renderizado**: Se verificaron los 3 tipos de venta (al contado, credito no cancelado, credito cancelado). Se confirmo que el boton "Detalles" se muestra solo cuando `onDetails` esta definido.
- **Interaccion**: Se validaron los callbacks `onTap` y `onDetails`.
- **Estados**: Se comprobo la visibilidad condicional del boton Detalles.

**CartItemWidget (4 tests):**
- **Renderizado**: Se verifico la visualizacion de nombre, precio, cantidad y subtotal. Se confirmo que el boton de eliminar se muestra solo cuando `onDelete` esta definido.
- **Interaccion**: Se valido el callback `onDelete`.
- **Estados**: Se comprobo la visibilidad condicional del boton de eliminar.

**CartWidget (8 tests):**
- **Renderizado**: Se verifico el estado vacio con el mensaje "No hay productos agregados", la visualizacion de items, el total calculado, y los botones "Confirmar" y "Agregar producto" (este ultimo solo cuando el callback esta definido).
- **Interaccion**: Se validaron los callbacks `onConfirm` y `onDeleteItem` con el indice correcto.
- **Estados**: Se comprobo la visibilidad condicional del boton "Agregar producto".

## 5. Conclusiones

Los widgets de Sales tienen una cobertura completa de pruebas que validan:

1. SaleCard maneja correctamente los diferentes estados de pago con sus mensajes adecuados
2. CartItemWidget muestra correctamente la informacion del producto y permite eliminarlo
3. CartWidget maneja estados vacios y con items, mostrando totales y botones de accion
4. Los botones de accion se muestran condicionalmente segun los callbacks definidos
5. Los callbacks de interaccion funcionan correctamente en todos los widgets

**Recomendaciones:**
- Agregar tests para SaleCard con valores monetarios extremos o negativos
- Considerar tests para CartItemWidget con el callback `onQuantityChanged`
- Podrian agregarse tests para validar el formateo de precios con diferentes configuraciones regionales