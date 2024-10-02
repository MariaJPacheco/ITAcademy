-- Sprint 2
-- Nivel 1
--  Ejercicio 1

-- ✔1) Muestra las principales características del esquema creado . 
-- ✔️2) Explica las diferentes tablas y variables que existen. 

-- ✏️ Aquí muestro las tablas que tiene el esquema:
SHOW TABLES;

-- ✏️ Ahora muestro las características de cada tabla por separado:
DESCRIBE company;
DESCRIBE transaction;

-- Ejercicio 2

-- 1) Listado de paises que están realizando compras:

-- ✏️ Seleccioné los valores únicos de la columna country.
-- Para poder sacar los países de la tabla company, pero de solo aquellas compañias que esten en la tabla transaction:
-- Hice el join relacionando las tablas por el id de la tabla company y company_id de la tabla de transacciones.

USE transactions;

SELECT DISTINCT c.country AS "Paises desde donde se realizan compras"
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0;


-- 2) Desde cuántos países se realizan las compras?

-- ✏️ Selecciono los valores distintos de la columna country y al mismo tiempo los cuento:

SELECT COUNT(DISTINCT c.country) AS "Numero de paises desde donde se realizan compras"
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0;

-- 3) Identifica a la compañía con la mayor media de ventas:

-- ✏️ Seleccion el nombre de la compañía de la tabla company y luego el monto de la tabla transaction sacandole el promedio al mismo tiempo
-- ✏️ Hago JOIN, agrupo por el nombre de la compañía, lo ordeno descendiente para que me quede arriba el promedio mas alto y luego limito a 1

SELECT c.company_name AS "Compañia con mayor media", ROUND(AVG(t.amount),2) AS Media
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.company_name
ORDER BY Media DESC
LIMIT 1;

-- Ejercicio 3: 
-- Utilizando sólo subconsultas (sin utilizar JOIN):

-- 1) Muestra todas las transacciones realizadas por empresas de Alemania:

-- ✏️Selecciono el id de las transacciones
-- ✏️Relaciono las tablas por el company_id en transaction y el id en company y filtro por country "Germany"

SELECT *
FROM transaction
WHERE company_id IN (SELECT id
					FROM company
					WHERE country = 'Germany');
                    
-- 2) Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones:

-- Hice el SELECT DISTINCT para ver los valores únicos de company_name que cumplan con el filtro del WHERE.
--  Usé una subconsulta en el WHERE para filtrar por las transacciones mayores a la media.

SELECT DISTINCT company_name AS "Compañías sobre la media"
FROM company
WHERE id IN (SELECT company_id
			FROM transaction
            WHERE amount >= (SELECT AVG(amount) FROM transaction));

-- 3) Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.

-- Selecciono los valores únicos de los nombres de las empresas de la tabla company
-- Hago un filtro para sacar aquellas que no cumplan en la siguiente condición:
-- lista de transacciones efectivas (es decir, transacciones no declinadas)

SELECT DISTINCT company_name AS "Compañías sin transacciones", id
FROM company
WHERE id NOT IN (SELECT company_id
				FROM transaction
				WHERE declined = 0);

-- 👀 Observamos que no hay valores en la lista, por lo que pasamos a comprobar:

-- Comprobamos que hay 100 diferentes compañias en la tabla company
SELECT COUNT(DISTINCT company_name) AS "Compañías"
FROM company;

-- Comprobamos que hay 100 diferentes compaías en la tabla transaction
SELECT COUNT(DISTINCT company_id) AS "Compañías"
FROM transaction;

-- Comprobamos que hay 87 compañias que sus operaciones han sido declinadas
SELECT COUNT(DISTINCT company_id) AS "Compañías"
FROM transaction
 WHERE declined = 1;

-- Comprobamos que hay 100 compañias que sus operaciones no han sido declinadas
SELECT COUNT(DISTINCT company_id) AS "Compañías"
FROM transaction
 WHERE declined = 0;

-- La conclusión a la que llego es que la consulta no trae ningún nombre de compañía ya que todas las empresas cuentan con transacciones efectivas, eso lo comprobamos
-- al verificar que hay 100 distintos nombres en la tabla company y 100 distintos nombres en con transacciones 0 (no declinadas/efectivas) en la tabla transaction
-- por lo cual no hay empresas sin transacciones registradas. Se podría propoponer como alternativa eliminar aquellas empresas que desde cierta fecha no hayan 
-- realizado transacciones.

