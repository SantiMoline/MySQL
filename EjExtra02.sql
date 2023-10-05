-- A continuación, se deben realizar las siguientes consultas sobre la base de datos:
-- Consultas sobre una tabla
-- 1. Devuelve un listado con el código de oficina y la ciudad donde hay oficinas.
SELECT codigo_oficina, ciudad FROM oficina;

-- 2. Devuelve un listado con la ciudad y el teléfono de las oficinas de España.
SELECT ciudad, telefono FROM oficina
WHERE pais = "España";

-- 3. Devuelve un listado con el nombre, apellidos y email de los empleados cuyo jefe tiene un código de jefe igual a 7.
SELECT nombre, apellido1, apellido2, email FROM empleado
WHERE codigo_jefe = 7;

-- 4. Devuelve el nombre del puesto, nombre, apellidos y email del jefe de la empresa.
SELECT puesto, nombre, apellido1, apellido2, email, codigo_jefe FROM empleado
WHERE codigo_jefe IS NULL;
-- Lo más facil era consultar por código de jefe null ya que si es el Jefe de la empresa, no tiene jefe.

-- 5. Devuelve un listado con el nombre, apellidos y puesto de aquellos empleados que no sean representantes de ventas.
SELECT nombre, apellido1, apellido2, puesto FROM empleado
WHERE puesto NOT LIKE "%ventas%";

-- 6. Devuelve un listado con el nombre de los todos los clientes españoles.
SELECT nombre_cliente, pais FROM cliente
WHERE pais = "Spain";

-- 7. Devuelve un listado con los distintos estados por los que puede pasar un pedido.
SELECT DISTINCT estado FROM pedido;

-- 8. Devuelve un listado con el código de cliente de aquellos clientes que realizaron algún pago en 2008.
-- Tenga en cuenta que deberá eliminar aquellos códigos de cliente que aparezcan repetidos. Resuelva la consulta:
-- o Utilizando la función YEAR de MySQL.
SELECT DISTINCT c.codigo_cliente FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE YEAR(p.fecha_pago) = 2008;


-- o Utilizando la función DATE_FORMAT de MySQL.
SELECT DISTINCT c.codigo_cliente FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE DATE_FORMAT(p.fecha_pago, "%Y") = "2008";

-- o Sin utilizar ninguna de las funciones anteriores.
SELECT DISTINCT c.codigo_cliente FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE EXTRACT(YEAR FROM p.fecha_pago) = 2008;

-- 9. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos que no han sido entregados a tiempo.
SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega FROM pedido p
WHERE p.fecha_entrega > p.fecha_esperada;

-- 10. Devuelve un listado con el código de pedido, código de cliente, fecha esperada y fecha de entrega de los pedidos
-- cuya fecha de entrega ha sido al menos dos días antes de la fecha esperada.
SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega FROM pedido p
WHERE p.fecha_entrega + 2 <= p.fecha_esperada;

-- o Utilizando la función ADDDATE de MySQL.
SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega FROM pedido p
WHERE ADDDATE(p.fecha_entrega, 2) <= p.fecha_esperada;

-- o Utilizando la función DATEDIFF de MySQL.
SELECT p.codigo_pedido, p.codigo_cliente, p.fecha_esperada, p.fecha_entrega FROM pedido p
WHERE DATEDIFF(p.fecha_esperada, p.fecha_entrega) >= 2;

-- 11. Devuelve un listado de todos los pedidos que fueron rechazados en 2009.
SELECT * FROM pedido
WHERE estado = "Rechazado" 
	AND YEAR(fecha_pedido) = 2009;

-- 12. Devuelve un listado de todos los pedidos que han sido entregados en el mes de enero de cualquier año.
SELECT * FROM pedido
WHERE MONTH(fecha_entrega) = 01;

-- 13. Devuelve un listado con todos los pagos que se realizaron en el año 2008 mediante Paypal. Ordene el resultado de mayor a menor.
SELECT * FROM pago 
WHERE YEAR(fecha_pago) = 2008 
	AND forma_pago = "Paypal";

