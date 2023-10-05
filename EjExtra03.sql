-- A continuación, se deben realizar las siguientes consultas:
-- 1. Mostrar el nombre de todos los pokemon.
SELECT nombre FROM pokemon;

-- 2. Mostrar los pokemon que pesen menos de 10k.
SELECT nombre FROM pokemon
WHERE peso < 10;

-- 3. Mostrar los pokemon de tipo agua.
SELECT p.nombre AS "Pokemones agua" FROM pokemon p
INNER JOIN pokemon_tipo pt ON pt.numero_pokedex = p.numero_pokedex
INNER JOIN tipo t ON pt.id_tipo = t.id_tipo
WHERE t.nombre = "Agua";

-- 4. Mostrar los pokemon de tipo agua, fuego o tierra ordenados por tipo.
SELECT p.nombre AS nombre, t.nombre AS tipo FROM pokemon p
INNER JOIN pokemon_tipo pt ON pt.numero_pokedex = p.numero_pokedex
INNER JOIN tipo t ON pt.id_tipo = t.id_tipo
WHERE t.nombre IN ("Agua", "Fuego", "Tierra")
ORDER BY tipo;

-- 5. Mostrar los pokemon que son de tipo fuego y volador.
-- Solución usando Group BY número de pokemon, y que tenga la cantidad de tipos = 2 (siendo que buscamos que cumpla con los dos tipos en simultáneo)
SELECT p.nombre FROM pokemon p
INNER JOIN pokemon_tipo pt ON p.numero_pokedex = pt.numero_pokedex
INNER JOIN tipo t ON pt.id_tipo = t.id_tipo
WHERE t.nombre IN ("Fuego", "Volador")
GROUP BY pt.numero_pokedex
HAVING (COUNT(*) = 2);


-- 6. Mostrar los pokemon con una estadística base de ps mayor que 200.
SELECT * FROM pokemon p 
INNER JOIN estadisticas_base eb ON eb.numero_pokedex = p.numero_pokedex
WHERE eb.ps > 200;

-- 7. Mostrar los datos (nombre, peso, altura) de la prevolución de Arbok.
SELECT p.nombre, peso, altura FROM pokemon p
INNER JOIN estadisticas_base eb ON eb.numero_pokedex = p.numero_pokedex
INNER JOIN evoluciona_de ed ON ed.pokemon_origen = p.numero_pokedex
WHERE pokemon_evolucionado = (SELECT p.numero_pokedex FROM pokemon p WHERE p.nombre = "Arbok");
-- No entiendo porqué para llamar a las columnas del inner join del medio (peso, altura), NO TENGO que especificar el alias de la tabla. Sino se rompe.

-- 8. Mostrar aquellos pokemon que evolucionan por intercambio.
SELECT * FROM pokemon_forma_evolucion;
SELECT * FROM forma_evolucion;
SELECT * FROM tipo_evolucion;

SELECT p.nombre FROM pokemon p
INNER JOIN pokemon_forma_evolucion pfe ON p.numero_pokedex = pfe.numero_pokedex
INNER JOIN forma_evolucion fe ON pfe.id_forma_evolucion = fe.id_forma_evolucion
INNER JOIN tipo_evolucion te ON te.id_tipo_evolucion = fe.tipo_evolucion
WHERE te.tipo_evolucion = "Intercambio";

-- 9. Mostrar el nombre del movimiento con más prioridad.
-- Resuelto con MAX.
SELECT nombre FROM movimiento
WHERE prioridad = (SELECT MAX(prioridad) FROM movimiento);

-- Resuelto con ALL 
SELECT nombre FROM movimiento
WHERE prioridad >= ALL (SELECT prioridad FROM movimiento);

-- 10. Mostrar el pokemon más pesado.
-- Resuelto con ORDER BY y LIMIT en lugar de ALL o MAX.
SELECT p.nombre FROM pokemon p
ORDER BY peso DESC LIMIT 1;

-- 11. Mostrar el nombre y tipo del ataque con más potencia.
SELECT * FROM movimiento;
SELECT * FROM tipo;
SELECT * FROM tipo_ataque;

SELECT m.nombre, t.nombre, a.tipo  FROM movimiento m
INNER JOIN tipo t ON t.id_tipo = m.id_tipo
INNER JOIN tipo_ataque a ON a.id_tipo_ataque = t.id_tipo_ataque
WHERE m.potencia = (SELECT MAX(potencia) FROM movimiento);

-- 12. Mostrar el número de movimientos de cada tipo.
SELECT t.nombre, COUNT(*) AS cantidad FROM tipo t
INNER JOIN movimiento m ON t.id_tipo = m.id_tipo
GROUP BY t.nombre
ORDER BY cantidad DESC;