-- Nivel 2

-- Ejercicio 1
-- Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. Muestra la fecha de cada transacción junto con el total de las ventas.
SELECT DATE(timestamp) AS Fecha, COUNT(ID) AS NumVentas, SUM(amount) AS Monto
FROM transaction
WHERE declined = 0
GROUP BY Fecha
ORDER BY Monto DESC
LIMIT 5;

-- Ejercicio 2
-- ¿Cuál es la media de ventas por país? Presenta los resultados ordenados de mayor a menor medio.
-- ✏️Selección el COUNTRY de la tabla compaía, y seleccioné y al mismo tiempo saqué el promedio del AMOUNT de la tabla TRANSACTION.
-- hice el JOIN, agrupé por paises y ordené de mayor a menor por el promedio.
SELECT c.country AS Paises, ROUND(AVG(t.amount),2) AS Promedio
FROM company c
JOIN transaction t
ON c.id = t.company_id
GROUP BY Paises
ORDER BY Promedio DESC;

-- Ejercicio 3
-- En tu empresa, se plantea un nuevo proyecto para lanzar algunas campañas publicitarias para hacer competencia a la compañía “Non Institute”. 
-- Para ello, te piden la lista de todas las transacciones realizadas por empresas que están ubicadas en el mismo país que esta compañía.
-- 1) Muestra el listado aplicando JOIN y subconsultas.

-- Hice la seleccion de los datos de la tabla transaction
-- Hice el JOIN y en el WHERE filtré por el country para que nos traiga los que coincidan con el country de 'Non Institute'

SELECT t.*
FROM transaction t
JOIN company c
ON c.id = t.company_id
WHERE country = (SELECT country FROM company WHERE company_name = 'Non Institute'); 

-- 2) Muestra el listado aplicando solo subconsultas.
SELECT *
FROM transaction
WHERE company_id IN (SELECT id 
					FROM company
					WHERE country = (SELECT country 
									FROM company 
                                    WHERE company_name = 'Non Institute'));
                                    
-- Nivel 3

-- Ejercicio 1
-- Presenta el nombre, teléfono, país, fecha y amount, de aquellas empresas que realizaron transacciones con un valor comprendido entre 100 y 200 euros 
-- y en alguna de estas fechas: 29 de abril de 2021, 20 de julio de 2021 y 13 de marzo de 2022. Ordena los resultados de mayor a menor cantidad.

-- ✏️ Seleccioné los valores únicos de la columna company_name de la tabla company y los demás datos indicados
-- Hice un JOIN entre las tablas
-- Filtré por los montos y fechas indicadas 
-- Luego ordené de mayor a menor
         
SELECT DISTINCT c.company_name AS Empresas, c.phone, c.email, t.amount AS Monto
FROM company c
JOIN transaction t
ON c.id = t.company_id
WHERE t.amount BETWEEN 100 AND 200 AND DATE(t.timestamp) IN ('2021/04/29', '2021/07/20', '2022/03/13')
ORDER BY Monto DESC;


-- Ejercicio 2
-- Necesitamos optimizar la asignación de los recursos y dependerá de la capacidad operativa que se requiera, por lo que te piden la información 
-- sobre la ✔️cantidad de transacciones que realizan las empresas, pero el departamento de recursos humanos es exigente y quiere un ✔️listado de las 
-- empresas donde ✔️especifiques si tienen más de 4 o menos transacciones.

-- ✏️Primero seleccioné los nombres de las compañias conté las cantidades de transacciones.
-- dentro del mismo SELECT creé un CASE para crear la columna condicional en donde clasifico por el numero de transacciones.
-- finalicé el CASE con el END y le indiqué el nombre de la columna nueva.
-- Luego hice el JOIN de la dos tablas, agrupé por company_name y ordené por cantidad de transacciones de mayor a menor.

SELECT c.company_name AS Compañías, COUNT(t.id) AS Cantidad,
CASE WHEN COUNT(t.id) > 4 THEN 'Mayor a 4'
	 ELSE 'Menor o igual a 4' 
     END AS FranjaTransacciones
FROM company c
JOIN transaction t
ON c.id = t.company_id
GROUP BY c.company_name
ORDER BY Cantidad DESC;