-- 14. Devuelve un listado con todas las formas de pago que aparecen en la tabla pago. Tenga en cuenta que no deben aparecer formas de pago repetidas.
SELECT DISTINCT forma_pago FROM pago;

-- 15. Devuelve un listado con todos los productos que pertenecen a la gama Ornamentales y que tienen más de 100 unidades en stock.
-- El listado deberá estar ordenado por su precio de venta, mostrando en primer lugar los de mayor precio.
SELECT * FROM producto
WHERE gama = "Ornamentales" 
	AND cantidad_en_stock > 100
ORDER BY precio_venta DESC;

-- 16. Devuelve un listado con todos los clientes que sean de la ciudad de Madrid y cuyo representante de ventas tenga el código de empleado 11 o 30.
SELECT * FROM cliente 
WHERE ciudad = "Madrid" 
	AND (codigo_empleado_rep_ventas IN (11,30));

-- Consultas multitabla (Composición interna)
-- Las consultas se deben resolver con INNER JOIN.
-- 1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su representante de ventas.
SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2 FROM cliente c 
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas;

-- 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT c.nombre_cliente, e.nombre FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente 
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el nombre de sus representantes de ventas.
SELECT c.nombre_cliente, e.nombre FROM cliente c
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE NOT EXISTS 
	(SELECT p.codigo_cliente FROM pago p 
		WHERE(p.codigo_cliente = c.codigo_cliente));

-- 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, e.nombre AS nombre_representante, o.ciudad AS ciudad_oficina FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

-- 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, e.nombre, o.ciudad FROM cliente c
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o on e.codigo_oficina = o.codigo_oficina
WHERE NOT EXISTS 
	(SELECT p.codigo_cliente FROM pago p
		WHERE (p.codigo_cliente = c.codigo_cliente));

-- 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada.
SELECT DISTINCT o.codigo_oficina, o.linea_direccion1, o.linea_direccion2 FROM oficina o
INNER JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
INNER JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
	WHERE c.ciudad = "Fuenlabrada";

-- 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto con la ciudad de la oficina a la que pertenece el representante.
SELECT c.nombre_cliente, e.nombre, o.ciudad FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

-- 8. Devuelve un listado con el nombre de los empleados junto con el nombre de sus jefes.
SELECT e.nombre,e.codigo_empleado, e.codigo_jefe, f.nombre AS nombre_jefe FROM empleado e
INNER JOIN empleado f ON e.codigo_jefe = f.codigo_empleado;

-- 9. Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo un pedido.
SELECT DISTINCT c.nombre_cliente FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_entrega > p.fecha_esperada;

-- 10. Devuelve un listado de las diferentes gamas de producto que ha comprado cada cliente.
SELECT DISTINCT prod.gama, c.nombre_cliente FROM producto prod
INNER JOIN detalle_pedido d ON prod.codigo_producto = d.codigo_producto
INNER JOIN pedido p ON d.codigo_pedido = p.codigo_pedido
INNER JOIN cliente c on p.codigo_cliente = c.codigo_cliente;

-- Consultas multitabla (Composición externa)
-- Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN, JOIN.
-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT c.nombre_cliente FROM cliente c 
LEFT OUTER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

-- También se podía resolver con el NOT EXISTS que creo que facilita la lectura.
SELECT c.nombre_cliente FROM cliente c 
WHERE NOT EXISTS 
	(SELECT p.codigo_cliente FROM pago p
		WHERE c.codigo_cliente = p.codigo_cliente);

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pedido.
SELECT c.nombre_cliente FROM cliente c
LEFT OUTER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
	WHERE p.codigo_cliente IS NULL;
    
-- 3. Devuelve un listado que muestre los clientes que no han realizado ningún pago y los que no han realizado ningún pedido.
SELECT c.nombre_cliente FROM cliente c
LEFT OUTER JOIN pedido p on c.codigo_cliente = p.codigo_cliente
LEFT OUTER JOIN pago on pago.codigo_cliente = c.codigo_cliente
	WHERE (p.codigo_cliente IS NULL
		OR pago.codigo_cliente IS NULL);
