--1)
-- id, nombre y telefono de los empleados que no tienen contacto de emergencia medica cargados correctamente


SELECT id, nombre, telefono 
FROM 
(SELECT i.id AS id_inf_medica 
FROM informacion_medica AS i 
WHERE i.contacto_emergencia IS NULL 
OR i.contacto_emergencia = 'cargar@despues.com') AS c
JOIN empleado 
ON id_inf_medica = inf_medica
;

-- debido a que la utilización de subconsultas hace menos legible el código y perjudican el rendimiento del motor
-- de bases de datos y el mantenimiento, se corrige la consulta de la siguiente forma:

--SELECT e.id, e.nombre, e.telefono 
--FROM empleado AS e
--JOIN informacion_medica AS i ON e.inf_medica = i.id
--WHERE i.contacto_emergencia IS NULL 
--   OR i.contacto_emergencia = 'cargar@despues.com';

-- de esta manera se trabaja directamente entre tablas empleado e informacion_medica uniendolas con JOIN y condicionandolas 
-- mediante una simple sentencia WHERE


--2)
-- informacion de contacto de los clientes mayores de 50 años y clientes que hayan realizado compras de productos de tipo Tercera Edad



SELECT id AS id_cliente, nombre AS nombre_cliente, telefono AS telefono_cliente
FROM (
SELECT * 
FROM cliente WHERE date_part('year', age(fecha_nac)) > 50) AS clientes_mayores_de_50_anhos
UNION
SELECT c.id AS id_cliente, c.nombre AS nombre_cliente, c.telefono AS telefono_cliente
FROM cliente AS c 
JOIN venta AS v 
ON c.id = v.cliente 
JOIN  producto AS p 
ON v.producto = p.id
WHERE p.tipo = 'Tercera edad'
;



--3)
-- cantidad de ventas de tipo perfume hechas en el año actual y precio promedio que se dio entre todas las tiendas donde se vendieron



SELECT COUNT(*) AS cantidad_de_compras, ROUND(AVG(p.precio)) AS promedio_precio
FROM venta AS v 
JOIN producto AS p 
ON v.producto = p.id
WHERE tipo = 'Perfume' 
AND date_part('year', fecha) = date_part('year', current_timestamp)
;




--4)
--empleados que tienen factor de grupo sanguineo O- enlistados de forma ascendente por tienda y nombre



SELECT i.id AS id_informacion_medica, nombre AS nombre_empleado, id_tienda
FROM informacion_medica AS i
JOIN empleado 
ON i.id = inf_medica
WHERE i.grupo_sanguineo = 'O-'
ORDER BY nombre, id_tienda ASC
;



--5)
-- camisas cuyo precio superan los $800 y que no fueron vendidas en el mes de octubre




SELECT p.nombre AS nombre_camisa, date(v.fecha) AS fecha_venta, p.precio AS precio_venta, p.id AS id_tienda
FROM venta AS v 
JOIN producto AS p 
ON v.producto = p.id
WHERE tipo = 'Camisa' 
AND precio > 800
EXCEPT
SELECT p.nombre AS nombre_camisa, date(v.fecha) AS fecha_venta, p.precio AS precio_venta, p.id AS id_tienda
FROM venta AS v 
JOIN producto AS p 
ON v.producto = p.id
WHERE tipo = 'Camisa' 
AND fecha BETWEEN '2020-10-01' AND '2020-10-31'
;




--6)
-- tiendas que realizaron descuento de 50% sobre sandalias de nombre "El Pie fresco" o "La separadedos" y que hayan hecho descuentos en cualquier producto de tipo "Zapatilla"




SELECT * -- tomo como tienda a las tuplas completas de la tabla tienda
FROM tienda
WHERE id IN(
SELECT tienda
FROM venta 
WHERE descuento = 50 AND producto IN(
SELECT id
FROM producto
WHERE nombre = 'El pie fresco' OR nombre = 'La separadedos'))
INTERSECT
SELECT * -- tomo como tienda a las tuplas completas de la tabla tienda
FROM tienda
WHERE id IN(
SELECT tienda
FROM venta 
WHERE producto IN(
SELECT id
FROM producto
WHERE tipo = 'Zapatilla'))
;




--7)
--tiendas que venden trajes pero no corbatas


