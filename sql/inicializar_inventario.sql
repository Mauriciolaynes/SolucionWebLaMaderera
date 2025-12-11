-- ========================================
-- SCRIPT: Inicializar Inventario
-- Crea registros en almacen_producto para productos existentes
-- ========================================

-- PASO 1: Verificar que existe el almacén principal
SELECT * FROM almacen WHERE id_almacen = 1;

-- Si NO existe, crearlo:
INSERT INTO almacen (id_almacen, nombre, ubicacion, descripcion) 
VALUES (1, 'Almacén Principal', 'Bodega Central', 'Almacén principal de La Maderera')
ON DUPLICATE KEY UPDATE nombre = nombre; -- No hace nada si ya existe

-- PASO 2: Ver qué productos tienes actualmente
SELECT id_producto, codigo, nombre, precio_venta 
FROM producto 
WHERE estado = 1
ORDER BY nombre;

-- PASO 3: Inicializar stock para TODOS los productos existentes
-- Esto crea un registro en almacen_producto con stock inicial = 0
INSERT INTO almacen_producto (id_almacen, id_producto, stock_actual, stock_minimo, fecha_actualizacion)
SELECT 
    1 as id_almacen,                    -- Almacén principal
    p.id_producto,                       -- ID del producto
    0 as stock_actual,                   -- Stock inicial en 0 (puedes cambiarlo)
    10 as stock_minimo,                  -- Stock mínimo sugerido
    NOW() as fecha_actualizacion
FROM producto p
WHERE p.estado = 1                       -- Solo productos activos
AND NOT EXISTS (                         -- Solo si NO existe ya en almacen_producto
    SELECT 1 
    FROM almacen_producto ap 
    WHERE ap.id_almacen = 1 
    AND ap.id_producto = p.id_producto
);

-- PASO 4: Verificar que se crearon los registros
SELECT 
    p.codigo,
    p.nombre,
    ap.stock_actual,
    ap.stock_minimo
FROM almacen_producto ap
INNER JOIN producto p ON ap.id_producto = p.id_producto
WHERE ap.id_almacen = 1
ORDER BY p.nombre;

-- PASO 5 (OPCIONAL): Si quieres dar stock inicial a productos específicos
-- Ejemplo: Dar 100 unidades al producto con ID 1
UPDATE almacen_producto 
SET stock_actual = 100, 
    fecha_actualizacion = NOW()
WHERE id_almacen = 1 
AND id_producto = 1; -- Cambia este ID según necesites

-- PASO 6 (OPCIONAL): Inicializar con stock diferente de cero
-- Si prefieres que todos empiecen con stock, modifica el INSERT:
/*
INSERT INTO almacen_producto (id_almacen, id_producto, stock_actual, stock_minimo, fecha_actualizacion)
SELECT 
    1, 
    p.id_producto, 
    50 as stock_actual,      -- <-- CAMBIAR: Stock inicial para todos
    10 as stock_minimo, 
    NOW()
FROM producto p
WHERE p.estado = 1
AND NOT EXISTS (
    SELECT 1 FROM almacen_producto ap 
    WHERE ap.id_almacen = 1 AND ap.id_producto = p.id_producto
);
*/

-- VERIFICACIÓN FINAL
-- Productos SIN stock en almacén (deberían estar todos ahora)
SELECT p.id_producto, p.nombre
FROM producto p
WHERE p.estado = 1
AND NOT EXISTS (
    SELECT 1 FROM almacen_producto ap 
    WHERE ap.id_almacen = 1 AND ap.id_producto = p.id_producto
);
-- Este query NO debe retornar nada si todo está bien