-- Se usa OR para devolver un listado con ambas condiciones, aunque no se cumplan en simultáneo. Ya que dice "y" no "ni".

-- 4. Devuelve un listado que muestre solamente los empleados que no tienen una oficina asociada.
SELECT * FROM empleado e
LEFT OUTER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
	WHERE o.codigo_oficina IS NULL;

-- 5. Devuelve un listado que muestre solamente los empleados que no tienen un cliente asociado.
SELECT e.nombre FROM empleado e
LEFT OUTER JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
	WHERE c.codigo_empleado_rep_ventas IS NULL;

-- 6. Devuelve un listado que muestre los empleados que no tienen una oficina asociada y los que no tienen un cliente asociado.
SELECT e.nombre FROM empleado e
LEFT OUTER JOIN oficina o on e.codigo_oficina = o.codigo_oficina
LEFT OUTER JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
	WHERE (c.codigo_empleado_rep_ventas IS NULL 
		OR o.codigo_oficina IS NULL);
-- Se usa OR para devolver un listado con ambas condiciones, aunque no se cumplan en simultáneo. Ya que dice "y" no "ni".

-- 7. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT prod.codigo_producto, prod.nombre FROM producto prod
LEFT OUTER JOIN detalle_pedido dp ON prod.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;

-- 8. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra
-- de algún producto de la gama Frutales.

-- códigos de empleados que tuvieron ventas de productos de la gama frutales
SELECT DISTINCT c.codigo_empleado_rep_ventas FROM cliente c
INNER JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
INNER JOIN detalle_pedido d ON d.codigo_pedido = p.codigo_pedido
INNER JOIN producto prod ON d.codigo_producto = prod.codigo_producto
WHERE prod.gama = "Frutales"
ORDER BY codigo_empleado_rep_ventas ASC;

-- codigos de oficinas en las que trabajan los empleados que tuvieron ventas de la gama frutales.
SELECT DISTINCT o.codigo_oficina, o.ciudad FROM oficina o
INNER JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
INNER JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
INNER JOIN detalle_pedido d ON d.codigo_pedido = p.codigo_pedido
INNER JOIN producto prod ON d.codigo_producto = prod.codigo_producto
WHERE prod.gama = "Frutales"
GROUP BY o.codigo_oficina;

-- último intento de solución
SELECT DISTINCT o.codigo_oficina, o.ciudad FROM oficina o
WHERE o.codigo_oficina NOT IN 
	(SELECT DISTINCT o.codigo_oficina FROM oficina o
	INNER JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
	INNER JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
	INNER JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
	INNER JOIN detalle_pedido d ON d.codigo_pedido = p.codigo_pedido
	INNER JOIN producto prod ON d.codigo_producto = prod.codigo_producto
	WHERE prod.gama = "Frutales"
	GROUP BY o.codigo_oficina);


-- Da el mismo resultado que el de Richard hecho por chatGPT.
SELECT o.codigo_oficina AS 'Código oficina', o.ciudad AS 'Ciudad'
FROM oficina o
LEFT JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
LEFT JOIN (
    SELECT c.codigo_empleado_rep_ventas
    FROM cliente c
    JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
    JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
    JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
    WHERE pr.gama = 'Frutales'
) empleados_frutales ON e.codigo_empleado = empleados_frutales.codigo_empleado_rep_ventas
GROUP BY o.codigo_oficina
HAVING COUNT(empleados_frutales.codigo_empleado_rep_ventas) = 0;

-- 9. Devuelve un listado con los clientes que han realizado algún pedido, pero no han realizado ningún pago.
SELECT DISTINCT nombre_cliente FROM cliente c INNER JOIN pedido p ON p.codigo_cliente = c.codigo_cliente
LEFT OUTER JOIN pago ON pago.codigo_cliente = c.codigo_cliente
WHERE pago.codigo_cliente IS NULL;