SELECT DISTINCT t.*
FROM tienda AS t
JOIN producto AS p
ON t.id = p.tienda
WHERE tipo = 'Traje' OR tipo = 'Corbata'
EXCEPT
SELECT DISTINCT t.*
FROM tienda AS t
JOIN producto AS p
ON t.id = p.tienda
WHERE tipo = 'Corbata'
;



--8)
-- nombre e id de las 3 tiendas con los productos mas caros



SELECT t.id, MAX(t.nombre) AS nombre_de_tienda 
FROM tienda AS t
JOIN producto AS p 
ON t.id = p.tienda
GROUP BY t.id
ORDER BY MAX(precio) DESC LIMIT 3
;



--9)
-- precio promedio de perfumes de nombre "Aromas del arrabal", segun el tamaño del local


SELECT p.nombre AS nombre_perfume, ROUND(AVG(p.precio)) AS precio_promedio, l.tamaño AS tamaño_del_local
FROM producto AS p
JOIN tienda AS t
    ON p.tienda = t.id
JOIN local AS l
    ON l.id = t.local
WHERE p.nombre = 'Aromas del arrabal'
GROUP BY p.nombre, l.tamaño
ORDER BY l.tamaño DESC
;





--10)

-- esta consulta muestra las 5 tiendas con mayor cantidad de venta y la sumatoria de pesos mas alta
--consideré al precio del producto con el descuento aplicado, y el descuento lo tomé como un INT que representa un porcentaje de descuento entre 0 y 100


CREATE VIEW tiendas_con_mas_venta AS			
SELECT venta.tienda AS id_tienda, MAX(tienda.nombre) AS nombre_tienda , COUNT(venta.tienda) AS cantidad_de_venta, SUM(producto.precio-producto.precio*descuento/100) AS suma_de_pesos
FROM tienda
JOIN producto
ON producto.tienda = tienda.id
JOIN venta
ON venta.tienda = producto.tienda
WHERE (date_part('month', fecha) = 9)
GROUP BY venta.tienda
ORDER BY cantidad_de_venta DESC, suma_de_pesos DESC LIMIT 5
;



--11)

--esta consulta obtiene los clientes por nombre, dni y telefono que gastaron mas de $100.000 mensuales y la sumatoria de sus compras con descuento aplicado
--consideré al precio del producto con el descuento aplicado, y el descuento lo tomé como un INT que representa un porcentaje de descuento entre 0 y 100

SELECT c.nombre, c.dni, c.telefono, EXTRACT('month' from fecha) AS mes, SUM(p.precio-p.precio*descuento/100) AS sumatoria_de_pesos
FROM cliente AS c
JOIN venta AS v
ON c.id = v.cliente
JOIN producto AS p
ON v.producto = p.id
GROUP BY c.nombre, c.dni, c.telefono, mes
HAVING SUM(p.precio) > 100000
;





--12)
-- empleados que trabajan en alguna de las 5 tiendas mas exitosas
-- consideré a las tiendas mas exitosas como las que mas cantidad de venta tiene

SELECT empleado.*
FROM empleado
JOIN tienda
ON empleado.id_tienda = tienda.id
JOIN producto
ON producto.tienda = tienda.id
JOIN venta
ON venta.tienda = producto.tienda
GROUP BY empleado.id, venta.tienda
ORDER BY COUNT(venta.tienda) DESC
LIMIT 5
;













--13)
-- empleados que viven en una misma direccion(convivientes)


SELECT e.id AS id_empleados_convivientes, e.nombre 
FROM empleado AS e
WHERE direccion IN (
SELECT direccion FROM empleado 
GROUP BY direccion
HAVING COUNT(*)>1)
;
            
            
   


            
--14)
-- dni de los clientes con sus respectivos puntos acumulados



SELECT dni, COUNT(venta.*) AS puntos_acumulados
FROM cliente
JOIN venta 
ON cliente.id = venta.cliente 
JOIN producto
ON venta.producto = producto.id 
WHERE producto.precio-producto.precio*venta.descuento/100 > 500
GROUP BY dni, date_part('year', venta.fecha)
;






--15)

-- tiendas y dias de apertura 

SELECT id, nombre, 
'lunes, miercoles y viernes' AS dias_de_apertura
FROM tienda
WHERE (id % 2) = 0
UNION
SELECT id , nombre, 
'martes, jueves y sabado' AS dias_de_apertura
FROM tienda 
WHERE (id % 2) = 1
ORDER BY dias_de_apertura
;