-- 13. Mostrar todos los movimientos que puedan envenenar.
SELECT * FROM movimiento_efecto_secundario;
SELECT * FROM efecto_secundario;

SELECT m.nombre FROM movimiento m
INNER JOIN movimiento_efecto_secundario mes ON mes.id_movimiento = m.id_movimiento
INNER JOIN efecto_secundario es ON mes.id_efecto_secundario = es.id_efecto_secundario
WHERE es.efecto_secundario LIKE "Env%";

-- 14. Mostrar todos los movimientos que causan daño, ordenados alfabéticamente por nombre.
SELECT * FROM movimiento
WHERE descripcion LIKE "%daño%"
ORDER BY nombre;

-- 15. Mostrar todos los movimientos que aprende pikachu.
SELECT * FROM pokemon_movimiento_forma;
SELECT * FROM movimiento;
SELECT * FROM pokemon;

SELECT m.nombre FROM movimiento m
INNER JOIN pokemon_movimiento_forma pmf ON m.id_movimiento = pmf.id_movimiento
INNER JOIN pokemon p ON pmf.numero_pokedex = p.numero_pokedex
WHERE p.nombre = "Pikachu";

-- 16. Mostrar todos los movimientos que aprende pikachu por MT (tipo de aprendizaje).
SELECT * FROM tipo_forma_aprendizaje;
SELECT * FROM forma_aprendizaje;
SELECT * FROM pokemon_movimiento_forma;

SELECT m.nombre FROM movimiento m
INNER JOIN pokemon_movimiento_forma pmf ON pmf.id_movimiento = m.id_movimiento
INNER JOIN pokemon p ON pmf.numero_pokedex = p.numero_pokedex
INNER JOIN forma_aprendizaje fa ON fa.id_forma_aprendizaje = pmf.id_forma_aprendizaje
INNER JOIN tipo_forma_aprendizaje tfa ON tfa.id_tipo_aprendizaje = fa.id_tipo_aprendizaje
WHERE tfa.tipo_aprendizaje = "MT" AND p.nombre = "Pikachu";

-- 17. Mostrar todos los movimientos de tipo normal que aprende pikachu por nivel.
SELECT m.nombre FROM movimiento m
INNER JOIN pokemon_movimiento_forma pmf ON pmf.id_movimiento = m.id_movimiento
INNER JOIN pokemon p ON pmf.numero_pokedex = p.numero_pokedex
INNER JOIN forma_aprendizaje fa ON fa.id_forma_aprendizaje = pmf.id_forma_aprendizaje
INNER JOIN tipo_forma_aprendizaje tfa ON tfa.id_tipo_aprendizaje = fa.id_tipo_aprendizaje
INNER JOIN nivel_aprendizaje na ON na.id_forma_aprendizaje = fa.id_forma_aprendizaje
INNER JOIN tipo t ON m.id_tipo = t.id_tipo
WHERE t.nombre = "Normal" AND p.nombre = "Pikachu";

-- 18. Mostrar todos los movimientos de efecto secundario cuya probabilidad sea mayor al 30%.
SELECT m.nombre, m.descripcion, es.efecto_secundario FROM movimiento m
INNER JOIN movimiento_efecto_secundario mes ON mes.id_movimiento = m.id_movimiento
INNER JOIN efecto_secundario es ON es.id_efecto_secundario = mes.id_efecto_secundario
WHERE mes.probabilidad > 30;

-- 19. Mostrar todos los pokemon que evolucionan por piedra.
SELECT * FROM forma_evolucion;
SELECT * FROM piedra;
SELECT * FROM pokemon_forma_evolucion;

SELECT p.nombre FROM pokemon p
INNER JOIN pokemon_forma_evolucion pfe ON pfe.numero_pokedex = p.numero_pokedex
INNER JOIN forma_evolucion fe ON pfe.id_forma_evolucion = fe.id_forma_evolucion
WHERE fe.id_forma_evolucion IN (SELECT id_forma_evolucion FROM piedra);

-- 20. Mostrar todos los pokemon que no pueden evolucionar.
SELECT p.nombre FROM pokemon p
LEFT OUTER JOIN pokemon_forma_evolucion pfe ON pfe.numero_pokedex = p.numero_pokedex
WHERE pfe.numero_pokedex IS NULL;


-- 21. Mostrar la cantidad de los pokemon de cada tipo.
SELECT t.nombre, COUNT(*) AS cantidad_pokemones FROM tipo t
INNER JOIN pokemon_tipo pt ON pt.id_tipo = t.id_tipo
INNER JOIN pokemon p ON pt.numero_pokedex = p.numero_pokedex 
GROUP BY t.nombre
ORDER BY cantidad_pokemones DESC;