-- 10. Devuelve un listado con los datos de los empleados que no tienen clientes asociados y el nombre de su jefe asociado.
SELECT * FROM empleado e 
INNER JOIN empleado e2 ON e.codigo_jefe = e2.codigo_empleado
LEFT OUTER JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
	WHERE c.codigo_empleado_rep_ventas IS NULL;

-- Consultas resumen
-- 1. ¿Cuántos empleados hay en la compañía?
SELECT COUNT(*) AS cantidad_empleados FROM empleado;

-- 2. ¿Cuántos clientes tiene cada país?
SELECT pais, COUNT(*) AS cantidad_clientes FROM cliente
GROUP BY pais;

-- 3. ¿Cuál fue el pago medio en 2009?
SELECT ROUND(AVG(total), 2) AS pago_promedio FROM pago 
WHERE YEAR(fecha_pago) = 2009; 

-- 4. ¿Cuántos pedidos hay en cada estado? Ordena el resultado de forma descendente por el número de pedidos.
SELECT estado, COUNT(*) AS cant_pedidos FROM pedido
GROUP BY estado
	ORDER BY cant_pedidos DESC;
    
-- 5. Calcula el precio de venta del producto más caro y más barato en una misma consulta.
SELECT nombre, precio_venta FROM producto p
WHERE precio_venta = 
	(SELECT MAX(precio_venta) FROM producto) 
	OR precio_venta = (SELECT MIN(precio_venta) FROM producto);

-- PARA CONSULTAR SÓLO EL MÁX Y MIN SIN TENER IDENTIFICADO QUÉ PRODUCTOS SON:
SELECT MAX(precio_venta), MIN(precio_venta) FROM producto;

-- 6. Calcula el número de clientes que tiene la empresa.
SELECT COUNT(*) AS cantidad_clientes FROM cliente;

-- 7. ¿Cuántos clientes tiene la ciudad de Madrid?
SELECT c.ciudad, COUNT(*) AS cantidad_clientes FROM cliente c
GROUP BY c.ciudad HAVING c.ciudad = "Madrid";

SELECT c.ciudad, COUNT(*) AS cantidad_clientes FROM cliente c
WHERE c.ciudad = "Madrid";

-- 8. ¿Calcula cuántos clientes tiene cada una de las ciudades que empiezan por M?
SELECT c.ciudad, COUNT(*) AS cantidad_clientes FROM cliente c
GROUP BY c.ciudad 
	HAVING c.ciudad LIKE "M%"
    ORDER BY cantidad_clientes DESC;

-- 9. Devuelve el nombre de los representantes de ventas y el número de clientes al que atiende cada uno.
SELECT e.nombre, COUNT(*) FROM cliente c 
INNER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
GROUP BY e.codigo_empleado;

-- 10. Calcula el número de clientes que no tiene asignado representante de ventas.
SELECT COUNT(*) AS cant_clientes_sin_rep FROM cliente c
LEFT OUTER JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_empleado_rep_ventas IS NULL;

-- 11. Calcula la fecha del primer y último pago realizado por cada uno de los clientes. El listado deberá mostrar el nombre y los apellidos de cada cliente.
SELECT c.nombre_cliente, 
DATE_FORMAT(MIN(p.fecha_pago), "%d/%m/%Y") AS primer_pago,
DATE_FORMAT(MAX(p.fecha_pago), "%d/%m/%Y") AS ultimo_pago 
FROM cliente c
	INNER JOIN pago p ON p.codigo_cliente = c.codigo_cliente
		GROUP BY c.nombre_cliente;

-- 12. Calcula el número de productos diferentes que hay en cada uno de los pedidos.
SELECT codigo_pedido, COUNT(*) AS distintos_productos FROM detalle_pedido
GROUP BY codigo_pedido;

-- 13. Calcula la suma de la cantidad total de todos los productos que aparecen en cada uno de los pedidos.
SELECT codigo_pedido, SUM(cantidad) AS cantidad_total_productos FROM detalle_pedido
GROUP BY codigo_pedido;

