# Inventory - Widget Tests

## 1. Resultados de Ejecucion

### 1.1. Salida de Consola

```
00:00 +0: LoteCard renderizado debe renderizar lote vigente correctamente
00:00 +1: ProductCard renderizado debe renderizar correctamente con producto completo
00:00 +2: ProductCard renderizado debe renderizar correctamente con producto completo
00:00 +3: ProductCard renderizado debe renderizar correctamente con producto completo
00:00 +4: ProductCard renderizado debe renderizar correctamente con producto completo
00:00 +5: ProductCard renderizado debe renderizar correctamente con producto completo
00:00 +6: LoteCard interaccion debe llamar a onDelete cuando se presiona el boton de eliminar
00:00 +7: ProductCard renderizado debe mostrar etiqueta Stock Bajo cuando stockActual <= stockMinimo
00:00 +8: LoteCard estados debe mostrar botones de acciones cuando los callbacks estan definidos
00:00 +9: ProductCard renderizado no debe mostrar codigo cuando es null
00:00 +10: LoteCard estados no debe mostrar botones de acciones cuando los callbacks son null
00:00 +11: ProductCard renderizado no debe mostrar etiqueta Stock Bajo cuando stockActual > stockMinimo
00:01 +12: ProductCard interaccion debe llamar a onTap cuando se presiona la card
00:01 +13: ProductCard interaccion debe llamar a onEdit cuando se presiona el boton de editar
00:01 +14: ProductCard interaccion debe llamar a onDelete cuando se presiona el boton de eliminar
00:01 +15: ProductCard estados debe mostrar botones de acciones cuando los callbacks estan definidos
00:01 +16: ProductCard estados no debe mostrar botones de acciones cuando los callbacks son null
00:01 +17: All tests passed!
```

### 1.2. Resumen de Resultados

| Concepto | Cantidad |
|----------|----------|
| Total | 17 |
| Exitosas | 17 |
| Fallidas | 0 |

### 1.3. Desglose por Tipo

| Tipo | Tests | Exitosos |
|------|-------|----------|
| Renderizado | 7 | 7 |
| Interaccion | 6 | 6 |
| Estados | 4 | 4 |

## 2. Tests Ejecutados

### 2.1. ProductCard (11 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | testWidgets | debe renderizar correctamente con producto completo | Renderizado |
| 2 | testWidgets | debe mostrar etiqueta Stock Bajo cuando stockActual <= stockMinimo | Renderizado |
| 3 | testWidgets | no debe mostrar codigo cuando es null | Renderizado |
| 4 | testWidgets | no debe mostrar etiqueta Stock Bajo cuando stockActual > stockMinimo | Renderizado |
| 5 | testWidgets | debe llamar a onTap cuando se presiona la card | Interaccion |
| 6 | testWidgets | debe llamar a onEdit cuando se presiona el boton de editar | Interaccion |
| 7 | testWidgets | debe llamar a onDelete cuando se presiona el boton de eliminar | Interaccion |
| 8 | testWidgets | debe mostrar botones de acciones cuando los callbacks estan definidos | Estados |
| 9 | testWidgets | no debe mostrar botones de acciones cuando los callbacks son null | Estados |

### 2.2. LoteCard (8 tests)

| # | Metodo | Descripcion | Tipo |
|---|--------|-------------|------|
| 1 | testWidgets | debe renderizar lote vigente correctamente | Renderizado |
| 2 | testWidgets | debe mostrar estado Proximo a Vencer cuando faltan <= 30 dias | Renderizado |
| 3 | testWidgets | debe mostrar estado Vencido cuando la fecha ya paso | Renderizado |
| 4 | testWidgets | debe llamar a onTap cuando se presiona la card | Interaccion |
| 5 | testWidgets | debe llamar a onEdit cuando se presiona el boton de editar | Interaccion |
| 6 | testWidgets | debe llamar a onDelete cuando se presiona el boton de eliminar | Interaccion |
| 7 | testWidgets | debe mostrar botones de acciones cuando los callbacks estan definidos | Estados |
| 8 | testWidgets | no debe mostrar botones de acciones cuando los callbacks son null | Estados |

## 3. Metodos Evaluados

| Metodo | Renderizado | Interaccion | Estados |
|--------|------------|-------------|---------|
| ProductCard | si | si | si |
| LoteCard | si | si | si |

## 4. Interpretacion

Los widgets de Inventory fueron testeados con 17 pruebas que cubren:

**ProductCard (9 tests):**
- **Renderizado**: Se verifico la visualizacion correcta de nombre, codigo, precio y stock. Se valido la etiqueta "Stock Bajo" cuando `stockActual <= stockMinimo`, y que se oculta cuando no corresponde. Se confirmo que el codigo no se muestra cuando es null.
- **Interaccion**: Se validaron los callbacks `onTap`, `onEdit` y `onDelete`.
- **Estados**: Se comprobo que los botones de accion se muestran/ocultan segun los callbacks definidos.

**LoteCard (8 tests):**
- **Renderizado**: Se verificaron los 3 estados de vencimiento (Vigente, Proximo a Vencer, Vencido) con sus respectivos textos y colores.
- **Interaccion**: Se validaron los callbacks `onTap`, `onEdit` y `onDelete`.
- **Estados**: Se comprobo que los botones de accion se muestran/ocultan segun los callbacks definidos.

## 5. Conclusiones

Los widgets de Inventory tienen una cobertura completa de pruebas que validan:

1. Todos los estados visuales de ProductCard (stock bajo, sin codigo, con codigo)
2. Todos los estados de vencimiento de LoteCard (vigente, proximo a vencer, vencido)
3. Todos los callbacks de interaccion funcionan correctamente
4. Los botones de accion se muestran condicionalmente segun los callbacks

**Recomendaciones:**
- Considerar agregar tests para validar el formato de precio con diferentes valores
- Podrian agregarse tests para LoteCard con cantidadActual = 0
- Seria util probar el comportamiento de ProductCard con imagenes