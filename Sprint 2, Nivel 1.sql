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

-- ✏️ ✔️ Selecciono los valores únicos de la columna country 
-- ️✏️ ✔️ Hago el join por company_id 
-- ✏️ ✔️ Finalmente agrupo por country.

SELECT DISTINCT company.country AS PaisesCompras
FROM company JOIN transaction
ON company.id = transaction.company_id
GROUP BY company.country;

-- 2) Desde cuántos países se realizan las compras?

-- ✏️ Selecciono los valores distintos de la columna country y al mismo tiempo los cuento:

SELECT COUNT(DISTINCT country) AS NumPaises
FROM company;

-- 3) Identifica a la compañía con la mayor media de ventas:

-- ✏️ Seleccion el nombre de la compaía de la tabla company y luego el monto de la tabla transaction sacandole el promedio al mismo tiempo
-- ✏️ Hago JOIN, agrupo por el nombre de la compañía, lo ordeno descendiente para que me quede arriba el promedio mas alto y luego limito a 1

SELECT company.company_name AS Compañia, AVG(transaction.amount) AS Promedio
FROM company JOIN transaction
ON company.id = transaction.company_id
GROUP BY company.company_name
ORDER BY promedio DESC
LIMIT 1;

-- Ejercicio 3: 
-- Utilizando sólo subconsultas (sin utilizar JOIN):

-- 1) Muestra todas las transacciones realizadas por empresas de Alemania:

-- ✏️Selecciono el id de las transacciones (que entiendo que es lo que debemos mostrar en este ejercicio)
-- ✏️Relaciono las tablas por el company_id en transaction y el id en company y filtro por country "Germany"

SELECT id AS TransaccionesAlemania
FROM transaction
WHERE company_id IN (SELECT id
					FROM company
					WHERE country = 'Germany');

-- 2) Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones:

-- ✏️Primero saco la media:

SELECT AVG(AMOUNT) FROM TRANSACTION;

-- ✏️Luego hago la subconsulta
SELECT DISTINCT company_name AS "Compañías sobre la media"
FROM company
WHERE id IN (SELECT company_id
					FROM transaction
					WHERE amount >= 256.735520)
ORDER BY company_name ASC;


-- 3) Eliminarán del sistema las empresas que carecen de transacciones registradas, entrega el listado de estas empresas.

-- ✏️CONTAMOS CUÁNTAS COMPAÑÍAS HAY EN LA TABLA COMPANY
SELECT COUNT(DISTINCT id) AS "Cantidad de compañías"
FROM company;

-- ✏️CONTAMOS LAS COMPAÑÍAS QUE HAN TENIDO TRANSACCIONES DECLINADAS
SELECT COUNT(DISTINCT company_id) AS "Compañías con transacciones declinadas"
FROM transaction
WHERE declined = 1;
-- ✏️HAY 87 DECLINADOS

-- ✏️AHORA CONTAMOS LOS NO DECLINADOS
SELECT COUNT(DISTINCT company_id) AS "Compañías con transacciones no declinadas"
FROM transaction
WHERE declined = 0;      
-- ✏️PERO HAY 100 SIN DECLINAR, ESTO QUIERE DECIR QUE TODAS LAS COMPAÑÍAS TIENEN TRANSACCIONES, YA QUE EN LA TABLA DE COMPAÑIAS TAMBIÉN HAY 100.

-- ✏️Ahora aplicamos el código respectivo, una vez teniendo analizados los datos:
SELECT DISTINCT company_name AS "Compañías sin transacciones"
FROM company
WHERE id NOT IN (SELECT company_id
					FROM transaction);
-- 👀 Vemos que el resultado el 0, tal como lo comprobamos anteriormente. Por ello la tabla se muestra vacía.