-- 14. Devuelve un listado de los 20 productos más vendidos y el número total de unidades que se han vendido de cada uno. El listado deberá estar ordenado por el número total de unidades vendidas.
SELECT p.nombre, SUM(det.cantidad) AS cantidad_total_vendida FROM detalle_pedido det
INNER JOIN producto p ON p.codigo_producto = det.codigo_producto
	GROUP BY p.nombre
		ORDER BY cantidad_total_vendida DESC
			LIMIT 20;
            
-- 15. La facturación que ha tenido la empresa en toda la historia, indicando la base imponible, el IVA y el total facturado.
-- La base imponible se calcula sumando el coste del producto por el número de unidades vendidas de la tabla detalle_pedido.
-- El IVA es el 21 % de la base imponible, y el total la suma de los dos campos anteriores.
SELECT SUM(det.cantidad * det.precio_unidad) AS base_imponible,
(SUM(det.cantidad * det.precio_unidad) * 0.21) AS IVA,
(SUM(det.cantidad * det.precio_unidad) + (SUM(det.cantidad * det.precio_unidad) * 0.21)) AS total
FROM detalle_pedido det;

-- 16. La misma información que en la pregunta anterior, pero agrupada por código de producto.
SELECT det.codigo_producto, SUM(det.cantidad * det.precio_unidad) AS base_imponible,
(SUM(det.cantidad * det.precio_unidad) * 0.21) AS IVA,
(SUM(det.cantidad * det.precio_unidad) + (SUM(det.cantidad * det.precio_unidad) * 0.21)) AS total
FROM detalle_pedido det
	GROUP BY det.codigo_producto
		ORDER BY total DESC;

-- 17. La misma información que en la pregunta anterior, pero agrupada por código de producto filtrada por los códigos que empiecen por OR.
SELECT det.codigo_producto, SUM(det.cantidad * det.precio_unidad) AS base_imponible,
(SUM(det.cantidad * det.precio_unidad) * 0.21) AS IVA,
(SUM(det.cantidad * det.precio_unidad) + (SUM(det.cantidad * det.precio_unidad) * 0.21)) AS total
FROM detalle_pedido det
	GROUP BY det.codigo_producto
		HAVING det.codigo_producto LIKE "OR%"
		ORDER BY total DESC;
        
-- 18. Lista las ventas totales de los productos que hayan facturado más de 3000 euros. Se mostrará el nombre, unidades vendidas, total facturado y total facturado con impuestos (21% IVA)
SELECT p.nombre, SUM(det.cantidad) AS unidades_vendidas, 
SUM(det.cantidad * det.precio_unidad) AS base_imponible,
(SUM(det.cantidad * det.precio_unidad) * 0.21) AS IVA,
(SUM(det.cantidad * det.precio_unidad) + (SUM(det.cantidad * det.precio_unidad) * 0.21)) AS total
FROM detalle_pedido det
INNER JOIN producto p ON p.codigo_producto = det.codigo_producto
	GROUP BY p.nombre
		HAVING total > 3000
		ORDER BY total DESC;
        
-- Subconsultas con operadores básicos de comparación
-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
SELECT nombre_cliente FROM cliente
WHERE limite_credito = (SELECT MAX(limite_credito) FROM cliente);

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT nombre FROM producto
WHERE precio_venta = (SELECT MAX(precio_venta) FROM producto);

-- 3. Devuelve el nombre del producto del que se han vendido más unidades. (Tenga en cuenta que tendrá que calcular cuál es el número total
-- de unidades que se han vendido de cada producto a partir de los datos de la tabla detalle_pedido.
-- Una vez que sepa cuál es el código del producto, puede obtener su nombre fácilmente.)
SELECT p.nombre FROM producto p
INNER JOIN
	(SELECT d.codigo_producto, SUM(d.cantidad) AS cantidad_vendida FROM detalle_pedido d
		GROUP BY d.codigo_producto 
        ORDER BY cantidad_vendida
        DESC LIMIT 1) AS maximo 
ON p.codigo_producto = maximo.codigo_producto;

-- 4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN).
SELECT c.codigo_cliente, c.nombre_cliente FROM cliente c, pago p
WHERE c.codigo_cliente = p.codigo_cliente 
	AND c.limite_credito > (SELECT SUM(p.total) AS total_pagado FROM pago p
		WHERE c.codigo_cliente = p.codigo_cliente);

-- 5. Devuelve el producto que más unidades tiene en stock.
SELECT p.nombre FROM producto p
WHERE p.cantidad_en_stock = 
	(SELECT MAX(cantidad_en_stock) FROM producto);
    
-- 6. Devuelve el producto que menos unidades tiene en stock.
SELECT p.nombre FROM producto p
WHERE p.cantidad_en_stock = 
	(SELECT MIN(cantidad_en_stock) FROM producto);
    
-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.
SELECT e.nombre, e.apellido1, e.apellido2 FROM empleado e
	WHERE e.codigo_jefe = 
		(SELECT e2.codigo_empleado FROM empleado e2
			WHERE e2.nombre = "Alberto" 
            AND e2.apellido1 = "Soria");

-- Subconsultas con ALL y ANY
-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
SELECT c.nombre_cliente FROM cliente c
WHERE c.limite_credito >= ALL (SELECT limite_credito FROM cliente);

-- La variante que veníamos usando era esta:
SELECT nombre_cliente FROM cliente
ORDER BY limite_credito DESC
LIMIT 1;

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT p.nombre FROM producto p
WHERE p.precio_venta >= ALL (SELECT precio_venta FROM producto);

-- La variante que veníamos usando era esta:
SELECT p.nombre FROM producto p
ORDER BY p.precio_venta DESC 
LIMIT 1;

-- 3. Devuelve el producto que menos unidades tiene en stock.
SELECT p.nombre FROM producto p
WHERE p.cantidad_en_stock <= ALL (SELECT cantidad_en_stock FROM producto);

-- Subconsultas con IN y NOT IN
-- 1. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.
SELECT e.nombre, e.apellido1, e.apellido2, e.puesto FROM empleado e
WHERE e.codigo_empleado NOT IN (SELECT codigo_empleado_rep_ventas FROM cliente);

-- 2. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT c.codigo_cliente, c.nombre_cliente FROM cliente c
WHERE c.codigo_cliente NOT IN (SELECT codigo_cliente FROM pago);

-- 3. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago.
SELECT c.codigo_cliente, c.nombre_cliente FROM cliente c
WHERE c.codigo_cliente IN (SELECT codigo_cliente FROM pago);

-- 4. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT * FROM producto p
WHERE p.codigo_producto NOT IN (SELECT codigo_producto FROM detalle_pedido);

-- 5. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente.
SELECT e.nombre, e.apellido1, e.apellido2, e.puesto, o.telefono FROM empleado e, oficina o
WHERE e.codigo_oficina = o.codigo_oficina 
AND e.codigo_empleado NOT IN 
	(SELECT codigo_empleado_rep_ventas FROM cliente); 
    
-- Subconsultas con EXISTS y NOT EXISTS
-- 1. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
SELECT * FROM cliente c
WHERE NOT EXISTS (SELECT * FROM pago p WHERE c.codigo_cliente = p.codigo_cliente);


-- 2. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
SELECT * FROM cliente c
WHERE EXISTS (SELECT * FROM pago p WHERE c.codigo_cliente = p.codigo_cliente);

-- 3. Devuelve un listado de los productos que nunca han aparecido en un pedido.
SELECT * FROM producto p
WHERE NOT EXISTS 
(SELECT * FROM detalle_pedido det 
	WHERE det.codigo_producto = p.codigo_producto);
    
-- 4. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.
SELECT * FROM producto p
WHERE  EXISTS 
(SELECT * FROM detalle_pedido det 
	WHERE det.codigo_producto = p.codigo_producto)